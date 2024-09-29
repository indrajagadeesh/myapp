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
    final folder = _folderBox.values.firstWhere((f) => f.id == folderId);
    if (folder.isDefault) {
      // Prevent deletion of default folder
      return;
    }
    folder.delete();
    folders = _folderBox.values.toList();
    notifyListeners();
  }

  Folder getDefaultFolder() {
    return _folderBox.values.firstWhere(
      (folder) => folder.isDefault,
      orElse: () {
        // Create and return a default folder if it doesn't exist
        final newFolder = Folder(
          id: Uuid().v4(),
          name: 'Default',
          isDefault: true,
        );
        _folderBox.add(newFolder);
        folders = _folderBox.values.toList();
        notifyListeners();
        return newFolder;
      },
    );
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