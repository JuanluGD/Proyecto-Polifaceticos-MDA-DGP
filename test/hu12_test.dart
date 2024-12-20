import 'package:proyecto/bd_utils.dart';
import 'package:proyecto/bd.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/classes/Execute.dart';

void main() {
  group('Pruebas sobre Base de Datos', () {
    setUp(() async {
      try {
        // Forzar la inicialización de una nueva base de datos
        await ColegioDatabase.instance.database;

        // Insertar datos iniciales necesarios
        await insertStudent(
            'juan123', 'Juan', 'Pérez', '1234', 'assets/perfiles/chico.png', 'alphanumeric', 1, 1, 1);
        await insertExecute(2, 'juan123', 0, '2024-12-12');
      } catch (e) {
        rethrow;
      }
    });

    tearDown(() async {
      await deleteStudent('juan123');
    });

    // Test para verificar que la nueva fecha se guarda correctamente
    test('Comprobar que la nueva fecha límite se guarda correctamente en la base de datos', () async {
      // Fecha inicial del registro
      final oldDate = '2024-12-12';
      // Nueva fecha para modificar
      final newDate = '2024-12-15';

      // Crear instancia del objeto Execute inicial
      final execute = Execute(task_id: 2, user: 'juan123', status: 0, date: oldDate);

      // Modificar la fecha del registro en la base de datos
      final result = await modifyExecuteDate(execute, newDate);

      // Verificar que el método devuelve true
      expect(result, true);

      // Consultar la base de datos para confirmar el cambio
      final executes = await getStudentExecutes('juan123');

      // Comprobar que la nueva fecha está presente
      expect(
        executes.contains(Execute(task_id: 2, user: 'juan123', status: 0, date: newDate)),
        true,
      );
    });
  });
}