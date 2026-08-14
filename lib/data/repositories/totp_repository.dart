import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/models/totp_item.dart';
import '../../core/constants/app_constants.dart';

class TotpRepository {
  final FlutterSecureStorage _storage;

  TotpRepository({FlutterSecureStorage? storage}) 
    : _storage = storage ?? const FlutterSecureStorage();

  Future<List<TotpItem>> getItems() async {
    final String? jsonStr = await _storage.read(key: AppConstants.accountsStorageKey);
    if (jsonStr == null || jsonStr.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(jsonStr);
      return decoded.map((e) => TotpItem.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveItems(List<TotpItem> items) async {
    final String jsonStr = jsonEncode(items.map((e) => e.toJson()).toList());
    await _storage.write(key: AppConstants.accountsStorageKey, value: jsonStr);
  }

  Future<void> addItem(TotpItem item) async {
    final items = await getItems();
    items.add(item);
    await saveItems(items);
  }

  Future<void> updateItem(TotpItem updatedItem) async {
    final items = await getItems();
    final index = items.indexWhere((element) => element.id == updatedItem.id);
    if (index != -1) {
      items[index] = updatedItem;
      await saveItems(items);
    }
  }

  Future<void> deleteItem(String id) async {
    final items = await getItems();
    items.removeWhere((element) => element.id == id);
    await saveItems(items);
  }
}
