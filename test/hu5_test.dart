import 'package:proyecto/bd_utils.dart';
import 'package:proyecto/bd.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Pruebas sobre Base de Datos', () {
    setUp(() async {
      try {
        // Forzar la inicialización de una nueva base de datos
        await ColegioDatabase.instance.database;

        // Insertar datos de prueba
        await insertStudent('juan123','Juan','Pérez','1234','assets/perfiles/chico.png','alphanumeric',1,1,1);
        await insertStudent('luciaaa22','Lucia','Muñoz','1111','assets/perfiles/chica.png','pictograms',1,0,1);
      } catch (e) {
        print("Error en setUp: $e");
        rethrow;
      }
    });

    tearDown(()async{
      await deleteStudent('juan123');
      await deleteStudent('luciaaa22');
    });
    //test 1
    test('Comprobar que los datos del estudiante se han modificado en la base de datos', () async {
      expect(await modifyCompleteStudent('juan123', 'Juan', 'Gomez', '1234', 'assets/perfiles/chico.png', 'alphanumeric', 0, 0, 1), true);
      final student = await getStudent('juan123');
      expect(student!.name, 'Juan');
      expect(student.surname, 'Gomez');
    });

    //test 2
    test('Comprobar que el usuario de un estudiante se ha modificado en la base de datos', () async {
      expect(await modifyUserStudent('juan123', 'juanito'), true);
      final student = await getStudent('juanito');
      expect(student!.user, 'juanito');
    });

    //test 3
    test('Comprobar que no se puede modificar el usuario a un usuario existente', () async {
      expect(await modifyUserStudent('juan123', 'luciaaa22'), false);
      final student = await getStudent('juan123');
      expect(student!.user, 'juan123');
    });
  });
}