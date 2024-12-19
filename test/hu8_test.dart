import 'package:proyecto/bd.dart';
import 'package:proyecto/bd_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/classes/Step.dart';
import 'package:proyecto/classes/Task.dart';

/*
  HU 8: Como administrador quiero poder crear una tarea por pasos.
*/

void main() {
  group('Pruebas sobre Base de Datos', () {
    setUp(() async {
      try {
        // Forzar la inicialización de una nueva base de datos
        await ColegioDatabase.instance.database;

        // Insertar datos de prueba
        await insertTask('Tarea', 'Tarea de prueba', 'assets/logo.png', 'assets/logo.png');
        Task task = (await getTaskByName('Tarea'))!;
        await insertStep(task.id, 'Paso 1', 'assets/logo.png', 'assets/logo.png');
        await insertStep(task.id, 'Paso 2', 'assets/logo.png', 'assets/logo.png');
        await insertStep(task.id, 'Paso 3', 'assets/logo.png', 'assets/logo.png');
      } catch (e) {
        rethrow;
      }
    });

    tearDown(()async{
      Task task = (await getTaskByName('Tarea'))!;
      await deleteTask(task.id);
    });

    // Test 1
    test('Comprobar que se puede crear una tarea con varios pasos.', () async {
      Task? task = await getTaskByName('Tarea');
      List<Step> steps = await getAllStepsFromTask(task!.id);
      expect(task, isNotNull);
      expect(steps.length, 3);
    });

    test('Verificar que los pasos de la tarea se guardan correctamente en la base de datos.', () async {
      Task? task = await getTaskByName('Tarea');
      List<Step> steps = await getAllStepsFromTask(task!.id);
      expect(steps.contains(Step(id: 0, task_id: task.id, description: 'Paso 1', pictogram: 'assets/logo.png', image: 'assets/logo.png')), true);
      expect(steps.contains(Step(id: 1, task_id: task.id, description: 'Paso 2', pictogram: 'assets/logo.png', image: 'assets/logo.png')), true);
      expect(steps.contains(Step(id: 2, task_id: task.id, description: 'Paso 3', pictogram: 'assets/logo.png', image: 'assets/logo.png')), true);
      expect(steps.length, 3);
    });

  });
}
