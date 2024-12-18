import 'package:proyecto/bd_utils.dart';
import 'package:proyecto/bd.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/classes/Execute.dart';

void main() {
  group('Pruebas sobre Base de Datos', (){
    setUp(() async {
      try {
        // Forzar la inicialización de una nueva base de datos
        await ColegioDatabase.instance.database;

        await insertStudent('juan123','Juan','Pérez','1234','assets/perfiles/chico.png','alphanumeric',1,1,1);
        await insertExecute(2, 'juan123', 0, '2024-12-12');
        await modifyExecuteStatus(Execute(task_id: 2, user: 'juan123', status: 0, date: '2024-12-12'), 1);
      } catch (e) {
        rethrow;
      }
    });

    tearDown(()async{
      await deleteStudent('juan123');
    });
    //test 1
    test('Comprobar que se elimina la tarea de la interfaz del estudiante', () async {
      final executes = await getStudentToDo('juan123');
      expect(executes.length, 0);
    });

    test('Comprobar que se actualizan correctamente las tablas correspondientes en la base de datos', () async{
      final executes = await getStudentExecutes('juan123');
      expect(executes.contains(Execute(task_id: 2, user: 'juan123', status: 1, date: '2024-12-12')), true);

    });
  });
}