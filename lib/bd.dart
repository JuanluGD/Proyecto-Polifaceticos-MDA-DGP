import 'dart:io';
import 'package:proyecto/Student.dart';
import 'package:proyecto/ImgCode.dart';
import 'package:proyecto/Decrypt.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ColegioDatabase{

	static final ColegioDatabase instance = ColegioDatabase._init();

	static Database? _database;
	
	ColegioDatabase._init();

	final String tablaStudents = 'students';
	final String tablaImgCode = 'imgCode';
	final String tablaDecrypt = 'decrypt';

	Future<Database> get database async {
		if(_database != null) return _database!;

		_database = await _initDB('colegio.db');
		return _database!;	
	}
	
	Future<Database> _initDB(String filePath) async {
    try {
      if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }

      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(path, version: 1, onCreate: _onCreateDB);
    } catch (e) {
      print("Error al inicializar la base de datos: $e");
      rethrow;
    }
	}

	Future _onCreateDB(Database db, int version) async{

		await db.execute('''
			CREATE TABLE $tablaStudents(
			user VARCHAR(30) PRIMARY KEY,
			name VARCHAR(25) NOT NULL,
			surname VARCHAR(100),
			image VARCHAR(25) NOT NULL UNIQUE,
			password varchar(25) NOT NULL,
			typePassword VARCHAR(25) NOT NULL,
			interfaceIMG TINYINT(1) NOT NULL,
			interfacePIC TINYINT(1) NOT NULL,
			interfaceTXT TINYINT(1) NOT NULL,
      diningRoomTask TINYINT(1) NOT NULL
			)
			
		''');

		await db.execute('''
			CREATE TABLE $tablaImgCode(
			path VARCHAR(25) PRIMARY KEY,
			code VARCHAR(25) NOT NULL UNIQUE
			)
		''');

		await db.execute('''
			CREATE TABLE $tablaDecrypt(
			user VARCHAR(30),
			path VARCHAR(25),
			FOREIGN KEY (user) REFERENCES $tablaStudents(user),
			FOREIGN KEY (path) REFERENCES $tablaImgCode(path),
			PRIMARY KEY (user, path)
			)
		''');

	}

	Future<bool> loginStudent(String user, String password) async {
		final db = await instance.database;

		final result = await db.query(
			tablaStudents,
			where: 'user = ? AND password = ?',
			whereArgs: [user, password],
		);

		return result.isNotEmpty;
	}

	Future<bool> registerStudent(Student student) async {
		final db = await instance.database;

		try {
			await db.insert(tablaStudents, student.toMap());
			return true;
		} catch (e) {
			print("Error al insertar el estudiante: $e");
			return false;
		}
	}

	Future<bool> asignLoginType(String user, String typePassword) async {
		final db = await instance.database;

		try {
			int count = await db.update(
				tablaStudents,
				{'typePassword': typePassword},
				where: 'user = ?',
				whereArgs: [user],
			);

			return count > 0;
		} catch (e) {
			print("Error al asignar loginType: $e");
			return false;
		}
	}

	Future<bool> modifyStudent(String user, String data, String newData) async{
		final db = await instance.database;

		try {
			int count = await db.update(
				tablaStudents,
				{data: newData},
				where: 'user = ?',
				whereArgs: [user],
			);

			return count > 0;
		} catch (e) {
			print("Error al modificar el dato: $e");
			return false;
		}
	}

	Future<bool> modifyCompleteStudent(String user, String name, String? surname,String password, 
    String photo, String typePassword, int interfaceIMG, int interfacePIC, int interfaceTXT) async{
		final db = await instance.database;
		try {
			int count = await db.update(
				tablaStudents,
				{
					'name': name,
					'surname': surname,
					'password': password,
					'photo': photo,
					'typePassword': typePassword,
					'interfaceIMG': interfaceIMG,
					'interfacePIC': interfacePIC,
					'interfaceTXT': interfaceTXT
				},
				where: 'user = ?',
				whereArgs: [user],
			);

			return count > 0;
		} catch (e) {
			print("Error al modificar el estudiante: $e");
			return false;
		}
	}

	Future<List<Student>> getAllStudents() async {
		final db = await instance.database;
		final result = await db.query(tablaStudents);
		return result.map((map) => Student.fromMap(map)).toList();
	}

	Future<Student?> getStudent(String user) async {
		final db = await instance.database;
		final result = await db.query(
			tablaStudents,
			where: 'user = ?',
			whereArgs: [user],
		);
		if (result.isNotEmpty) {
			return Student.fromMap(result.first);
		} else {
			return null;
		}
	}

	Future<List<String>> getStudentPhotos() async {
		final db = await instance.database;
		final result = await db.query(tablaStudents, columns: ['photo']);
		return result.map((map) => map['photo'].toString()).toList();
	}

	Future<ImgCode?> getImgCode(String path) async {
		final db = await instance.database;
		final result = await db.query(
			tablaImgCode,
			where: 'path = ?',
			whereArgs: [path],
		);
		if (result.isNotEmpty) {
			return ImgCode.fromMap(result.first);
		} else {
			return null;
		}
	}

	Future<List<ImgCode>> getAllImgCodes() async {
		final db = await instance.database;
		final result = await db.query(tablaImgCode);
		return result.map((map) => ImgCode.fromMap(map)).toList();
	}

	Future<List<Decrypt>> getDecryptsByStudent(String user) async {
		final db = await instance.database;
		final result = await db.query(
			tablaDecrypt,
			where: 'user = ?',
			whereArgs: [user],
		);
		return result.map((map) => Decrypt.fromMap(map)).toList();
	}

	Future<List<Decrypt>> getAllDecrypts() async {
		final db = await instance.database;
		final result = await db.query(tablaDecrypt);
		return result.map((map) => Decrypt.fromMap(map)).toList();
	}

}