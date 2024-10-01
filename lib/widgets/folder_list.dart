// lib/widgets/folder_list.dart

import 'package:flutter/material.dart';
import '../models/folder.dart';
import '../screens/folder_detail_screen.dart';

class FolderList extends StatelessWidget {
  final List<Folder> folders;

  const FolderList({required this.folders, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (folders.isEmpty) {
      return const Center(
        child: Text('No folders available.'),
      );
    }
    return ListView.builder(
      itemCount: folders.length,
      itemBuilder: (context, index) {
        final folder = folders[index];
        return ListTile(
          title: Text(folder.name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FolderDetailScreen(folder: folder),
              ),
            );
          },
        );
      },
    );
  }
}
