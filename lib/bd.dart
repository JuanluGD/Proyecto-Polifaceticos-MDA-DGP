import 'dart:io';

import 'package:proyecto/Administrador.dart';
import 'package:proyecto/Estudiante.dart';
import 'package:proyecto/imgClave.dart';
import 'package:proyecto/descifra.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ColegioDatabase{

	static final ColegioDatabase instance = ColegioDatabase._init();

	static Database? _database;
	
	ColegioDatabase._init();


	final String tablaAdministradores = 'administradores';
  final String tablaEstudiantes = 'estudiantes';
  final String tablaImgClave = 'imgClave';
  final String tablaDescifra = 'descifra';

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
		DNI INTEGER PRIMARY KEY,
		name VARCHAR(25),
    last_name1 VARCHAR(25),
    last_name2 VARCHAR(25)
		photo VARCHAR(25),
		password varchar(25)
		)
		
		''');

    await db.execute('''
		CREATE TABLE $tablaEstudiantes(
		DNI INTEGER PRIMARY KEY,
		name VARCHAR(25),
    last_name1 VARCHAR(25),
    last_name2 VARCHAR(25)
		photo VARCHAR(25),
		password varchar(25),
    tipoPasswd VARCHAR(25),
    interfazIMG BOOLEAN DEFAULT false,
    interfazPIC BOOLEAN DEFAULT false,
    interfazTXT BOOLEAN DEFAULT true
		)
		
		''');

    await db.execute('''
    CREATE TABLE $tablaImgClave(
      path VARCHAR(25),
      imgCode VARCHAR(25)
    )
    ''');

    await db.execute('''
    CREATE TABLE $tablaDescifra(
      DNI INTEGER,
      path VARCHAR(25),
      FOREIGN KEY (DNI) REFERENCES $tablaEstudiantes(DNI)
      FOREIGN KEY (path) REFERENCES $tablaImgClave(path)
      PRIMARY KEY (DNI, path)
    )
    ''');

		// Inserta un administrador inicial
		await db.insert(tablaAdministradores, {
			'name': "Administrador",
			'user': "admin",
			'password': "admin",
      'DNI': "00000000A",
      'last_name1': 'admin',
      'last_name2': 'admin',
      'photo': 'img/default'
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