import 'package:proyecto/bd_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/interfaces/hu2.dart';
import 'package:path/path.dart';
import 'package:proyecto/bd.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// NO SE QUE LE PASA A ESTE FICHERO QUE NO ME PERMITE PROBAR LOS TEST DESDE AQUI
void main() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'colegio.db');
  group('Pruebas sobre Widgets', () {
    //test 1
    // QUE?
    testWidgets('Comprobar que se puede asignar cualquier interfaz a cualquier estudiante', (WidgetTester tester) async {
      // Monta la página de registro de estudiante
      await tester.pumpWidget(MaterialApp(home: StudentRegistrationPage()));

      // Encuentra el TextField de usuario por su etiqueta
      final userField = find.widgetWithText(TextField, 'Usuario*');

      // Introduce un texto con caracteres especiales
      await tester.enterText(userField, 'usuario@');

      // Re-renderiza el widget para procesar los cambios
      await tester.pump();

      // Verifica que el texto introducido no contenga caracteres especiales
      expect(find.text('usuario@'), findsNothing); // No debería mostrar el texto con el carácter especial.
      expect(find.text('usuario'), findsOneWidget); // El campo debería mostrar solo el texto válido.
    });
    //test 2
    testWidgets('Comprobar que se puede acceder correctamente a la pantalla de gestión de estudiantes', (WidgetTester tester) async {

    });

    testWidgets('Comprobar que se puede acceder correctamente a la pantalla de configuración de datos de estudiante', (WidgetTester tester) async {

    });
  });

  group('Pruebas sobre Base de Datos', () async {

      
      setUp(() async {
        if (await databaseExists(path)) {
          deleteDatabase(path);
        }
        await registerStudent('juan123', 'Juan', 'Pérez', 'password123', 'assets/perfiles/chico.png', 'alphanumeric', 1, 1, 1);
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