import 'package:proyecto/bd_utils.dart';
import 'dart:io';
import 'package:proyecto/bd.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/interfaces/hu4.dart';
import 'package:path/path.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {

  // NO FUNCIONAN
  group('Pruebas sobre Widgets', () async {

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'colegio.db');
    setUp(() async {
      if (await databaseExists(path)) {
        deleteDatabase(path);
      }

      await ColegioDatabase.instance.database;
      await registerStudent('juan123', 'Juan', 'Pérez', '1234', 'assets/perfiles/chico.png', 'alphanumeric', 1, 1, 1);
      await registerStudent('luciaaa22', 'Lucia', 'Muñoz', '1111', 'assets/perfiles/chica.png', 'pictograms', 1, 0, 1);
    });

    // Test 1
    testWidgets('Comprobar que se puede acceder a la página de la modificación de perfil', (WidgetTester tester) async {

      // Registra estudiantes de prueba directamente en la base de datos antes de cargar la página
      await registerStudent('juan123', 'Juan', 'Pérez', '1234', 'assets/perfiles/chico.png', 'alphanumeric', 1, 1, 1);
      await registerStudent('luciaaa22', 'Lucia', 'Muñoz', '1111', 'assets/perfiles/chica.png', 'pictograms', 1, 0, 1);
      await registerStudent('marta10', 'Marta', 'Caparrós', 'nube', 'assets/perfiles/discapacidad_motriz_chica.png', 'images', 0, 0, 1);
      await registerStudent('pepito', 'José', 'Illana', 'almeria', 'assets/perfiles/discapacidad_motriz_chico.png', 'pictograms', 1, 1, 0);

      // Monta la página de lista de estudiantes
      await tester.pumpWidget(MaterialApp(home: StudentListPage()));

      // Espera a que los estudiantes se carguen en la página
      await tester.pumpAndSettle();

      // Verifica que al menos un ListTile (estudiante) esté presente
      expect(find.byType(ListTile), findsWidgets);

      // Encuentra el primer estudiante en la lista
      final firstStudent = find.byType(ListTile).first;
      expect(firstStudent, findsOneWidget); // Confirma que hay al menos un estudiante

      // Busca el botón de edición dentro del primer estudiante encontrado
      final editButton = find.descendant(of: firstStudent, matching: find.byIcon(Icons.edit));
      expect(editButton, findsOneWidget); // Confirma que el botón de edición está presente

      // Simula un tap en el botón de edición
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      // Verifica que se ha navegado a la página de modificación del estudiante
      expect(find.byType(StudentModificationPage), findsOneWidget);
    });

    // Test 2
    testWidgets('Modificar un estudiante en la página de modificación de perfil', (WidgetTester tester) async {
      /*
      //registra a un estudiante para poder modificarlo
      bool isRegisteredJuan = await registerStudent('juan123', 'Juan', 'Pérez', '1234', 'assets/perfiles/chico.png', 'alphanumeric', 1, 1, 1);
      expect(isRegisteredJuan, true);

        await tester.pumpWidget(MaterialApp(home: StudentModificationPage(student: selectedStudent!)));

      }
      */
    });
  });

  group('Pruebas sobre Base de Datos', () async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'colegio.db');
    setUp(() async {
      if (await databaseExists(path)) {
        deleteDatabase(path);
      }

      await ColegioDatabase.instance.database;
      await registerStudent('juan123', 'Juan', 'Pérez', '1234', 'assets/perfiles/chico.png', 'alphanumeric', 1, 1, 1);
      await registerStudent('luciaaa22', 'Lucia', 'Muñoz', '1111', 'assets/perfiles/chica.png', 'pictograms', 1, 0, 1);
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
    test('Comprobar el usuario de un estudiante no se ha modificado en la base de datos', () async {
      expect(await modifyUserStudent('juan123', 'luciaaa22'), false);
      final student = await getStudent('juan123');
      expect(student!.user, 'juan123');
    });
  });
}