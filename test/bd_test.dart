import 'package:proyecto/bd_utils.dart';
import 'package:proyecto/bd.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/classes/Execute.dart';
import 'package:proyecto/classes/ImgCode.dart';
import 'package:proyecto/classes/Task.dart';

void main() {
  group('Pruebas sobre Base de Datos', () {
    //test 1
    test('Eliminacion de tuplas decrypt al eliminar un estudiante', () async {
      final db = await ColegioDatabase.instance.database;
      await db.delete(
        'Students',
        where: 'user = ?',
        whereArgs: ['pepe'],  // El valor del usuario que quieres eliminar
      );

      await insertStudent('pepe', 'Jose', '', 'azul.png_img', 'assets/perfiles/chico.png', 'images', 1, 0, 0);
      List<ImgCode> lista = [ImgCode(path: 'assets/picto_claves/azul.png', code: 'azul.png_picto')];
      await ColegioDatabase.instance.insertDecryptEntries('pepe',lista);

      await deleteStudent('pepe');

      expect(await getStudent('pepe'), null);
      expect(await ColegioDatabase.instance.getDecryptEntries('pepe'), isEmpty);

    });

    test('Eliminacion de tuplas execute al eliminar un estudiante', () async {
      final db = await ColegioDatabase.instance.database;
      await db.delete(
        'Students',
        where: 'user = ?',
        whereArgs: ['pepe'],  // El valor del usuario que quieres eliminar
      );

      await insertStudent('pepe', 'Jose', '', '1234', 'assets/perfiles/chico.png', 'alphanumeric', 1, 0, 0);
      Execute e = Execute(task_id: 2, user: 'pepe', status: 0, date: '2022-01-01');
      await ColegioDatabase.instance.insertExecute(e);

      await deleteStudent('pepe');

      expect(await getStudent('pepe'), null);
      expect(await ColegioDatabase.instance.getStudentExecutes('pepe'), isEmpty);

    });

    test('Eliminacion de tuplas steps al eliminar una tarea', () async {
      final db = await ColegioDatabase.instance.database;
      await db.delete(
        'Task',
        where: 'name = ?',
        whereArgs: ['Tarea'],  // El valor del usuario que quieres eliminar
      );
      await insertTask('Tarea', 'Tarea de prueba', 'assets/logo.png', 'assets/logo.png');
      Task task = (await getTaskByName('Tarea'))!;
      await insertStep(task.id, 'Paso 1', 'assets/logo.png', 'assets/logo.png');
      await insertStep(task.id, 'Paso 2', 'assets/logo.png', 'assets/logo.png');
      await insertStep(task.id, 'Paso 3', 'assets/logo.png', 'assets/logo.png');

      await deleteTask(task.id);

      expect(await getTaskByName('Tarea'), null);
      expect(await getAllStepsFromTask(task.id), isEmpty);

    });
  });
}
