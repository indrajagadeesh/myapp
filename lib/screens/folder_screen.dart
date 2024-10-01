// lib/screens/folder_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/folder_provider.dart';
import '../models/folder.dart';
import 'package:uuid/uuid.dart';

class FolderScreen extends StatelessWidget {
  const FolderScreen({Key? key}) : super(key: key);

  void _showAddFolderDialog(
      BuildContext context, FolderProvider folderProvider) {
    final TextEditingController folderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Folder'),
          content: TextField(
            controller: folderNameController,
            decoration: const InputDecoration(hintText: 'Folder Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                folderNameController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String folderName = folderNameController.text.trim();
                if (folderName.isNotEmpty) {
                  final newFolder = Folder(
                    id: const Uuid().v4(),
                    name: folderName,
                  );
                  folderProvider.addFolder(newFolder);
                  folderNameController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(
      BuildContext context, FolderProvider folderProvider, String folderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Folder'),
          content: const Text('Are you sure you want to delete this folder?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                folderProvider.deleteFolder(folderId);
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final folderProvider = Provider.of<FolderProvider>(context);
    final List<Folder> folders = folderProvider.folders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Folders'),
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
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _confirmDelete(context, folderProvider, folder.id);
                    },
                  ),
                IconButton(
                  icon: Icon(folder.isDefault ? Icons.star : Icons.star_border),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
