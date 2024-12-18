import 'package:path/path.dart';
import 'package:proyecto/bd_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/classes/Execute.dart';
import 'package:proyecto/classes/Task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/*
  HU 10 Iter 3: Como administrador quiero poder acceder al historial de actividades realizadas de los estudiantes.
*/

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  String user = 'juan123';

  group('Pruebas sobre la BD.', () {
    setUp(() async {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'colegio.db');

      // Eliminar la base de datos antes de cada prueba
      if (await databaseExists(path)) {
        await deleteDatabase(path);
      }

      // Introducir usuario para la prueba
      await insertStudent(user, 'Juan', 'Pérez', '1234',
          'assets/perfiles/chico.png', 'alphanumeric', 1, 1, 1);
      // Inctroducir actividad para la prueba
      insertTask('taskname', 'taskdescription', 'assets/logo.png',
          'assets/logo.png', 'descriptive_text');
      insertTask('taskname2', 'taskdescription2', 'assets/logo2.png',
          'assets/logo2.png', 'descriptive_text2');

      Task? tarea1 = await getTaskByName('taskname');
      Task? tarea2 = await getTaskByName('taskname2');

      // Introducir executes asociados al usuario y una actividad para la prueba
      insertExecute(tarea1!.id, user, 0, '2025-12-12');
      insertExecute(tarea2!.id, user, 1, '2025-12-12'); // Execute done
    });

    test(
        'Como administrador quiero poder acceder al historial de actividades realizadas de los estudiantes',
        () async {
      // Obtener todas las tareas asociadas al estudiante
      List<Execute> all_executes = await getStudentExecutes(user);

      // Filtrar las tareas realizadas (status == 1)
      List<Execute> executes_done =
          all_executes.where((execute) => execute.status == 1).toList();

      // Comprobar que hay 1 actividad hecha (status ==  done)
      expect(executes_done!.length, 1);
    });
  });
}
