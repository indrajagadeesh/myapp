// lib/screens/folder_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/folder_provider.dart';
import '../models/folder.dart';
import 'package:uuid/uuid.dart';

class FolderScreen extends StatelessWidget {
  final TextEditingController _folderNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final folderProvider = Provider.of<FolderProvider>(context);
    final List<Folder> folders = folderProvider.folders;

    return Scaffold(
      appBar: AppBar(
        title: Text('Folders'),
      ),
      body: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          final folder = folders[index];
          return ListTile(
            title: Text(folder.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!folder.isDefault)
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _confirmDelete(context, folderProvider, folder.id);
                    },
                  ),
                IconButton(
                  icon: Icon(
                      folder.isDefault ? Icons.star : Icons.star_border),
                  onPressed: () {
                    folderProvider.setDefaultFolder(folder.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFolderDialog(context, folderProvider);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddFolderDialog(BuildContext context, FolderProvider folderProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Folder'),
          content: TextField(
            controller: _folderNameController,
            decoration: InputDecoration(hintText: 'Folder Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _folderNameController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String folderName = _folderNameController.text.trim();
                if (folderName.isNotEmpty) {
                  final newFolder = Folder(
                    id: Uuid().v4(),
                    name: folderName,
                  );
                  folderProvider.addFolder(newFolder);
                  _folderNameController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, FolderProvider folderProvider, String folderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Folder'),
          content: Text('Are you sure you want to delete this folder?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                folderProvider.deleteFolder(folderId);
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}