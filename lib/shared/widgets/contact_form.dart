import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/widgets/gradient_button.dart';
import '../extensions/form_extensions.dart';
import '../../features/contact/contact_controller.dart';

/// Reusable, validated contact form backed by [ContactController].
/// Used on the Contact page and inside the home CTA dialog.
class ContactForm extends StatefulWidget {
  const ContactForm({super.key, this.showTitle = true});

  final bool showTitle;

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  late final ContactController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<ContactController>()
        ? Get.find<ContactController>()
        : Get.put(ContactController());
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 768;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140B3C88),
            blurRadius: 40,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Form(
        key: _controller.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showTitle) ...[
              Text(
                'Tell us about your project',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We reply to every enquiry within one business day.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXl),
            ],

            // ---------------------------------------------- name + email
            if (isWide)
              Row(
                children: [
                  Expanded(
                    child: _field(
                      context,
                      controller: _controller.nameController,
                      label: 'Full Name',
                      hint: 'Jane Doe',
                      icon: Icons.person_outline_rounded,
                      validator: _controller.validateName,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceMd),
                  Expanded(
                    child: _field(
                      context,
                      controller: _controller.emailController,
                      label: 'Email',
                      hint: 'jane@company.com',
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: _controller.validateEmail,
                    ),
                  ),
                ],
              )
            else
              _field(
                context,
                controller: _controller.nameController,
                label: 'Full Name',
                hint: 'Jane Doe',
                icon: Icons.person_outline_rounded,
                validator: _controller.validateName,
              ),

            if (!isWide) const SizedBox(height: AppDimensions.spaceMd),
            if (isWide) ...[
              const SizedBox(height: AppDimensions.spaceMd),

              // ----------------------------------------- phone + service
              Row(
                children: [
                  Expanded(
                    child: _field(
                      context,
                      controller: _controller.phoneController,
                      label: 'Phone',
                      hint: '+880 1XXX XXXXXX',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: _controller.validatePhone,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceMd),
                  Expanded(child: _serviceDropdown(context)),
                ],
              ),
            ] else ...[
              const SizedBox(height: AppDimensions.spaceMd),
              _field(
                context,
                controller: _controller.phoneController,
                label: 'Phone',
                hint: '+880 1XXX XXXXXX',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: _controller.validatePhone,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              _serviceDropdown(context),
            ],

            const SizedBox(height: AppDimensions.spaceMd),

            // ---------------------------------------------------- message
            TextFormField(
              controller: _controller.messageController,
              maxLines: 5,
              minLines: 4,
              validator: _controller.validateMessage,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Project details',
                hintText:
                    'What are you building? Timeline, goals, anything useful…',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            Text(
              'By submitting you agree to be contacted about your enquiry. '
              'We never share your data.',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
            ),

            const SizedBox(height: AppDimensions.spaceLg),

            // -------------------------------------------------------- CTA
            Obx(
              () => GradientButton(
                label: _controller.isLoading.value
                    ? 'Sending…'
                    : 'Send Message',
                icon: _controller.isLoading.value ? null : Icons.send_rounded,
                expanded: isWide,
                onPressed: _controller.isLoading.value
                    ? null
                    : _controller.submit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator ?? (v) => v.sanitized.requireNonEmpty(label),
      inputFormatters: [SanitizeFormatter()],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20, color: AppColors.textMuted),
      ),
    );
  }

  Widget _serviceDropdown(BuildContext context) {
    return Obx(
      () => DropdownButtonFormField<String>(
        // isExpanded: DropdownButton lays its IndexedStack (sized to the
        // widest item) out unbounded unless expanded — the internal Row
        // overflowed at every breakpoint without this (the reported 167px
        // in Poppins; up to 467px under the wider test font).
        isExpanded: true,
        initialValue: _controller.selectedService.value.isEmpty
            ? null
            : _controller.selectedService.value,
        validator: _controller.validateService,
        onChanged: (v) => _controller.selectedService.value = v ?? '',
        decoration: const InputDecoration(
          labelText: 'Service needed',
          hintText: 'Select a service',
          prefixIcon: Icon(Icons.widgets_outlined, size: 20),
        ),
        items: [
          for (final s in _controller.services)
            DropdownMenuItem(
              value: s,
              child: Text(s, overflow: TextOverflow.ellipsis),
            ),
        ],
      ),
    );
  }
}

/// Full contact section (map + form) reused across pages.
class ContactSection extends StatelessWidget {
  const ContactSection({super.key, this.showTitle = true});

  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 1024;

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Let’s build something smart together',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        Text(
          'Share your idea, backlog or bottleneck — we will come back with an '
          'honest plan, timeline and price.',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppDimensions.spaceXl),
        for (final row in const [
          (Icons.mail_outline_rounded, 'Email', 'hello@softkormo.com'),
          (Icons.phone_outlined, 'Phone', '+880 1700 000000'),
          (Icons.location_on_outlined, 'Office', 'Dhaka, Bangladesh'),
        ])
          Container(
            margin: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(row.$1, color: Colors.white, size: 21),
                ),
                const SizedBox(width: AppDimensions.spaceMd),
                // Flexible: non-flex Row children are laid out with
                // unbounded width, so the value text (e.g. the email)
                // overflowed this card at 360/768/1024. A flex child is
                // capped at the remaining free space and wraps instead.
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        row.$2,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Text(
                        row.$3,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );

    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          info,
          const SizedBox(height: AppDimensions.spaceLg),
          ContactForm(showTitle: showTitle),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: info),
        const SizedBox(width: AppDimensions.space2xl),
        Expanded(flex: 7, child: ContactForm(showTitle: showTitle)),
      ],
    );
  }
}
