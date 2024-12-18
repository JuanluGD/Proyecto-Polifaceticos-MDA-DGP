import 'package:path/path.dart';
import 'package:proyecto/bd_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/classes/Step.dart';
import 'package:proyecto/classes/Task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/*
  HU 8: Como administrador quiero poder crear una tarea por pasos.
  Pruebas:
    - Al crear una tarea por pasos, se pueden obtener todos los pasos de forma correcta.
    - Al crear una tarea por pasos, se pueden obtener los pasos en el orden correcto.
*/

void main() {
  // Inicializar sqflite para que funcione con sqflite_common_ffi
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  String taskname = 'taskname';
  String description1 = 'description1', description2 = 'description2';
  String pictogram1 = 'pictogram1', pictogram2 = 'pictogram2';
  String image1 = 'image1', image2 = 'image2';
  String desc_text1 = 'descriptive_text1', desc_text2 = 'descriptive_text2';

  group('Pruebas sobre la BD', () {
    setUp(() async {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'colegio.db');

      // Eliminar la base de datos antes de cada prueba
      if (await databaseExists(path)) {
        await deleteDatabase(path);
      }

      // Insertar una nueva tarea en la BD para la prueba
      await insertTask(taskname, 'taskdescription', 'pictogram', 'image',
          'descriptive_text');
    });

    test('Agregar pasos a la tarea y comprobar que se obtienen correctamente',
        () async {
      // Obtener tarea existente de la BD
      Task? tarea = await getTaskByName(taskname);

      // Se agregan las tareas correctamente
      expect(
          await insertStep(
              tarea!.id, description1, pictogram1, image1, desc_text1),
          true);
      expect(
          await insertStep(
              tarea!.id, description2, pictogram2, image2, desc_text2),
          true);

      // Crear tareas para compararlas con las obtenidas
      Step step1 = Step(
        id: 0,
        task_id: tarea.id,
        description: description1,
        pictogram: pictogram1,
        image: image1,
        descriptive_text: desc_text1,
      );

      Step step2 = Step(
        id: 1,
        task_id: tarea.id,
        description: description2,
        pictogram: pictogram2,
        image: image2,
        descriptive_text: desc_text2,
      );

      List<Step> steps = await getAllStepsFromTask(tarea!.id);

      // Comprobar que se obtiene el mismo numero de pasos que se han añadido
      expect(steps!.length, 2);

      // Comprobar que el orden en el que los pasos y su información son correctos
      expect(
          steps[0].task_id == tarea!.id &&
              steps[0].description == description1 &&
              steps[0].pictogram == pictogram1 &&
              steps[0].image == image1 &&
              steps[0].descriptive_text == desc_text1,
          true);
      expect(
          steps[1].task_id == tarea!.id &&
              steps[1].description == description2 &&
              steps[1].pictogram == pictogram2 &&
              steps[1].image == image2 &&
              steps[1].descriptive_text == desc_text2,
          true);
    });
  });
}
