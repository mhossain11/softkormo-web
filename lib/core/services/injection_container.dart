import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../features/contact/contact_controller.dart';
import '../../features/projects/projects_controller.dart';
import 'firebase_service.dart';

final GetIt sl = GetIt.instance;

/// Service Locator (GetIt) for infrastructure-level dependencies.
/// Controllers stay in GetX — this only wires up services/repositories.
abstract class InjectionContainer {
  static Future<void> init() async {
    // Firebase is initialized before registration so anything injected
    // afterwards can rely on it being ready.
    await FirebaseService.initialize();

    sl.registerLazySingleton<FirebaseService>(() => FirebaseService());

    // Controllers used across pages.
    Get.put(ContactController(), permanent: true);
    Get.put(ProjectsController(), permanent: true);
  }
}
