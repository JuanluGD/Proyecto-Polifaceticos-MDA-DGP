import 'package:test/test.dart';
import 'package:proyecto/bd.dart';
import 'package:proyecto/Student.dart';
import 'package:proyecto/Admin.dart';

void main() {
  final db = ColegioDatabase.instance;

  setUp(() async {
    // Limpia la base de datos eliminando el administrador de prueba antes de cada prueba
    final database = await db.database;
    await database.delete(
      db.tablaAdmin,
      where: 'DNI = ?',
      whereArgs: ['00000000B'], // un valor cualquiera de DNI
    );
  });

  //test de un login exitoso por parte de un admin
  test('Login exitoso', () async {
    //creamos una instancia de admin
    final admin = Admin(
      DNI: '00000000B',
      name: 'Administrador',
      lastName1: 'admin',
      lastName2: 'admin',
      password: 'admin',
      photo: 'img/default',
    );

    //insertamos al administrador en la bd
    await db.insertAdmin(admin);

    //comprobamos si las credenciales son correctas
    final loginResult = await db.checkAdmin(admin);
    expect(loginResult, true);

    //limpiamos la bd eliminando el administrador de prueba
    final database = await db.database;
    await database.delete(
      db.tablaAdmin,
      where: 'DNI = ?',
      whereArgs: [admin.DNI],
    );
  });

  test('Login con credenciales incorrectas', () async {
    final admin = Admin(
      DNI: '00000000B',
      name: 'Administrador',
      lastName1: 'admin',
      lastName2: 'admin',
      password: 'admin',
      photo: 'img/default',
    );

    await db.insertAdmin(admin);

    final wrongAdmin = Admin(
      DNI: '00000000C', // DNI incorrecto
      name: 'Administrador',
      lastName1: 'admin',
      lastName2: 'admin',
      password: 'wrongpassword', // Contraseña incorrecta
      photo: 'img/default',
    );
    final loginResult = await db.checkAdmin(wrongAdmin);
    expect(loginResult, false);

    final database = await db.database;
    await database.delete(
      db.tablaAdmin,
      where: 'DNI = ?',
      whereArgs: [admin.DNI],
    );
  });

  test('Login con campos vacíos', () async {
    final admin = Admin(
      DNI: '00000000B',
      name: 'Administrador',
      lastName1: 'admin',
      lastName2: 'admin',
      password: 'admin',
      photo: 'img/default',
    );

    await db.insertAdmin(admin);

    final emptyAdmin = Admin(
      DNI: '', // DNI vacío
      name: '',
      lastName1: '',
      lastName2: '',
      password: '', // Contraseña vacía
      photo: '',
    );
    final loginResult = await db.checkAdmin(emptyAdmin);
    expect(loginResult, false);

    final database = await db.database;
    await database.delete(
      db.tablaAdmin,
      where: 'DNI = ?',
      whereArgs: [admin.DNI],
    );
  });
}

