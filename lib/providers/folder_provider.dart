// lib/providers/folder_provider.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/folder.dart';

class FolderProvider extends ChangeNotifier {
  late Box<Folder> _folderBox;
  List<Folder> folders = [];

  FolderProvider() {
    _init();
  }

  Future<void> _init() async {
    // Open the 'folders' box
    _folderBox = Hive.box<Folder>('folders');
    // Load existing folders
    folders = _folderBox.values.toList();
    notifyListeners();
  }

  void addFolder(Folder folder) {
    _folderBox.add(folder);
    folders = _folderBox.values.toList();
    notifyListeners();
  }

  void updateFolder(Folder folder) {
    folder.save();
    folders = _folderBox.values.toList();
    notifyListeners();
  }

  void deleteFolder(String folderId) {
    final folder = folders.firstWhere((f) => f.id == folderId);
    folder.delete();
    folders = _folderBox.values.toList();
    notifyListeners();
  }
}