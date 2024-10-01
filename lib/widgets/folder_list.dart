// lib/widgets/folder_list.dart

import 'package:flutter/material.dart';
import '../models/folder.dart';
import '../screens/folder_detail_screen.dart';

class FolderList extends StatelessWidget {
  final List<Folder> folders;
  final Function(String)? onDelete;

  const FolderList({required this.folders, this.onDelete, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: folders.length,
      itemBuilder: (context, index) {
        final folder = folders[index];
        return ListTile(
          title: Text(folder.name),
          trailing: folder.isDefault
              ? null
              : IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    if (onDelete != null) {
                      onDelete!(folder.id);
                    }
                  },
                ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FolderDetailScreen(folderId: folder.id),
              ),
            );
          },
        );
      },
    );
  }
}
