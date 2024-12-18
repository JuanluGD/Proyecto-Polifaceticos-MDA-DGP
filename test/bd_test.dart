import 'package:proyecto/bd_utils.dart';
import 'package:proyecto/bd.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/classes/ImgCode.dart';

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
  });
}
