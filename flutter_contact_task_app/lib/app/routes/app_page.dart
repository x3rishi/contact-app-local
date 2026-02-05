import 'package:flutter_contact_task_app/app/views/contact_form/contact_form_view.dart';
import 'package:flutter_contact_task_app/app/views/home/home_view.dart';
import 'package:get/get.dart';

import '../bindings/contact_binding.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.HOME;

  static final routes = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: ContactBinding(),
    ),
    GetPage(
      name: AppRoutes.CONTACT_FORM,
      page: () => const ContactFormView(),
      binding: ContactBinding(),
    ),
  ];
}
