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
      await insertStudent('juan123', 'Juan', 'Pérez', '1234', 'assets/perfiles/chico.png', 'alphanumeric', 1, 1, 1);
      await insertStudent('luciaaa22', 'Lucia', 'Muñoz', '1111', 'assets/perfiles/chica.png', 'pictograms', 1, 0, 1);
    });

    // Test 1
    testWidgets('Comprobar que las tareas pendientes asignadas a un estudiante se muestran correctamente en la vista de tareas pendientes.', (WidgetTester tester) async {

    });

    // Test 2
    testWidgets('Comprobar que la tarea asignada aparece correctamente en la vista principal del estudiante', (WidgetTester tester) async {

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
      await insertStudent('juan123', 'Juan', 'Pérez', '1234', 'assets/perfiles/chico.png', 'alphanumeric', 1, 1, 0);
    });
    //test 1
    test('Comprobar que las tareas pendientes de un estudiante se recuperan correctamente desde la base de datos.', () async {
      expect(await modifyCompleteStudent('juan123', 'Juan', 'Gomez', '1234', 'assets/perfiles/chico.png', 'alphanumeric', 0, 0, 1), true);
      final student = await getStudent('juan123');
      expect(student!.diningRoomTask, 1);
    });
  });
}