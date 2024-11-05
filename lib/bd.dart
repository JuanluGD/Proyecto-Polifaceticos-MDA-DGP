import 'dart:io';

import 'package:proyecto/Admin.dart';
import 'package:proyecto/Student.dart';
import 'package:proyecto/imgClave.dart';
import 'package:proyecto/Decrypt.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ColegioDatabase{

	static final ColegioDatabase instance = ColegioDatabase._init();

	static Database? _database;
	
	ColegioDatabase._init();


	final String tablaAdmin = 'admin';
  final String tablaStudents = 'students';
  final String tablaImgClave = 'imgClave';
  final String tablaDecrypt = 'decrypt';

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
		CREATE TABLE $tablaAdmin(
		DNI VARCHAR(9) PRIMARY KEY,
		name VARCHAR(25),
    lastName1 VARCHAR(25),
    lastName2 VARCHAR(25)
		photo VARCHAR(25),
		password varchar(25)
		)
		
		''');

    await db.execute('''
		CREATE TABLE $tablaStudents(
		DNI VARCHAR(9) PRIMARY KEY,
		name VARCHAR(25),
    lastName1 VARCHAR(25),
    lastName2 VARCHAR(25)
		photo VARCHAR(25),
		password varchar(25),
    typePassword VARCHAR(25),
    interfaceIMG BOOLEAN DEFAULT false,
    interfacePIC BOOLEAN DEFAULT false,
    interfaceTXT BOOLEAN DEFAULT true
		)
		
		''');

    await db.execute('''
    CREATE TABLE $tablaImgClave(
      path VARCHAR(25),
      imgCode VARCHAR(25)
    )
    ''');

    await db.execute('''
    CREATE TABLE $tablaDecrypt(
      DNI VARCHAR(9),
      path VARCHAR(25),
      FOREIGN KEY (DNI) REFERENCES $tablaStudents(DNI)
      FOREIGN KEY (path) REFERENCES $tablaImgClave(path)
      PRIMARY KEY (DNI, path)
    )
    ''');

		// Inserta un administrador inicial
		await db.insert(tablaAdmin, {
			'DNI': "00000000A",
			'name': "Administrador",
      'lastName1': 'admin',
      'lastName2': 'admin',
			'password': "admin",
      'photo': 'img/default'
		});


	}

	Future<void> insertAdmin(Admin admin) async{
		final db = await instance.database;
		await db.insert(tablaAdmin, admin.toMap());
	}

  Future<void> insertStudent(Student est) async{
		final db = await instance.database;
		await db.insert(tablaStudents, est.toMap());
	}
	

	Future<bool> checkAdmin(Admin admin) async {
		final db = await instance.database;

		final result = await db.query(
			tablaAdmin,
			where: 'DNI = ? AND password = ?',
			whereArgs: [admin.DNI, admin.password],
		);

		return result.isNotEmpty;
	}
	
  Future<bool> checkStudent(Student est) async {
		final db = await instance.database;

		final result = await db.query(
			tablaStudents,
			where: 'DNI = ? AND password = ?',
			whereArgs: [est.DNI, est.password],
		);

		return result.isNotEmpty;
	}

	Future<bool> registerEstudiante(Student est) async {
		final db = await instance.database;

		try {
			await db.insert(tablaStudents, est.toMap());
			return true;
		} catch (e) {
			print("Error al insertar el estudiante: $e");
			return false;
		}
	}

	Future<bool> asignLoginType(String user, String loginType) async {
		final db = await instance.database;

		try {
			int count = await db.update(
				tablaStudents,
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

	Future<bool> modifyStudent(String user, String dato, String nuevaInformacion) async{
		final db = await instance.database;

		try {
			int count = await db.update(
				tablaStudents,
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