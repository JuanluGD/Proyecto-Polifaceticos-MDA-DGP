import 'package:path/path.dart';
import 'package:proyecto/bd_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/classes/Execute.dart';
import 'package:proyecto/classes/Task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/*
HU 7: Como administrador quiero poder eliminar una tarea de la lista de tareas pendientes de un estudiante.
*/

void main() {
  // Inicializar sqflite para que funcione con sqflite_common_ffi
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('Pruebas sobre Base de Datos', () {
    // Datos de la tarea
    int taskId = 0;
    String date = '2025-12-12';

    // Datos del estudiante
    String studentUser = 'juan123';

    Execute? execute_obtenido;

    setUp(() async {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'colegio.db');

      // Eliminar la base de datos antes de cada prueba
      if (await databaseExists(path)) {
        await deleteDatabase(path);
      }

      // Insertar un estudiante para la prueba
      await insertStudent(studentUser, 'Juan', 'Pérez', '1234',
          'assets/perfiles/chico.png', 'alphanumeric', 1, 1, 1);
      insertTask('taskname', 'taskdescription', 'assets/logo.png',
          'assets/logo.png', 'descriptive_text');

      // Obtener el task usando getTaskByName(String name) para obtener el id y pasarlo a insertExecute( ... )
      Task? tarea = await getTaskByName('taskname');

      // Obterner execute insertado
      await insertExecute(tarea!.id, studentUser, 0, date);

      execute_obtenido = await getExecute(tarea!.id, studentUser, date);
    });

    test(
        'Al eliminar una tarea pendiente de un estudiante, no aparece en la lista',
        () async {
      expect(await deleteExecute(execute_obtenido!), true);
      expect(await getStudentExecutes(studentUser), isEmpty);
    });
  });
}
