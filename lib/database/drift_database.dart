import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:flutter_calendar/model/category_color.dart';
import 'package:flutter_calendar/model/schedule.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// private 값도 불러올 수 있다.
part 'drift_database.g.dart';

@DriftDatabase(
  tables: [
    Schedules,
    CategoryColors,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase(): super(_openConnection());

  Future<int> createSchedule(SchedulesCompanion data) => into(schedules).insert(data);
  Future<int> createCategoryColor(CategoryColorsCompanion data) => into(categoryColors).insert(data);
  Future<List<CategoryColor>> getCategoryColors() => select(categoryColors).get();

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase(file);
  });
}