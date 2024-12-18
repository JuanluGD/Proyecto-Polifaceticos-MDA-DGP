import 'package:path/path.dart';
import 'package:proyecto/bd_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/classes/Task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/*
  HU17: Como administrador quiero poder ver la información de una tarea cualquiera.
*/

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  String taskname = 'taskname';
  String description = 'description';
  String descriptive_text = 'descriptive_text';

  group('Pruebas sobre la BD', () {
    setUp(() async {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'colegio.db');

      // Eliminar la base de datos antes de cada prueba
      if (await databaseExists(path)) {
        await deleteDatabase(path);
      }

      // Insertar una nueva tarea en la BD
      await insertTask(
          taskname, description, 'pictogram', 'image', descriptive_text);
    });

    test('Se obtiene una descrición no nula y con valor esperado', () async {
      Task? tarea = await getTaskByName(taskname);
      expect(tarea!.description, isNotNull);
      expect(tarea!.description, description);
      expect(tarea!.descriptive_text, isNotNull);
      expect(tarea!.descriptive_text, descriptive_text);
    });
  });
}
