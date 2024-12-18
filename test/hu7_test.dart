import 'package:path/path.dart';
import 'package:proyecto/bd.dart';
import 'package:proyecto/bd_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/classes/Execute.dart';
import 'package:proyecto/classes/Task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/*
HU 7: Como administrador quiero poder asignar una tarea a un alumno.
*/

void main() {
  group('Pruebas sobre Base de Datos', () {
    setUp(() async {
      try {
        // Forzar la inicialización de una nueva base de datos
        await ColegioDatabase.instance.database;

        // Insertar datos de prueba
        await insertStudent('juan123','Juan','Pérez','1234','assets/perfiles/chico.png','alphanumeric',1,1,1);
      } catch (e) {
        rethrow;
      }
    });

    tearDown(()async{
      await deleteStudent('juan123');
    });

    // Test 1
    test('Verificar que la tarea asignada aparece en la lista de tareas del estudiante.', () async {
      await insertExecute(3, 'juan123', 0, '2022-12-02');
      final tasks = await getStudentExecutes('juan123');
      expect(tasks.length, 1);
      expect(tasks.contains(Execute(task_id: 3, user: 'juan123', status: 0, date: '2022-12-02')), true);
    });

  });
}
