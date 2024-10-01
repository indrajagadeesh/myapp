// lib/providers/folder_provider.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/folder.dart';
import 'package:uuid/uuid.dart';

class FolderProvider extends ChangeNotifier {
  late Box<Folder> _folderBox;
  List<Folder> folders = [];

  FolderProvider() {
    _init();
  }

  Future<void> _init() async {
    _folderBox = Hive.box<Folder>('folders');
    folders = _folderBox.values.toList();
    // Ensure a default folder exists
    if (!_folderBox.values.any((folder) => folder.isDefault)) {
      final defaultFolder = Folder(
        id: const Uuid().v4(),
        name: 'Default',
        isDefault: true,
      );
      _folderBox.add(defaultFolder);
      folders = _folderBox.values.toList();
    }
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
    Folder? folder;
    try {
      folder = _folderBox.values.firstWhere((f) => f.id == folderId);
    } catch (e) {
      folder = null;
    }
    if (folder != null && !folder.isDefault) {
      folder.delete();
      folders = _folderBox.values.toList();
      notifyListeners();
    }
  }

  Folder? getDefaultFolder() {
    try {
      return _folderBox.values.firstWhere((folder) => folder.isDefault);
    } catch (e) {
      return null;
    }
  }

  void setDefaultFolder(String folderId) {
    for (var folder in _folderBox.values) {
      if (folder.id == folderId) {
        folder.isDefault = true;
      } else {
        folder.isDefault = false;
      }
      folder.save();
    }
    folders = _folderBox.values.toList();
    notifyListeners();
  }
}
