import 'package:path/path.dart';
import 'package:proyecto/bd_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/classes/Execute.dart';
import 'package:proyecto/classes/Task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/*
  HU11. Como estudiante quiero poder confirmar la realización de una tarea.
  Pruebas:
  1. Al confirmar la realización de una tarea, se actualiza el estado de la tarea a realizada.
  2. Al confirmar la realización de una tarea, se elimina de la lista de tareas pendientes.
*/

void main() {
  // Inicializar sqflite para que funcione con sqflite_common_ffi
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  Execute? execute_obtenido;
  int? id_tarea;
  String user = 'juan123';
  String date = '2025-12-12';

  group('Pruebas sobre la Base de Datos', () {
    setUpAll(() async {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'colegio.db');

      // Eliminar la base de datos antes de cada prueba
      if (await databaseExists(path)) {
        await deleteDatabase(path);
      }

      // String user = 'juan123';
      // String date = '2025-12-12';

      // Insertar un estudiante para la prueba
      await insertStudent(user, 'Juan', 'Pérez', '1234',
          'assets/perfiles/chico.png', 'alphanumeric', 1, 1, 1);

      //Insertar una tarea para la prueba
      insertTask('taskname', 'taskdescription', 'assets/logo.png',
          'assets/logo.png', 'descriptive_text');

      // Obtener el task usando getTaskByName(String name) para obtener el id y pasarlo a insertExecute( ... )
      Task? tarea = await getTaskByName('taskname');

      id_tarea = tarea!.id;
      //Insertar un execute para la prueba
      insertExecute(tarea!.id, user, 0, date);

      execute_obtenido = await getExecute(tarea!.id, user, date);
    });

    // test(
    //   'Al confirmar la realización de una tarea, se actualiza el estado de la tarea a realizada.',
    //   () async {
    //     // Realizar la actualización de estado de la tarea
    //     bool resultado = await modifyExecuteStatus(execute_obtenido!, 1);

    //     // Verificar si la actualización fue exitosa
    //     expect(resultado, true);

    //     // Obtener nuevamente el execute para comprobar el estado
    //     execute_obtenido = await getExecute(id_tarea!, user, date);

    //     // Verificar que el estado se ha actualizado a 1 (realizada)
    //     expect(execute_obtenido!.status, 1);
    //   },
    // );

    test(
        'Al confirmar la realización de una tarea, se elimina de la lista de tareas pendientes.',
        () async {
      // Cantidad de tareas pendientes antes de la actualización
      // int tareas_pendientes_inicio = await getStudentToDo(user).length;
      List<Execute> tareas_pendientes_inicio = await getStudentToDo(user);

      // Realizar la actualización de estado de la tarea
      bool resultado = await modifyExecuteStatus(execute_obtenido!, 1);

      // Cantidad de tareas pendientes después de la actualización
      // int tareas_pendientes_fin = (await getStudentToDo(user)).length;
      List<Execute> tareas_pendientes_fin = await getStudentToDo(user);

      // Verificar que la actualización fue exitosa
      expect(resultado, true);

      // int diferencia_cantidad_tareas =
      //     tareas_pendientes_inicio.length! - tareas_pendientes_fin.length!;

      // Verificar que la cantidad de tareas pendientes disminuyó en 1
      expect(
          tareas_pendientes_inicio!.length - tareas_pendientes_fin!.length, 1);

      // Verificar que la tarea ya no se muestra en la lista de tareas pendientes
    });
  });

  // test(
  //     'Al confirmar la realización de una tarea, se elimina de la lista de tareas pendientes.',
  //     () {});
  // });
}
