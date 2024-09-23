import 'package:hive/hive.dart';

part 'folder.g.dart';

@HiveType(typeId: 4)
class Folder extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<String> taskIds;

  Folder({
    required this.id,
    required this.name,
    this.taskIds = const [],
  });
}