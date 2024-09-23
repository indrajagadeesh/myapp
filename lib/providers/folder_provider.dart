import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/folder.dart';

class FolderProvider with ChangeNotifier {
  late Box<Folder> _folderBox;

  List<Folder> get folders => _folderBox.values.toList();

  Future<void> init() async {
    _folderBox = await Hive.openBox<Folder>('folders');
    notifyListeners();
  }

  void addFolder(Folder folder) {
    _folderBox.put(folder.id, folder);
    notifyListeners();
  }

  void updateFolder(Folder folder) {
    _folderBox.put(folder.id, folder);
    notifyListeners();
  }

  void deleteFolder(String id) {
    _folderBox.delete(id);
    notifyListeners();
  }
}