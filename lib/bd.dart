import 'dart:io';

import 'package:proyecto/Administrador.dart';
import 'package:proyecto/Estudiante.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ColegioDatabase{

	static final ColegioDatabase instance = ColegioDatabase._init();

	static Database? _database;
	
	ColegioDatabase._init();


	final String tablaAdministradores = 'administradores';
  final String tablaEstudiantes = 'estudiantes';

	Future<Database> get database async {
		if(_database != null) return _database!;

		_database = await _initDB('colegio.db');
		return _database!;	
	}
	
	Future<Database> _initDB(String filePath) async {

		if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
			sqfliteFfiInit();
			databaseFactory = databaseFactoryFfi;
		}

		final dbPath = await getDatabasesPath();
		final path = join(dbPath, filePath);

		return await openDatabase(path, version: 1, onCreate: _onCreateDB);
	}

	Future _onCreateDB(Database db, int version) async{
		await db.execute('''
		CREATE TABLE $tablaAdministradores(
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		name VARCHAR(25),
		user VARCHAR(25),
		password varchar(25)
		)
		
		''');

    await db.execute('''
		CREATE TABLE $tablaEstudiantes(
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		name VARCHAR(25),
		user VARCHAR(25),
		password varchar(25),
		loginType varchar(25)
		)
		
		''');

		// Inserta un administrador inicial
		await db.insert(tablaAdministradores, {
			'name': "Administrador",
			'user': "admin",
			'password': "admin"
		});
	}

	Future<void> insertarAdministrador(Administrador admin) async{
		final db = await instance.database;
		await db.insert(tablaAdministradores, admin.toMap());
	}

  Future<void> insertarEstudiante(Estudiante est) async{
		final db = await instance.database;
		await db.insert(tablaEstudiantes, est.toMap());
	}
	

	Future<bool> comprobarAdministrador(Administrador admin) async {
		final db = await instance.database;

		final result = await db.query(
			tablaAdministradores,
			where: 'user = ? AND password = ?',
			whereArgs: [admin.user, admin.password],	
		);

		return result.isNotEmpty;
	}
	
  Future<bool> comprobarEstudiantes(Estudiante est) async {
		final db = await instance.database;

		final result = await db.query(
			tablaEstudiantes,
			where: 'user = ? AND password = ?',
			whereArgs: [est.user, est.password],	
		);

		return result.isNotEmpty;
	}

	Future<bool> registrarEstudiante(Estudiante est) async {
		final db = await instance.database;

		try {
			await db.insert(tablaEstudiantes, est.toMap());
			return true;
		} catch (e) {
			print("Error al insertar el estudiante: $e");
			return false;
		}
	}

	Future<bool> asignarLoginType(String user, String loginType) async {
		final db = await instance.database;

		try {
			int count = await db.update(
			tablaEstudiantes,
			{'loginType': loginType},
			where: 'user = ?',
			whereArgs: [user],
			);

			return count > 0;
		} catch (e) {
			print("Error al asignar loginType: $e");
			return false;
		}
	}

	Future<bool> modificarDatoEstudiante(String user, String dato, String nuevaInformacion) async{
		final db = await instance.database;

		try {
			int count = await db.update(
			tablaEstudiantes,
			{dato: nuevaInformacion},
			where: 'user = ?',
			whereArgs: [user],
			);

			return count > 0;
		} catch (e) {
			print("Error al modificar el dato: $e");
			return false;
		}
	}

}