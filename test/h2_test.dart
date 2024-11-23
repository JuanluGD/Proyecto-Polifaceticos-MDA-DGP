import 'package:path/path.dart';
import 'package:proyecto/bd_utils.dart';
import 'package:proyecto/bd.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {

  group('Pruebas sobre Base de Datos', () async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'colegio.db');
    setUp(() async {
      if (await databaseExists(path)) {
        deleteDatabase(path);
      }

      await ColegioDatabase.instance.database;
      await insertStudent('juan123', 'Juan', 'Pérez', '1234', 'assets/perfiles/chico.png', 'alphanumeric', 1, 1, 1);
      await insertStudent('luciaaa22', 'Lucia', 'Muñoz', '1111', 'assets/perfiles/chica.png', 'pictograms', 1, 0, 1);
    });
    test('Comprobar que se añaden correctamente en la bd los nuevos estudiantes', () async {

      expect(getStudent('juan123'), isNotNull);
      expect(getStudent('luciaaa22'), isNotNull);
      expect(getAllStudents(), 2);
    });

    test('Comprobar que no se añaden diferentes estudiantes con el mismo usuario', () async {
      String user = 'juan123';
      expect(userIsValid(user), false);
      expect(await insertStudent(user, 'Juan', 'Gómez', '3254', 'assets/perfiles/chico.png', 'alphanumeric', 1, 1, 1), false);
      expect(getAllStudents(), 2);
    });

    test('Comprobar que no se permite el uso de caracteres especiales en el usuario', () async {

      String format_invalid = "juan!@#123";
      expect(userFormat(format_invalid), false);
    });
  });
}