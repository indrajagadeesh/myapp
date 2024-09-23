import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/folder_provider.dart';
import '../widgets/folder_list.dart';
import '../models/folder.dart';

class FolderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final folderProvider = Provider.of<FolderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Folders'),
      ),
      body: FolderList(folders: folderProvider.folders),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFolderDialog(context);
        },
        child: Icon(Icons.create_new_folder),
      ),
    );
  }

  void _showAddFolderDialog(BuildContext context) {
    final folderProvider = Provider.of<FolderProvider>(context, listen: false);
    final TextEditingController _nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create New Folder'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Folder Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  folderProvider.addFolder(Folder(
                    id: UniqueKey().toString(),
                    name: _nameController.text,
                  ));
                  Navigator.pop(context);
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}