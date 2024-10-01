// lib/providers/folder_provider.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/folder.dart';
import 'package:uuid/uuid.dart';

class FolderProvider extends ChangeNotifier {
  late Box<Folder> _folderBox;
  List<Folder> folders = [];
  String? _defaultFolderId;
  String? _archiveFolderId;

  FolderProvider() {
    init();
  }

  Future<void> init() async {
    _folderBox = Hive.box<Folder>('folders');
    folders = _folderBox.values.toList();

    // Ensure archive folder exists
    await _ensureArchiveFolder();

    // Identify default folder
    if (_folderBox.values.any((folder) => folder.isDefault)) {
      Folder defaultFolder =
          _folderBox.values.firstWhere((folder) => folder.isDefault);
      _defaultFolderId = defaultFolder.id;
    }

    notifyListeners();
  }

  Future<void> createDefaultFolder(String userName) async {
    // Check if default folder already exists
    if (_folderBox.values.any((folder) => folder.isDefault)) {
      Folder defaultFolder =
          _folderBox.values.firstWhere((folder) => folder.isDefault);
      _defaultFolderId = defaultFolder.id;
      return;
    }

    // Create default folder with user's name
    Folder defaultFolder = Folder(
      id: const Uuid().v4(),
      name: userName,
      isDefault: true,
    );
    await _folderBox.add(defaultFolder);
    folders.add(defaultFolder);
    _defaultFolderId = defaultFolder.id;
    notifyListeners();
  }

  Future<void> _ensureArchiveFolder() async {
    if (_folderBox.values.any((folder) => folder.name == 'Archive')) {
      Folder archiveFolder =
          _folderBox.values.firstWhere((folder) => folder.name == 'Archive');
      _archiveFolderId = archiveFolder.id;
    } else {
      Folder archiveFolder = Folder(
        id: const Uuid().v4(),
        name: 'Archive',
        isDefault: false,
      );
      await _folderBox.add(archiveFolder);
      folders.add(archiveFolder);
      _archiveFolderId = archiveFolder.id;
    }
  }

  String getDefaultFolderId() {
    if (_defaultFolderId == null) {
      throw Exception(
          'Default folder ID is null. Please create a default folder.');
    }
    return _defaultFolderId!;
  }

  String getArchiveFolderId() {
    if (_archiveFolderId == null) {
      throw Exception('Archive folder ID is null.');
    }
    return _archiveFolderId!;
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
    if (folder != null && !folder.isDefault) {
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
