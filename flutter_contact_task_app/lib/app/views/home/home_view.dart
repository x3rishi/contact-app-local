import 'package:flutter/material.dart';
import 'package:flutter_contact_task_app/app/routes/app_routes.dart';
import 'package:flutter_contact_task_app/app/views/home/widget/contact_card.dart';
import 'package:get/get.dart';
import '../../controllers/contact_controller.dart';

class HomeView extends GetView<ContactController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact app'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'new') {
                Get.toNamed(AppRoutes.CONTACT_FORM);
              } else if (value == 'sort') {
                controller.sortContacts();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'new',
                child: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('New contact'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'sort',
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha),
                    SizedBox(width: 8),
                    Text('Sort'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) => controller.updateSearchQuery(value),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator.adaptive());
              }

              final contactsToShow = controller.filteredContacts;

              if (contactsToShow.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: contactsToShow.length,
                itemBuilder: (context, index) {
                  final contact = contactsToShow[index];
                  return ContactCard(
                    contact: contact,
                    onDelete: () => _showDeleteDialog(contact.id),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.CONTACT_FORM),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.contacts_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            controller.searchQuery.value.isEmpty
                ? 'No contacts yet'
                : 'No contacts found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          if (controller.searchQuery.value.isEmpty)
            TextButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.CONTACT_FORM),
              icon: const Icon(Icons.add),
              label: const Text('Add your first contact'),
            ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String contactId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Contact'),
        content: const Text('Are you sure you want to delete this contact?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteContact(contactId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
