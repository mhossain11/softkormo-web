import 'package:get/get.dart';

import '../../../core/services/firebase_service.dart';
import '../../../shared/models/project_model.dart';

/// Filtering logic for the Projects page.
class ProjectsController extends GetxController {
  final RxString activeCategory = 'All'.obs;
  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxBool isLoading = false.obs;

  static const List<String> categories = [
    'All',
    'Mobile Apps',
    'Web Apps',
    'Backend',
    'Data Analytics',
  ];

  List<ProjectModel> get filtered => activeCategory.value == 'All'
      ? projects
      : projects.where((p) => p.category == activeCategory.value).toList();

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }

  Future<void> loadProjects() async {
    isLoading.value = true;
    try {
      final snapshot = await FirebaseService.db
          .collection('projects')
          .orderBy('year', descending: true)
          .limit(24)
          .get();

      if (snapshot.docs.isNotEmpty) {
        projects.value = snapshot.docs.map(ProjectModel.fromDoc).toList();
      } else {
        projects.value = ProjectModel.seed;
      }
    } catch (e) {
      // Offline / not-configured → ship seed content so the page never breaks.
      projects.value = ProjectModel.seed;
    } finally {
      isLoading.value = false;
    }
  }

  void setCategory(String category) => activeCategory.value = category;
}
