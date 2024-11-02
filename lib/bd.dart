import 'dart:io';

import 'package:proyecto/Administrador.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ColegioDatabase{

	static final ColegioDatabase instance = ColegioDatabase._init();

	static Database? _database;
	
	ColegioDatabase._init();


	final String tablaAdministradores = 'administradores';

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
		id INTEGER PRIMARY KEY,
		name VARCHAR(25),
		user VARCHAR(25),
		password varchar(25)
		)
		
		''');

		await db.execute('''
		INSERT INTO $tablaAdministradores VALUES(0, "Administrador", "admin", "admin")

		''');
	}

	Future<void> insertarAdministrador(Administrador admin) async{
		final db = await instance.database;
		await db.insert(tablaAdministradores, admin.toMap());
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
		
}