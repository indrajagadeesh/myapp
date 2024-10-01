// lib/screens/folder_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/folder_provider.dart';
import '../widgets/folder_list.dart';
import '../models/folder.dart';
import 'add_task_screen.dart';
import 'folder_detail_screen.dart';
import 'package:uuid/uuid.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({Key? key}) : super(key: key);

  @override
  _FolderScreenState createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  final _formKey = GlobalKey<FormState>();
  String _folderName = '';

  void _addFolder() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Folder'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Folder Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a folder name';
                }
                return null;
              },
              onSaved: (value) {
                _folderName = value!;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  final folderProvider =
                      Provider.of<FolderProvider>(context, listen: false);
                  folderProvider.addFolder(Folder(
                    id: const Uuid().v4(),
                    name: _folderName,
                    isDefault: false,
                  ));
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _deleteFolder(String folderId) {
    final folderProvider = Provider.of<FolderProvider>(context, listen: false);
    folderProvider.deleteFolder(folderId);
  }

  @override
  Widget build(BuildContext context) {
    final folderProvider = Provider.of<FolderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Folders'),
      ),
      body: folderProvider.folders.isEmpty
          ? const Center(child: Text('No folders available.'))
          : FolderList(
              folders: folderProvider.folders,
              onDelete: _deleteFolder,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFolder,
        child: const Icon(Icons.create_new_folder),
      ),
    );
  }
}
