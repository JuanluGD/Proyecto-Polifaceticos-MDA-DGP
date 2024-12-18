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
        rethrow;
      }
    });

    tearDown(()async{
      await deleteStudent('juan123');
      await deleteStudent('luciaaa22');
    });

    test('Comprobar que se añaden correctamente en la bd los nuevos estudiantes', () async {
      final student1 = await getStudent('juan123');
      final student2 = await getStudent('luciaaa22');
      final students = await getAllStudents();
      expect(student1, isNotNull);
      expect(student2, isNotNull);
      expect(students.contains(student1), true);
      expect(students.contains(student2), true);
      expect(students.length, 5); 
    });

    test('Comprobar que no se añaden diferentes estudiantes con el mismo usuario', () async {
      String user = 'juan123';
      bool valid = await userIsValid(user);
      bool insert = await insertStudent(user, 'Juan', 'Gómez', '3254', 'assets/perfiles/chico.png', 'alphanumeric', 1, 1, 1);
      expect(valid, false);
      expect(insert, false);
      final students = await getAllStudents();
      expect(students.length, 5);
    });

    test('Comprobar que no se permite el uso de caracteres especiales en el usuario', () async {
      String formatInvalid = "juan!@#123";
      expect(userFormat(formatInvalid), false);
    });


  });

}
