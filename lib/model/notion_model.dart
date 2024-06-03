import 'package:flutter/material.dart';

class NotionItem {
  final String id;
  final String title;
  final String description;
  late bool isChecked;

  NotionItem(
      {required this.id,
      required this.title,
      required this.description,
      required this.isChecked});
}

class NotionListModel extends ChangeNotifier {
  List<NotionItem> _notionItems = [];

  List<NotionItem> get notionItems => _notionItems;

  void addItem(String title, String description, bool isChecked) {
    final newItem = NotionItem(
        id: DateTime.now().toString(),
        title: title,
        description: description,
        isChecked: isChecked);
    _notionItems.add(newItem);
    notifyListeners();
  }

  void updateItem(
      String id, String newTitle, String newDescription, bool isChecked) {
    final index = _notionItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _notionItems[index] = NotionItem(
          id: id,
          title: newTitle,
          description: newDescription,
          isChecked: isChecked);
      notifyListeners();
    }
  }

  void deleteItem(String id) {
    _notionItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
