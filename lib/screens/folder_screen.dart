// lib/screens/folder_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/folder_provider.dart';
import '../models/folder.dart';
import 'folder_detail_screen.dart';

class FolderScreen extends StatelessWidget {
  const FolderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final folderProvider = Provider.of<FolderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Folders'),
      ),
      body: ListView.builder(
        itemCount: folderProvider.folders.length,
        itemBuilder: (context, index) {
          final folder = folderProvider.folders[index];
          return ListTile(
            title: Text(folder.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FolderDetailScreen(folder: folder),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addFolderDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addFolderDialog(BuildContext context) {
    String folderName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Folder'),
          content: TextField(
            onChanged: (value) {
              folderName = value;
            },
            decoration: const InputDecoration(hintText: 'Folder Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (folderName.isNotEmpty) {
                  final folderProvider =
                      Provider.of<FolderProvider>(context, listen: false);
                  final newFolder = Folder(
                    id: const Uuid().v4(),
                    name: folderName,
                  );
                  folderProvider.addFolder(newFolder);
                }
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
