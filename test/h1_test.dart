import 'package:proyecto/bd_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto/hu1.dart';

void main() {
  group('Pruebas sobre Widgets', () {
    //test 1
    testWidgets('Comprobar que la contraseña sale censurada', (WidgetTester tester) async {
      // Monta la página de inicio de sesión
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      // Encuentra el campo de contraseña por su etiqueta
      final passwordField = find.widgetWithText(TextField, 'Contraseña');

      // Verifica que el campo de contraseña tiene la propiedad obscureText en true (censurado)
      final textField = tester.widget<TextField>(passwordField);
      expect(textField.obscureText, isTrue);
    });
  });

  group('Pruebas sobre Base de Datos', () {
    //test 1
    test('Login con credenciales correctas', () async {
      String user = 'admin';
      String password = 'admin';

      //comprobamos si las credenciales son correctas
      final loginResult = loginAdmin(user, password);
      expect(loginResult, true);
    });

    //test 2
    test('Login con credenciales incorrectas', () async {
      String user = 'polifaceticos';
      String password = '1234';

      //comprobamos si las credenciales son correctas
      final loginResult = loginAdmin(user, password);
      expect(loginResult, false);
    });
  });
}
