import 'package:flutter/material.dart';
import '../models/folder.dart';
import '../screens/folder_detail_screen.dart';

class FolderList extends StatelessWidget {
  final List<Folder> folders;

  FolderList({required this.folders});

  @override
  Widget build(BuildContext context) {
    if (folders.isEmpty) {
      return Center(child: Text('No folders available.'));
    }
    return ListView.builder(
      itemCount: folders.length,
      itemBuilder: (context, index) {
        final folder = folders[index];
        return ListTile(
          leading: Icon(Icons.folder),
          title: Text(folder.name),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FolderDetailScreen(folderId: folder.id),
              ),
            );
          },
        );
      },
    );
  }
}