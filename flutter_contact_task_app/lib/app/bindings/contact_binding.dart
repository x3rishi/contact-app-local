import 'package:flutter_contact_task_app/app/controllers/contact_controller.dart';
import 'package:flutter_contact_task_app/app/services/storage_service.dart';
import 'package:get/get.dart';

class ContactBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize StorageService as a singleton
    Get.putAsync(() => StorageService().init(), permanent: true);

    // Initialize ContactController
    Get.lazyPut<ContactController>(() => ContactController());
  }
}
