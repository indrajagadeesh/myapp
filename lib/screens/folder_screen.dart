// lib/screens/folder_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/folder_provider.dart';
import '../models/folder.dart';

class FolderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final folderProvider = Provider.of<FolderProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Folders')),
      body: ListView.builder(
        itemCount: folderProvider.folders.length,
        itemBuilder: (context, index) {
          final folder = folderProvider.folders[index];
          return ListTile(
            title: Text(folder.name),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                folderProvider.deleteFolder(folder.id);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFolderDialog(context, folderProvider),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddFolderDialog(
      BuildContext context, FolderProvider folderProvider) {
    final _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Folder'),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Folder Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String name = _controller.text.trim();
              if (name.isNotEmpty) {
                Folder folder = Folder(id: Uuid().v4(), name: name);
                folderProvider.addFolder(folder);
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}