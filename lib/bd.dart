import 'dart:io';
import 'package:proyecto/Student.dart';
import 'package:proyecto/ImgCode.dart';
import 'package:proyecto/Decrypt.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';



/*
  Clase ColegioDatabase
  Almacena la base de datos de la aplicación
*/
class ColegioDatabase{
  /*
    Declaramos la instancia de la base de datos,
    que se usarára cada vez que necesitemos acceder a ella.
  */

	static final ColegioDatabase instance = ColegioDatabase._init();

	static Database? _database;
	
	ColegioDatabase._init();

  /*
    Declaramos los nombres de las tablas que usará la aplicación
  */
	final String tablaStudents = 'students';
	final String tablaImgCode = 'imgCode';
	final String tablaDecrypt = 'decrypt';
	final String tablaClassroom = 'classroom';
	final String tablaOrders = 'orders';
	final String tablaMenu = 'menu';
  /*
    Metodo inherente a las bases de datos sqlite que devuelve
    la base de datos en caso de estar creada y la crea
    en caso contrario
  */

	Future<Database> get database async {
		if(_database != null) return _database!;

		_database = await _initDB('colegio.db');
		return _database!;	
	}

	/*
    Método
    @Nombre --> _initDB
    @Funcion --> Inicializa la base de datos y la deja preparada para su posterior uso
    @Argumentos
      - filePath: ruta del archivo donde se guardará la base de datos
  */

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
  
  /*
    Método
    @Nombre --> _onCreateDB
    @Funcion --> Se ejecuta cuando se crea la base de datos. Crea todas las tablas requeridas por la apliación
    @Argumentos
      - db: la base de datos sobre la que se crearán las tablas
      - version: versión de la base de datos
  */
	Future _onCreateDB(Database db, int version) async {
		
		/*
			Tabla Estudiantes.
			Contendrá todos los ratos relativos a los estudiantes registrados en la aplicación
    */
		await db.execute('''
			CREATE TABLE $tablaStudents(
			user VARCHAR(30) PRIMARY KEY,
			name VARCHAR(25) NOT NULL,
			surname VARCHAR(100),
			image VARCHAR(25) NOT NULL UNIQUE,
			password varchar(500) NOT NULL,
			typePassword VARCHAR(25) NOT NULL,
			interfaceIMG TINYINT(1) NOT NULL,
			interfacePIC TINYINT(1) NOT NULL,
			interfaceTXT TINYINT(1) NOT NULL,
      		diningRoomTask TINYINT(1) NOT NULL
			)
			
		''');

		/*
			Tabla imágenes.
			Contendrá toda la información de las imágenes almacenadas en la aplicación
    */
		await db.execute('''
			CREATE TABLE $tablaImgCode(
			path VARCHAR(25) PRIMARY KEY,
			code VARCHAR(25) NOT NULL UNIQUE
			)
		''');

		/*
			Tabla Decrypt.
			Contiene la relación entre las imágenes y los alumnos
    */
		await db.execute('''
			CREATE TABLE $tablaDecrypt(
			user VARCHAR(30),
			path VARCHAR(25),
			FOREIGN KEY (user) REFERENCES $tablaStudents(user),
			FOREIGN KEY (path) REFERENCES $tablaImgCode(path),
			PRIMARY KEY (user, path)
			)
		''');

		
		/*
			Tabla  Menu.
			Contiene los menús disponibles en el colegio.
		*/
		await db.execute('''
			CREATE TABLE $tablaMenu(
			name VARCHAR(30),
			pictogram VARCHAR(30),
			image VARCHAR(30),
			PRIMARY KEY (name)
			)
		''');

		/*
			Tabla Classroom. 
			Contiene las clases de las que tendrá constancia la aplicación.
		*/
		await db.execute('''
			CREATE TABLE $tablaClassroom(
			name VARCHAR(30),
			PRIMARY KEY (name)
			)
		''');

		/*
			Tabla Order. 
			Contiene las ordenes de menus que realizarán las distintas clases.
		*/
		await db.execute('''
			CREATE TABLE $tablaOrders(
			date VARCHAR(30),
			quantity INTEGER,
      menuName VARCHAR(30),
      classroomName VARCHAR(30),
			PRIMARY KEY (menuName, classroomName, date),
      FOREIGN KEY (menuName) REFERENCES $tablaMenu(name),
			FOREIGN KEY (classroomName) REFERENCES $tablaClassroom(name)
			)
		''');
	}

	

  /*
    Método
    @Nombre --> loginStudent
    @Funcion --> Comprueba que los datos introducidos corresponden a algun alumno registrado en la base de datos
    @Argumentos
      - user: usuario del alumno
      - password: contraseña del alumno
  */
	Future<bool> loginStudent(String user, String password) async {
		final db = await instance.database;

		final result = await db.query(
			tablaStudents,
			where: 'user = ? AND password = ?',
			whereArgs: [user, password],
      limit: 1
		);
		return result.isNotEmpty;
	}
  /*
    Método
    @Nombre --> registerStudent
    @Funcion --> Registra a un alumno en la base de datos
    @Argumentos
      - Student: objeto de la clase Student que contiene todos los datos necesarios para añadir un nuevo alumno a la tabla
                  de estudiantes.
  */

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
  
 /*
    Método
    @Nombre --> asignLoginType
    @Funcion --> Asigna un tipo de login a un alumno concreto
    @Argumentos
      - user: usuario al que se le realizará la modificación
      - typePassword: tipo de contraseña que usará el alumno en cuestión
  */
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
  
  /*
    Método
    @Nombre --> modifyStudent
    @Funcion --> Modifica los datos de un estudiante registrado en la base de datos
    @Argumentos
      - user: usuario del alumno al que se le realizará las modificaciónes
      - data: dato del alumno que será modificado (user, password, etc...)
      - newData: nuevo valor del dato modificado
  */
	Future<bool> modifyStudent(String user, String data, String newData) async {
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
  
  /*
    Método
    @Nombre --> modifyCompleteStudent
    @Funcion --> Actualiza todos los datos de un alumno registrado en la base de datos
    @Argumentos
      - user: usuario del alumno al que se le realizará las modificaciónes
      - name: nombre
      - surname: apellido
      - password: contraseña
      - photo: foto del alumno
      - typePassword: tipo de contraseña que usará el alumno para iniciar al sesión
      - interfaceIMG: determina si el alumno usará la interfaz basada en imágenes
      - interfacePIC: determina si el alumno usará la interfaz basada en pictogramas
      - intefaceTXT: determina si el alumno usará la interfaz basada en texto

  */
	Future<bool> modifyCompleteStudent(String user, String name, String? surname,String password, 
    String photo, String typePassword, int interfaceIMG, int interfacePIC, int interfaceTXT) async {
		final db = await instance.database;
		try {
			int count = await db.update(
				tablaStudents,
				{
					'name': name,
					'surname': surname,
					'password': password,
					'image': photo,
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

  /*
    Método
    @Nombre --> getAllStudents
    @Funcion --> Devuelve todos los estudiantes de la base de datos
  */
	Future<List<Student>> getAllStudents() async {
		final db = await instance.database;
		final result = await db.query(tablaStudents);
		return result.map((map) => Student.fromMap(map)).toList();
	}

  /*
    Método
    @Nombre --> getStudent
    @Funcion --> Devuelve un estudiante en concreto en base a su usuario
    @Argumentos
      - user: usuario del alumno que será devuelto
  */
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

  /*
    Método
    @Nombre --> getStudentPhotos
    @Funcion --> Devuelve las fotos de todos los estudiantes
  */
	Future<List<String>> getStudentPhotos() async {
		final db = await instance.database;
		final result = await db.query(tablaStudents, columns: ['image']);
		return result.map((map) => map['image'].toString()).toList();
	}

  /*
    Método
    @Nombre --> getImgCode
    @Funcion --> Devuelve el código asignado a una imagen
    @Argumentos
      - path: ruta de la imagen en cuestión
  */
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

  /*
    Método
    @Nombre --> getAllImgCodes
    @Funcion --> Devuelve el código de todas las imágenes de la base de datos
  */
	Future<List<ImgCode>> getAllImgCodes() async {
		final db = await instance.database;
		final result = await db.query(tablaImgCode);
		return result.map((map) => ImgCode.fromMap(map)).toList();
	}


  Future<ImgCode?> getImgCodeFromCode(String code) async {
    final db = await instance.database;
    final result = await db.query(
      tablaImgCode,
      where: 'code = ?',
      whereArgs: [code],
    );
    if (result.isNotEmpty) {
      return ImgCode.fromMap(result.first);
    } else {
      return null;
    }
  }
  /*
    Método
    @Nombre --> getImgCodeFromFolder
    @Funcion --> Devuelve los códigos de las imagenes de una carpeta
    @Argumentos
      - folder: nombre de la carpeta que contiene las imágenes
  */
  Future<List<ImgCode>> getImgCodeFromFolder(String folder) async {
    final db = await instance.database;
    final result = await db.query(
      tablaImgCode,
      where: 'path LIKE ?',
      whereArgs: ['%$folder%']
    );
    return result.map((map) => ImgCode.fromMap(map)).toList();
  }
  /*
    Método
    @Nombre --> insertDecryptEntries
    @Funcion --> Permite asignar a un alumno las imágenes que usará para iniciar sesión
    @Argumentos
      - user: el usuario del alumno al que se le asignarán las imágenes
			- images: las imágenes que usará dicho usuario para iniciar sesión
  */
  Future<void> insertDecryptEntries(String user, List<ImgCode> images) async {
    final db = await instance.database;

    for (var imgCode in images) {
      await db.insert(
        tablaDecrypt,
        {
          'user': user,
          'path': imgCode.path,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore, // Evita errores si ya existe la tupla
      );
    }
  }


  /*
    Método
    @Nombre --> deleteDecryptEntries
    @Funcion --> Permite eliminar la relación entre un alumno y sus imágenes
    @Argumentos
      - user: el usuario del alumno 
  */
	Future<void> deleteDecryptEntries(String user) async {
    final db = await instance.database;

		await db.delete(
			tablaDecrypt,
			where: 'user = ?',
			whereArgs: [user],
		);
  }

  /*
    Método
    @Nombre --> getImgCodesByStudent
    @Funcion --> Permite obtener todas las imágenes asociadas a un alumno
    @Argumentos
      - user: el usuario del alumno del que se obtendrán las imágenes
  */
  Future<List<ImgCode>> getImgCodesByStudent(String user) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT imgcode.path, imgcode.code
      FROM $tablaDecrypt AS decrypt
      JOIN $tablaImgCode AS imgcode ON decrypt.path = imgcode.path
      WHERE decrypt.user = ?
    ''', [user]);

    return result.map((map) => ImgCode.fromMap(map)).toList();
  }
  /*
    Método
    @Nombre --> getAllDecrypts
    @Funcion --> Devuelve todas las imágenes almacenadas en la base de datos
  */
	Future<List<Decrypt>> getAllDecrypts() async {
		final db = await instance.database;
		final result = await db.query(tablaDecrypt);
		return result.map((map) => Decrypt.fromMap(map)).toList();
	}

  /*
    Método
    @Nombre --> userIsValid
    @Funcion --> Comprueba que un usuario en concreto exista en la base de datos
    @Argumentos
      - user: el usuario del alumno
  */
  Future<bool> userIsValid(String user) async {
    final db = await instance.database;
    final result = await db.query(
      tablaStudents,
      where: 'user = ?',
      whereArgs: [user],
    );
    return result.isEmpty;
  }
  /*
    Método
    @Nombre --> getImgCode
    @Funcion --> Devuelve el código asociado a una imagen en concreto
    @Argumentos
      - path: la ruta de la imágen
  */
  Future<String> getCodeImgCode(String path) async {
    final db = await instance.database;
    final result = await db.query(
      tablaImgCode,
      where: 'path = ?',
      whereArgs: [path],
    );
    return result.first['code'].toString();
  }
  /*
    Método
    @Nombre --> insertImgCode
    @Funcion --> Inserta una imágen con su código en la base de datos
    @Argumentos
      - path: ruta de la imagen
			- code: código asignado a la imagen
  */
  Future<bool> insertImgCode(String path, String code) async {
		final db = await instance.database;
		try {
			await db.insert(tablaImgCode, {'path': path, 'code': code});
			return true;
		} catch (e) {
			print("Error al insertar el código de la imagen: $e");
			return false;
		}
	}

  /*
    Método
    @Nombre --> getImgCodePath
    @Funcion --> Devuelve la ruta de una imagen dada su código asignado
    @Argumentos
      - code: el código asignado a la imagen que queremos obtener
  */
	Future<String> getImgCodePath(String code) async {
		final db = await instance.database;
		final result = await db.query(
			tablaImgCode,
			where: 'code = ?',
			whereArgs: [code],
		);
		return result.first['path'].toString();
	}
  
  /*
    Método
    @Nombre --> imgCodePathCount
    @Funcion --> devuelve el número de imágenes que tienen el mismo path
    @Argumentos
      - path: la ruta que deberan compartir las imágenes
  */
	Future<int> imgCodePathCount(String path) async {
		final db = await instance.database;
		final result = await db.query(
			tablaImgCode,
			where: 'path LIKE ?',
			whereArgs: [path],
		);
		return result.length;
	}

  /* 
    Método
    @Nombre --> insertOrders
    @Funcion --> Inserta una comanda en la base de datos
    @Argumentos
      - date: fecha de la comanda
      - quantity: cantidad de menús pedidos
      - menuName: nombre del menú
      - classroomName: nombre de la clase que ha realizado la comanda
  */
  Future<bool> insertOrders(String date, int quantity, String menuName, String classroomName) async {
    final db = await instance.database;
    try {
      await db.insert(tablaOrders, {'date': date, 'quantity': quantity, 'menuName': menuName, 'classroomName': classroomName});
      return true;
    } catch (e) {
      print("Error al insertar la orden: $e");
      return false;
    }
  }

}