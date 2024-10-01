// lib/models/folder.dart

import 'package:hive/hive.dart';

part 'folder.g.dart';

@HiveType(typeId: 6)
class Folder extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  bool isDefault;

  Folder({
    required this.id,
    required this.name,
    this.isDefault = false,
  });
}
