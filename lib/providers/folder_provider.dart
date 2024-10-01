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
    _folderBox = Hive.box<Folder>('folders');
    folders = _folderBox.values.toList();
    notifyListeners();
  }

  void addFolder(Folder folder) {
    _folderBox.add(folder);
    folders.add(folder);
    notifyListeners();
  }

  void deleteFolder(String folderId) {
    Folder? folder;
    try {
      folder = _folderBox.values.firstWhere((f) => f.id == folderId);
    } catch (e) {
      folder = null;
    }
    if (folder != null) {
      folder.delete();
      folders.removeWhere((f) => f.id == folderId);
      notifyListeners();
    }
  }

  void updateFolder(Folder folder) {
    folder.save();
    notifyListeners();
  }
}
