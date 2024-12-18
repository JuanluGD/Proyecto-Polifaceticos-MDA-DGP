import 'package:proyecto/bd.dart';
import 'package:proyecto/bd_utils.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  group('Pruebas sobre Base de Datos', () {
    setUp(() async {
      try {
        // Forzar la inicialización de una nueva base de datos
        await ColegioDatabase.instance.database;

        // Insertar datos de prueba
        await insertStudent('juan123','Juan','Pérez','1234','assets/perfiles/chico.png','alphanumeric',1,1,1);
      } catch (e) {
        print("Error en setUp: $e");
        rethrow;
      }
    });

    tearDown(()async{
      await deleteStudent('juan123');
    });

      //test 1
      // COMO ESTAS COMPROBANDO ESTO?
      test('Comprobar que asignar la interfaz a un estudiante modifica al estudiante en la base de datos', () async {

        expect(await modifyInterfaceStudent('juan123', 0,0,1), true);
        final student = await getStudent('juan123');
        expect(student!.interfaceIMG, 0);
        expect(student.interfacePIC, 0);
        expect(student.interfaceTXT, 1);

      });
    });
  }