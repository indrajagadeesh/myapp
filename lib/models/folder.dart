// lib/models/folder.dart

import 'package:hive/hive.dart';

part 'folder.g.dart';

@HiveType(typeId: 3)
class Folder extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  bool isDefault; // New property to indicate default folder

  Folder({
    required this.id,
    required this.name,
    this.isDefault = false, // Defaults to false
  });
}