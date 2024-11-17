import 'package:proyecto/bd_utils.dart';
import 'dart:io';
import 'package:proyecto/bd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/hu2.dart';

void main() {
  group('Pruebas sobre Widgets', () {

    //test 1
    // CAMBIAR, ESTE TEST SE HACE SOBRE EL BACKEND
    testWidgets('Comprobar que no se permite el uso de caracteres especiales en el usuario', (WidgetTester tester) async {
      // Monta la página de registro de estudiante
      await tester.pumpWidget(MaterialApp(home: StudentRegistrationPage()));

      // Encuentra el TextField de Usuario y de Nombre y el borón Siguiente por su etiqueta
      final userField = find.widgetWithText(TextField, 'Usuario*');
      final nameField = find.widgetWithText(TextField, 'Nombre*');
      final nextButton = find.widgetWithText(ElevatedButton, 'Siguiente');

      // Introduce un texto con caracteres especiales en el Usuario
      await tester.enterText(userField, '*nacho*');
      await tester.enterText(nameField, 'Ignacio');

      // Hay que asegurarse de que el botón "Siguiente" esté visible antes de hacer tap
      await tester.ensureVisible(nextButton);

      // Simula el tap en el botón "Siguiente" para disparar la validación
      await tester.tap(nextButton);

      // Re-renderiza el widget para procesar los cambios
      await tester.pump();

      // Verificamos que aparece el mensaje de error
      expect(find.text('El usuario no puede contener espacios ni caracteres especiales.'), findsOneWidget);
    });

    //test 2
    testWidgets('Comprobar que no se permite el uso de caracteres especiales en la contraseña alfanumérica', (WidgetTester tester) async {
      // Monta la página de contraseña alfanumérica
      // FALTA IMPLEMENTAR
    });

  });

  group('Pruebas sobre Base de Datos', () {
    final db = ColegioDatabase.instance;

    //Este método se ejecuta siempre antes de cada test y lo que hace es eliminar el archivo físico de la bd local
    setUp(() async {
      final dbPath = '/home/jesus/AndroidStudioProjects/Proyecto-Polifaceticos-MDA-DGP/.dart_tool/sqflite_common_ffi/databases/colegio.db';

      final dbFile = File(dbPath);
      if (await dbFile.exists()) {
        await dbFile.delete();
      }

      await db.database;
    });

    //test 1
    // DA ERROR
    test('Comprobar que se añaden correctamente en la bd los nuevos estudiantes', () async {

      bool isRegisteredJuan = await registerStudent('juan123', 'Juan', 'Pérez', '1234', 'assets/perfiles/chico.png', 'alphanumeric', 1, 1, 1);
      expect(isRegisteredJuan, true);

      bool existsJuan = await userIsValid('juan123');
      expect(existsJuan,true);

      bool isRegisteredLucia = await registerStudent('luciaaa22', 'Lucia', 'Muñoz', '1111', 'assets/perfiles/chica.png', 'pictograms', 1, 0, 1);
      expect(isRegisteredLucia, true);

      bool existsLucia = await userIsValid('luciaaa22');
      expect(existsLucia,true);

      bool isRegisteredMarta = await registerStudent('marta10', 'Marta', 'Caparrós', 'nube', 'assets/perfiles/discapacidad_motriz_chica.png', 'images', 0, 0, 1);
      expect(isRegisteredMarta, true);

      bool existsMarta = await userIsValid('marta10');
      expect(existsMarta,true);

      bool isRegisteredPepe = await registerStudent('pepito', 'José', 'Illana', 'almeria', 'assets/perfiles/discapacidad_motriz_chico.png', 'pictograms', 1, 1, 0);
      expect(isRegisteredPepe, true);

      bool existsPepe = await userIsValid('pepito');
      expect(existsPepe,true);

      bool existsJesus = await userIsValid('navacapa');
      expect(existsJesus,false);

    });
  });
}