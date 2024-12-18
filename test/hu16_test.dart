import 'package:proyecto/bd.dart';
import 'package:proyecto/bd_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/classes/Execute.dart';
import 'package:proyecto/classes/Task.dart';


void main() {
  group('Pruebas sobre Base de Datos', (){
    late Task task;
    setUp(() async {
      try {
        // Forzar la inicialización de una nueva base de datos
        await ColegioDatabase.instance.database;

        await insertTask('Tarea', 'Tarea de prueba', 'assets/logo.png', 'assets/logo.png');
        task = (await getTaskByName('Tarea'))!;
        await insertStep(task.id, 'Paso 1', 'assets/logo.png', 'assets/logo.png');
        await insertStep(task.id, 'Paso 2', 'assets/logo.png', 'assets/logo.png');
        await insertStep(task.id, 'Paso 3', 'assets/logo.png', 'assets/logo.png');

        await insertStudent('juan123','Juan','Pérez','1234','assets/perfiles/chico.png','alphanumeric',1,1,1);
        await insertExecute(task.id, 'juan123', 0, '2024-12-12');
        await deleteTask(task.id);
      } catch (e) {
        rethrow;
      }
    });

    tearDown(()async{
      await deleteStudent('juan123');
    });
    //test 1
    test('Comprobar que se puede eliminar una tarea', () async {
      List<Task> tasks = await getAllTasks();
      expect(tasks.contains(task), false);
    });

    test('Verificar que las bases de datos asociadas borran toda su información', () async{
      List<Execute> executes = await getStudentExecutes('juan123');
      expect(executes.contains(task), false);
      expect(await getAllStepsFromTask(task.id), []);

    });
  });
}
