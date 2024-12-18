import 'package:proyecto/bd_utils.dart';
import 'package:proyecto/bd.dart';
import 'package:proyecto/classes/Execute.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {


  group('Pruebas sobre Base de Datos', () {
    late String date;
    setUp(() async {
      try {
        // Forzar la inicialización de una nueva base de datos
        await ColegioDatabase.instance.database;

        DateTime now = DateTime.now();
        date = '${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
        Execute execute = Execute(task_id: 1, user: 'alex123', status: 0, date: date);
        await deleteExecute(execute);
      } catch (e) {
        rethrow;
      }
    });


    //Test 1
    test('Comprobar que la tarea preestablecida “Tomar comandas para el menú del comedor” aparece disponible en la lista de tareas', () async {
      final task = await getTaskByName('Comedor');
      expect(task, isNotNull);
    });

    //Test 2
    test('Comprobar que la asignación de la tarea “Tomar comandas para el menú del comedor” se refleja correctamente en la base de datos del estudiante.', () async {
      await insertExecute(1, 'alex123', 0, date);
      final executes = await getStudentExecutes('alex123');
      expect(executes.contains(Execute( task_id: 1, user: 'alex123', status: 0, date: date)), true);
    });

  });
}