import 'package:flutter/material.dart';
import 'package:flutter_contact_task_app/app/common_widgets/common_filed.dart';
import 'package:get/get.dart';
import '../../controllers/contact_controller.dart';
import '../../models/contact_model.dart';

class ContactFormView extends GetView<ContactController> {
  const ContactFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactModel? contact = Get.arguments;
    final bool isEditing = contact != null;

    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: contact?.name ?? '');
    final emailController = TextEditingController(text: contact?.email ?? '');
    final mobileController = TextEditingController(text: contact?.mobile ?? '');

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit contact' : 'New contact')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTextField(
                controller: nameController,
                label: 'Name',
                hint: 'Enter name',
                icon: Icons.person,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              buildTextField(
                controller: emailController,
                label: 'Email address',
                hint: 'Enter email address',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter email address';
                  }
                  final emailRegex = RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  );
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Please enter valid email address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              buildTextField(
                controller: mobileController,
                label: 'Mobile number',
                hint: 'Enter mobile number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter mobile number';
                  }
                  if (value.trim().length != 10) {
                    return 'Please enter valid mobile number';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                    return 'Please enter valid mobile number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (formKey.currentState!.validate()) {
                    bool success;

                    if (isEditing) {
                      success = await controller.updateContact(
                        id: contact.id,
                        name: nameController.text,
                        email: emailController.text,
                        mobile: mobileController.text,
                      );
                    } else {
                      success = await controller.addContact(
                        name: nameController.text,
                        email: emailController.text,
                        mobile: mobileController.text,
                      );
                    }

                    if (success) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      await Future.delayed(const Duration(milliseconds: 100));

                      if (Get.isRegistered<ContactController>()) {
                        Navigator.of(context).pop();
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isEditing ? 'UPDATE' : 'SAVE',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
