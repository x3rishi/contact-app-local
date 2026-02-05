import 'dart:developer';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/contact_model.dart';
import '../services/storage_service.dart';

class ContactController extends GetxController {
  final StorageService _storageService = Get.put(StorageService());
  final _uuid = const Uuid();

  final RxList<ContactModel> contacts = <ContactModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSorted = false.obs;
  final RxString searchQuery = ''.obs;

  List<ContactModel> get filteredContacts {
    if (searchQuery.value.isEmpty) {
      return contacts;
    }

    final query = searchQuery.value.toLowerCase();
    return contacts.where((contact) {
      return contact.name.toLowerCase().contains(query) ||
          contact.email.toLowerCase().contains(query) ||
          contact.mobile.contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadContacts();
  }

  Future<void> loadContacts() async {
    try {
      isLoading.value = true;
      final loadedContacts = await _storageService.readAllContacts();
      contacts.value = loadedContacts;
      log('📱 Loaded ${contacts.length} contacts');
    } catch (e) {
      _showErrorSnackbar('Failed to load contacts');
      log('❌ Error loading contacts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addContact({
    required String name,
    required String email,
    required String mobile,
  }) async {
    try {
      final newContact = ContactModel(
        id: _uuid.v4(),
        name: name.trim(),
        email: email.trim(),
        mobile: mobile.trim(),
      );

      contacts.insert(0, newContact);

      final success = await _storageService.saveAllContacts(contacts);

      if (success) {
        _showSuccessSnackbar('Contact added successfully');
        log('✅ Added contact: ${newContact.name}');
        return true;
      } else {
        contacts.removeAt(0);
        _showErrorSnackbar('Failed to save contact');
        return false;
      }
    } catch (e) {
      _showErrorSnackbar('Failed to add contact');
      log('❌ Error adding contact: $e');
      return false;
    }
  }

  Future<bool> updateContact({
    required String id,
    required String name,
    required String email,
    required String mobile,
  }) async {
    try {
      final index = contacts.indexWhere((c) => c.id == id);

      if (index == -1) {
        _showErrorSnackbar('Contact not found');
        return false;
      }

      final oldContact = contacts[index];
      final updatedContact = oldContact.copyWith(
        name: name.trim(),
        email: email.trim(),
        mobile: mobile.trim(),
      );

      contacts[index] = updatedContact;

      final success = await _storageService.saveAllContacts(contacts);

      if (success) {
        _showSuccessSnackbar('Contact updated successfully');
        log('✅ Updated contact: ${updatedContact.name}');
        return true;
      } else {
        contacts[index] = oldContact;
        _showErrorSnackbar('Failed to save changes');
        return false;
      }
    } catch (e) {
      _showErrorSnackbar('Failed to update contact');
      log('❌ Error updating contact: $e');
      return false;
    }
  }

  Future<bool> deleteContact(String id) async {
    try {
      final index = contacts.indexWhere((c) => c.id == id);

      if (index == -1) {
        _showErrorSnackbar('Contact not found');
        return false;
      }

      final removedContact = contacts[index];
      contacts.removeAt(index);

      final success = await _storageService.saveAllContacts(contacts);

      if (success) {
        _showSuccessSnackbar('Contact deleted');
        log('🗑️ Deleted contact: ${removedContact.name}');
        return true;
      } else {
        contacts.insert(index, removedContact);
        _showErrorSnackbar('Failed to delete contact');
        return false;
      }
    } catch (e) {
      _showErrorSnackbar('Failed to delete contact');
      log('❌ Error deleting contact: $e');
      return false;
    }
  }

  void sortContacts() {
    contacts.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    isSorted.value = true;

    _showInfoSnackbar('Contacts sorted alphabetically');
    log('📊 Sorted ${contacts.length} contacts');
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  void _showInfoSnackbar(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
}
