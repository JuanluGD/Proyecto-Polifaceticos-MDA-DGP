import 'package:proyecto/bd_utils.dart';
import 'dart:io';
import 'package:proyecto/bd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/hu2.dart';

void main() {
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

  group('Pruebas sobre Base de Datos', () {
    final db = ColegioDatabase.instance;

    setUp(() async {
      // Elimina el archivo físico de la base de datos (necesario para las pruebas)
      final dbPath = '/home/jesus/AndroidStudioProjects/Proyecto-Polifaceticos-MDA-DGP/.dart_tool/sqflite_common_ffi/databases/colegio.db';

      final dbFile = File(dbPath);
      if (await dbFile.exists()) {
        await dbFile.delete();
      }

      await db.database;
    });

    //test 1
    // DA ERROR
    test('Comprobar que asignar la interfaz a un estudiante modifica al estudiante en la base de datos', () async {

      bool isRegistered = await registerStudent('juan123', 'Juan', 'Pérez', 'password123', 'assets/perfiles/chico.png', 'alphanumeric', 1, 1, 1);
      expect(isRegistered, true);

      bool exists = await userIsValid('juan123');
      expect(exists,true);

    });
  });
}