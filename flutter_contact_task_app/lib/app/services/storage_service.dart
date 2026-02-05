import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../models/contact_model.dart';

class StorageService extends GetxService {
  static const String _contactsKey = 'contacts_secure_key';

  final _storage = const FlutterSecureStorage();

  Future<StorageService> init() async {
    log('🔐 StorageService initialized');
    return this;
  }

  Future<List<ContactModel>> readAllContacts() async {
    try {
      final contactsJson = await _storage.read(key: _contactsKey);

      if (contactsJson == null || contactsJson.isEmpty) {
        log('📭 No contacts found in storage');
        return [];
      }

      final List<dynamic> decoded = json.decode(contactsJson);
      final contacts = decoded
          .map((json) => ContactModel.fromJson(json))
          .toList();

      log('✅ Loaded ${contacts.length} contacts from storage');
      return contacts;
    } catch (e) {
      log('❌ Error reading contacts: $e');
      return [];
    }
  }

  Future<bool> saveAllContacts(List<ContactModel> contacts) async {
    try {
      final contactsJson = json.encode(
        contacts.map((contact) => contact.toJson()).toList(),
      );

      await _storage.write(key: _contactsKey, value: contactsJson);
      log('💾 Saved ${contacts.length} contacts to storage');
      return true;
    } catch (e) {
      log('❌ Error saving contacts: $e');
      return false;
    }
  }

  Future<bool> clearAllContacts() async {
    try {
      await _storage.delete(key: _contactsKey);
      log('🗑️ Cleared all contacts from storage');
      return true;
    } catch (e) {
      log('❌ Error clearing contacts: $e');
      return false;
    }
  }

  Future<bool> hasContacts() async {
    final contactsJson = await _storage.read(key: _contactsKey);
    return contactsJson != null && contactsJson.isNotEmpty;
  }
}
