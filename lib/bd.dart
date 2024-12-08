import 'dart:io';
import 'package:path/path.dart';
import 'package:proyecto/classes/Step.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:proyecto/classes/Classroom.dart';
import 'package:proyecto/classes/Menu.dart';
import 'package:proyecto/classes/Order.dart';
import 'package:proyecto/classes/Student.dart';
import 'package:proyecto/classes/ImgCode.dart';
import 'package:proyecto/classes/Decrypt.dart';
import 'package:proyecto/classes/Task.dart';

import 'classes/Execute.dart';
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
  final String tablaTask = 'task';
  final String tablaStep = 'step';
  final String tablaExecute = 'execute';
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

      return await openDatabase(path, version: 1, 
        onCreate: _onCreateDB, 
        onOpen: (db) async{
              await db.execute('PRAGMA foreign_keys = ON');
        },
      );
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
		
    /// TABLA STUDENTS  ///
		await db.execute('''
			CREATE TABLE $tablaStudents(
			user VARCHAR(30) PRIMARY KEY,
			name VARCHAR(25) NOT NULL,
			surname VARCHAR(100),
			image VARCHAR(25) NOT NULL,
			password varchar(500) NOT NULL,
			typePassword VARCHAR(25) NOT NULL,
			interfaceIMG TINYINT(1) NOT NULL,
			interfacePIC TINYINT(1) NOT NULL,
			interfaceTXT TINYINT(1) NOT NULL
			)
			
		''');

    /// TABLA IMGCODE  ///
    /// Almacena las rutas de las imágenes y su código asociado
		await db.execute('''
			CREATE TABLE $tablaImgCode(
			path VARCHAR(25) PRIMARY KEY,
			code VARCHAR(25) NOT NULL UNIQUE
			)
		''');

    /// TABLA DECRYPT  ///
    /// Almacena las imágenes que usará cada alumno para iniciar sesión
		await db.execute('''
			CREATE TABLE $tablaDecrypt(
			user VARCHAR(30),
			path VARCHAR(25), 
			FOREIGN KEY (user) REFERENCES $tablaStudents(user) ON DELETE CASCADE,
			FOREIGN KEY (path) REFERENCES $tablaImgCode(path) ON DELETE CASCADE,
			PRIMARY KEY (user, path)
			)
		''');

		
    /// TABLA MENU  ///
		await db.execute('''
			CREATE TABLE $tablaMenu(
			name VARCHAR(30),
			pictogram VARCHAR(30) NOT NULL,
			image VARCHAR(30) NOT NULL,
      descriptive_text VARCHAR(100),
			PRIMARY KEY (name)
			)
		''');

    /// TABLA CLASSROOM  ///
		await db.execute('''
			CREATE TABLE $tablaClassroom(
			name VARCHAR(30),
      image VARCHAR(50) NOT NULL,
			PRIMARY KEY (name)
			)
		''');

    /// TABLA ORDERS  ///
    /// Almacena las comandas realizadas por las clases
		await db.execute('''
			CREATE TABLE $tablaOrders(
			date VARCHAR(30),
			quantity INTEGER,
      menuName VARCHAR(30),
      classroomName VARCHAR(30),
			PRIMARY KEY (menuName, classroomName, date),
      FOREIGN KEY (menuName) REFERENCES $tablaMenu(name) ON DELETE CASCADE,
			FOREIGN KEY (classroomName) REFERENCES $tablaClassroom(name) ON DELETE CASCADE
			)
		''');

    /// TABLA TASK  ///
    /// Almacena las tareas
		await db.execute('''
			CREATE TABLE $tablaTask(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
			name VARCHAR(100) NOT NULL UNIQUE,
      description VARCHAR(100),
      pictogram VARCHAR(30) NOT NULL,
			image VARCHAR(30) NOT NULL,
      descriptive_text VARCHAR(100)
			)
		''');

    /// TABLA STEPS  ///
    /// Almacena los pasos de las tareas
    await db.execute('''
      CREATE TABLE $tablaStep(
      id INTEGER,
      task_id INTEGER,
      description VARCHAR(200) NOT NULL,
      pictogram VARCHAR(150) NOT NULL,
      image VARCHAR(150) NOT NULL,
      descriptive_text VARCHAR(100),
      FOREIGN KEY (task_id) REFERENCES $tablaTask(id) ON DELETE CASCADE,
      PRIMARY KEY (id, task_id)
      )
    ''');

    /// TABLA EXECUTE  ///
    /// Almacena las tareas que tiene asignadas cada alumno
    await db.execute('''
      CREATE TABLE $tablaExecute(
      user VARCHAR(30),
      task_id INTEGER,
      date VARCHAR(30),
      status TINYINT(1) NOT NULL,
      FOREIGN KEY (user) REFERENCES $tablaStudents(user) ON DELETE CASCADE,
      FOREIGN KEY (task_id) REFERENCES $tablaTask(id) ON DELETE CASCADE,
      PRIMARY KEY (user, task_id, date)
      )
    ''');



    /// INSERTAR DATOS DE PRUEBA ///
    await db.execute('''
      INSERT INTO $tablaStudents (user, name, surname, image, password, typePassword, interfaceIMG, interfacePIC, interfaceTXT) VALUES ('alissea', 'Alicia', '', 'assets/perfiles/alissea.png', 'rosa.png_picto azul.png_picto ', 'pictograms', 0, 1, 0);
      INSERT INTO $tablaStudents (user, name, surname, image, password, typePassword, interfaceIMG, interfacePIC, interfaceTXT) VALUES ('alex123', 'Alex', '', 'assets/perfiles/alex123.png', '1234', 'alphanumeric', 0, 1, 1);
      INSERT INTO $tablaStudents (user, name, surname, image, password, typePassword, interfaceIMG, interfacePIC, interfaceTXT) VALUES ('juancito', 'Juan', '', 'assets/perfiles/juancito.png', 'azul.png_img ', 'images', 1, 0, 0);
   ''');

    await db.execute('''
      INSERT INTO $tablaImgCode (path, code) VALUES ('assets/picto_claves/amarillo.jpg', 'amarillo.jpg_picto');
      INSERT INTO $tablaImgCode (path, code) VALUES ('assets/picto_claves/azul.png', 'azul.png_picto');
      INSERT INTO $tablaImgCode (path, code) VALUES ('assets/picto_claves/morado.jpg', 'morado.jpg_picto');
      INSERT INTO $tablaImgCode (path, code) VALUES ('assets/picto_claves/naranja.png', 'naranja.png_picto');
      INSERT INTO $tablaImgCode (path, code) VALUES ('assets/picto_claves/rojo.jpg', 'rojo.jpg_picto');
      INSERT INTO $tablaImgCode (path, code) VALUES ('assets/picto_claves/rosa.png', 'rosa.png_picto');
      INSERT INTO $tablaImgCode (path, code) VALUES ('assets/imgs_claves/amarillo.jpg', 'amarillo.jpg_img');
      INSERT INTO $tablaImgCode (path, code) VALUES ('assets/imgs_claves/azul.png', 'azul.png_img');
      INSERT INTO $tablaImgCode (path, code) VALUES ('assets/imgs_claves/morado.jpg', 'morado.jpg_img');
      INSERT INTO $tablaImgCode (path, code) VALUES ('assets/imgs_claves/naranja.png', 'naranja.png_img');
      INSERT INTO $tablaImgCode (path, code) VALUES ('assets/imgs_claves/rojo.jpg', 'rojo.jpg_img');
      INSERT INTO $tablaImgCode (path, code) VALUES ('assets/imgs_claves/rosa.png', 'rosa.png_img');
    ''');

    await db.execute('''
      INSERT INTO $tablaDecrypt (user, path) VALUES ('alissea', 'assets/picto_claves/rojo.jpg');
      INSERT INTO $tablaDecrypt (user, path) VALUES ('alissea', 'assets/picto_claves/naranja.png');
      INSERT INTO $tablaDecrypt (user, path) VALUES ('alissea', 'assets/picto_claves/amarillo.jpg');
      INSERT INTO $tablaDecrypt (user, path) VALUES ('alissea', 'assets/picto_claves/azul.png');
      INSERT INTO $tablaDecrypt (user, path) VALUES ('alissea', 'assets/picto_claves/morado.jpg');
      INSERT INTO $tablaDecrypt (user, path) VALUES ('alissea', 'assets/picto_claves/rosa.png');
      INSERT INTO $tablaDecrypt (user, path) VALUES ('juancito', 'assets/imgs_claves/rojo.jpg');
      INSERT INTO $tablaDecrypt (user, path) VALUES ('juancito', 'assets/imgs_claves/naranja.png');
      INSERT INTO $tablaDecrypt (user, path) VALUES ('juancito', 'assets/imgs_claves/amarillo.jpg');
      INSERT INTO $tablaDecrypt (user, path) VALUES ('juancito', 'assets/imgs_claves/azul.png');
      INSERT INTO $tablaDecrypt (user, path) VALUES ('juancito', 'assets/imgs_claves/morado.jpg');
      INSERT INTO $tablaDecrypt (user, path) VALUES ('juancito', 'assets/imgs_claves/rosa.png');
    '''); 

    /// INSERTAR MENUS ///
    await db.execute('''
      INSERT INTO $tablaMenu (name, pictogram, image) VALUES ('Vegetariano', 'assets/picto_menu/vegetariano.png', 'assets/imgs_menu/vegetariano.jpg');
      INSERT INTO $tablaMenu (name, pictogram, image) VALUES ('Carne', 'assets/picto_menu/carne.png', 'assets/imgs_menu/carne.jpg');
      INSERT INTO $tablaMenu (name, pictogram, image) VALUES ('Sin gluten', 'assets/picto_menu/sin_gluten.png', 'assets/imgs_menu/sin_gluten.png');
    ''');

    /// INSERTAR CLASES ///
    await db.execute('''
      INSERT INTO $tablaClassroom (name, image) VALUES ('A', 'assets/aulas/a.png');
      INSERT INTO $tablaClassroom (name, image) VALUES ('B', 'assets/aulas/b.png');
      INSERT INTO $tablaClassroom (name, image) VALUES ('C', 'assets/aulas/c.png');

    ''');

    /// INSERTAR TAREAS ///
    await db.execute('''
      INSERT INTO $tablaTask (name, description, pictogram, image) VALUES ('Comedor', 'Tomar las comandas del día','assets/tareas/comedor.png','assets/tareas/comedor.png');
      INSERT INTO $tablaTask (name, description, pictogram, image) VALUES ('Fregar los Platos', '','assets/tareas/fregar.png','assets/tareas/fregar.png');
      INSERT INTO $tablaTask (name, description, pictogram, image) VALUES ('Hacer la cama', '', 'assets/tareas/cama.png','assets/tareas/cama.png');
      INSERT INTO $tablaTask (name, description, pictogram, image) VALUES ('Poner el microondas', '', 'assets/tareas/microondas.png','assets/tareas/microondas.png');
      INSERT INTO $tablaTask (name, description, pictogram, image) VALUES ('Lorem', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce volutpat  aliquam auctor. Orci varius natoque penatibus et magnis dis parturient  montes, nascetur ridiculus mus. Nam vel bibendum ante. Ut ex odio,  posuere id hendrerit vel, commodo a velit. Mauris quis nunc rutrum,  molestie augue vel, vestibulum tellus.', 'assets/logo.png','assets/logo.png');

    '''); 

    /// INSERTAR PASOS DE TAREAS ///
    await db.execute('''
      INSERT INTO $tablaStep (task_id, description, pictogram, image) VALUES (2, 'Coger los platos', 'assets/tareas/fregar.png', 'assets/tareas/fregar.png');
      INSERT INTO $tablaStep (task_id, description, pictogram, image) VALUES (2, 'Fregar los platos', 'assets/tareas/fregar.png', 'assets/tareas/fregar.png');
      INSERT INTO $tablaStep (task_id, description, pictogram, image) VALUES (2, 'Secar los platos', 'assets/tareas/fregar.png', 'assets/tareas/fregar.png');
    ''');
    
    DateTime now = DateTime.now();
    String date = '${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    print(date);
    /// INSERTAR EJECUCIONES DE TAREAS ///
		await db.execute(''' INSERT INTO $tablaExecute (user, task_id, date, status) VALUES (?, ?, ?, ?); ''', ['alissea', 2, '2024-12-01', 1]);
		await db.execute(''' INSERT INTO $tablaExecute (user, task_id, date, status) VALUES (?, ?, ?, ?); ''', ['alissea', 2, '2025-01-01', 0]);
		await db.execute(''' INSERT INTO $tablaExecute (user, task_id, date, status) VALUES (?, ?, ?, ?); ''', ['alissea', 3, '2025-01-01', 0]);
		await db.execute(''' INSERT INTO $tablaExecute (user, task_id, date, status) VALUES (?, ?, ?, ?); ''', ['alex123', 1, date, 0]);
		await db.execute(''' INSERT INTO $tablaExecute (user, task_id, date, status) VALUES (?, ?, ?, ?); ''', ['alex123', 2, '2025-01-02', 0]);
		await db.execute(''' INSERT INTO $tablaExecute (user, task_id, date, status) VALUES (?, ?, ?, ?); ''', ['alex123', 3, '2025-01-01', 0]);

	}


///////////////////////////////////////////////////////////////////////////////////////////////////
///  MÉTODOS PARA LA TABLA DE ESTUDIANTES  ///

  /*
    Método
    @Nombre --> insertStudent
    @Funcion --> Registra a un alumno en la base de datos
    @Argumentos
      - Student: objeto de la clase Student que contiene todos los datos necesarios para añadir un nuevo alumno a la tabla
                  de estudiantes.
  */

	Future<bool> insertStudent(Student student) async {
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
    @Nombre --> modifyInterfaceStudent
    @Funcion --> Modifica la interfaz que usará un alumno para iniciar sesión
    @Argumentos
      - user: usuario del alumno al que se le realizará las modificaciónes
      - interfaceIMG: determina si el alumno usará la interfaz basada en imágenes
      - interfacePIC: determina si el alumno usará la interfaz basada en pictogramas
      - intefaceTXT: determina si el alumno usará la interfaz basada en texto
  */
  Future<bool>modifyInterfaceStudent(user, interfaceIMG, interfacePIC, interfaceTXT) async {
    final db = await instance.database;
    try {
      int count = await db.update(
        tablaStudents,
        {
          'interfaceIMG': interfaceIMG,
          'interfacePIC': interfacePIC,
          'interfaceTXT': interfaceTXT
        },
        where: 'user = ?',
        whereArgs: [user],
      );

      return count > 0;
    } catch (e) {
      print("Error al modificar la interfaz: $e");
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
    @Nombre --> deleteStudent
    @Funcion --> Elimina un alumno de la base de datos
    @Argumentos
      - user: usuario del alumno que será eliminado
  */
  Future<bool> deleteStudent(String user) async {
    final db = await instance.database;
    try {
      int count = await db.delete(
        tablaStudents, 
        where: 'user = ?', 
        whereArgs:[user]
      );
      return count > 0;
    } catch (e) {
      print("Error al eliminar el estudiante: $e");
      return false;
    }
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

  // TOMATE
  Future<int?> getSpacesPasswordCount(String user) async {
    final db = await instance.database;
    final result = await db.query(
      tablaStudents,
      columns: ['password'],
      where: 'user = ?',
      whereArgs: [user],
    );

    if (result.isNotEmpty) {
      final String password = result.first['password'] as String;
      return password.split(' ').length;
    } else {
      return null;
    }
  }


///////////////////////////////////////////////////////////////////////////////////////////////////  
///  MÉTODOS PARA LA TABLA DE IMÁGENES  ///
/// 
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

///////////////////////////////////////////////////////////////////////////////////////////////////
///  MÉTODOS PARA LA TABLA DE DECRYPT  ///

  /*
    Método
    @Nombre --> insertDecryptEntries
    @Funcion --> Permite asignar a un alumno las imágenes que usará para iniciar sesión
    @Argumentos
      - user: el usuario del alumno al que se le asignarán las imágenes
			- images: las imágenes que usará dicho usuario para iniciar sesión
  */
  Future<bool> insertDecryptEntries(String user, List<ImgCode> images) async {
    final db = await instance.database;
    
    final batch = db.batch();
    for (var img in images) {
      batch.insert(tablaDecrypt, {'user': user, 'path': img.path});
    }
    final result = await batch.commit();
    return result.isNotEmpty;
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

  Future<List<Decrypt>>getDecryptEntries(String user) async {
    final db = await instance.database;
    final result = await db.query(
      tablaDecrypt,
      where: 'user = ?',
      whereArgs: [user],
    );
    return result.map((map) => Decrypt.fromMap(map)).toList();
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

///////////////////////////////////////////////////////////////////////////////////////////////////
///  MÉTODOS PARA LA TABLA DE MENÚS  ///

  /*
    Método
    @Nombre --> insertMenu
    @Funcion --> Inserta un menú en la base de datos
    @Argumentos
      - menu: objeto de la clase Menu que contiene todos los datos necesarios 
              para añadir un nuevo menú a la tabla de menús.
  */
  Future<bool> insertMenu(Menu menu) async {
    final db = await instance.database;
    try {
      await db.insert(tablaMenu, menu.toMap());
      return true;
    } catch (e) {
      print("Error al insertar el menú: $e");
      return false;
    }
  }

  /*
  Método
  @Nombre --> modifyMenu
  @Funcion --> Modifica los datos de un menú en la base de datos
  @Argumentos
    - name: nombre del menú
    - data: dato del menú que será modificado (name, pictogram, image)
    - newData: nuevo valor del dato modificado
  */
  Future<bool> modifyMenu(String name, String data, String newData) async {
    final db = await instance.database;

    try {
      int count = await db.update(
        tablaMenu,
        {data: newData},
        where: 'name = ?',
        whereArgs: [name],
      );

      return count > 0;
    } catch (e) {
      print("Error al modificar el dato: $e");
      return false;
    }
  }

  /*
    Método
    @Nombre --> modifyCompleteMenu
    @Funcion --> Actualiza todos los datos de un menú registrado en la base de datos
    @Argumentos
      - name: nombre del menú
      - newName: nuevo nombre del menú
      - newPictogram: nuevo pictograma asociado al menú
      - newImage: nueva imagen asociada al menú
  */
  Future<bool> modifyCompleteMenu(String name, String newName, String newPictogram, String newImage) async {
    final db = await instance.database;
    try {
      int count = await db.update(
        tablaMenu,
        {
          'name': newName,
          'pictogram': newPictogram,
          'image': newImage
        },
        where: 'name = ?',
        whereArgs: [name],
      );

      return count > 0;
    } catch (e) {
      print("Error al modificar el menú: $e");
      return false;
    }
  }

  /*
    Método
    @Nombre --> deleteMenu
    @Funcion --> Elimina un menú de la base de datos
    @Argumentos
      - name: nombre del menú que será eliminado
  */
  Future<bool> deleteMenu(String name) async {
    final db = await instance.database;

    try {
      int count = await db.delete(
        tablaMenu,
        where: 'name = ?',
        whereArgs: [name],
      );

      return count > 0;
    } catch (e) {
      print("Error al eliminar el menú: $e");
      return false;
    }
  }

  /*
    Método
    @Nombre --> getMenu
    @Funcion --> Devuelve un menú en concreto en base a su nombre
    @Argumentos
      - name: nombre del menú que será devuelto
  */
  Future<Menu> getMenu(String name) async {
    final db = await instance.database;
    final result = await db.query(
      tablaMenu,
      where: 'name = ?',
      whereArgs: [name],
    );
    return Menu.fromMap(result.first);
  }

  /*
    Método
    @Nombre --> getAllMenus
    @Funcion --> Devuelve todos los menús de la base de datos
  */
  Future<List<Menu>> getAllMenus() async {
    final db = await instance.database;
    final result = await db.query(tablaMenu);
    return result.map((map) => Menu.fromMap(map)).toList();
  }

  /*
    Método
    @Nombre --> menuIsValid
    @Funcion --> Comprueba que un menú en concreto exista en la base de datos
    @Argumentos
      - name: el nombre del menú
  */
  Future<bool> menuIsValid(String name) async {
    final db = await instance.database;
    final result = await db.query(
      tablaMenu,
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isEmpty;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////
///  MÉTODOS PARA LA TABLA DE AULAS  ///

  /*
    Método
    @Nombre --> insertClassroom
    @Funcion --> Inserta un aula en la base de datos
    @Argumentos
      - classroom: objeto de la clase Classroom que contiene todos los datos necesarios 
                  para añadir un nuevo aula a la tabla de aulas.
  */
  Future<bool> insertClassroom(Classroom classroom) async {
    final db = await instance.database;
    try {
      await db.insert(tablaClassroom, classroom.toMap());
      return true;
    } catch (e) {
      print("Error al insertar el aula: $e");
      return false;
    }
  }

  /*
    Método
    @Nombre --> modifyClassroom
    @Funcion --> Modifica los datos de un aula en la base de datos
    @Argumentos
      - name: nombre del aula
      - newName: nuevo nombre del aula
  */
  Future<bool> modifyClassroom(String name, String newName) async {
    final db = await instance.database;
    try {
      await db.update(
        tablaClassroom, 
        {'name': newName}, 
        where: 'name = ?',
        whereArgs: [name]
      );

      return true;

      } catch (e) {
        print("Error al modificar el aula: $e");
        return false;
      }
  }

  /*
    Método
    @Nombre --> deleteClassroom
    @Funcion --> Elimina un aula de la base de datos
    @Argumentos
      - name: nombre del aula que será eliminado
  */
  Future<bool> deleteClassroom(String name) async {
    final db = await instance.database;
    try {
      await db.delete(
        tablaClassroom, 
        where: 'name = ?', 
        whereArgs: [name]
      );

      return true;
    } catch (e) {
      print("Error al eliminar el aula: $e");
      return false;
    }
  }

  /*
    Método
    @Nombre --> getClassroom
    @Funcion --> Devuelve un aula en concreto en base a su nombre
    @Argumentos
      - name: nombre del aula que será devuelto
  */
  Future<Classroom> getClassroom(String name) async {
    final db = await instance.database;
    final result = await db.query(
      tablaClassroom, 
      where: 'name = ?', 
      whereArgs : [name]);
    return Classroom.fromMap(result.first);
  }

  /*
    Método
    @Nombre --> getAllClassrooms
    @Funcion --> Devuelve todas las aulas de la base de datos
  */
  Future<List<Classroom>> getAllClassrooms() async {
    final db = await instance.database;
    final result = await db.query(tablaClassroom);
    return result.map((map) => Classroom.fromMap(map)).toList();
  }
  

///////////////////////////////////////////////////////////////////////////////////////////////////
///  MÉTODOS PARA LA TABLA DE PEDIDOS  ///

  /* 
    Método
    @Nombre --> insertOrders
    @Funcion --> Inserta una comanda en la base de datos
    @Argumentos
      - order: objeto de la clase Order que contiene todos los datos necesarios 
              para añadir una nueva comanda a la tabla de comandas.
  */
  Future<bool> insertOrders(Order order) async {
    final db = await instance.database;
    try {
      await db.insert(tablaOrders,order.toMap());
      return true;
    } catch (e) {
      print("Error al insertar la orden: $e");
      return false;
    }
  }

  /*
    Método
    @Nombre --> modifyOrders
    @Funcion --> Modifica los datos de una comanda en la base de datos
    @Argumentos
      - order: objeto de la clase Order que contiene todos los datos necesarios 
              para modificar una comanda en la tabla de comandas.
      - newQuantity
  */
  Future<bool> modifyOrders(Order order, int newQuantity) async {
    final db = await instance.database;
    try {
      await db.update(
        tablaOrders, 
        {'quantity' : newQuantity}, 
        where: 'date = ? AND menuName = ? AND classroomName = ?', 
        whereArgs : [order.date, order.menuName, order.classroomName]
      );
      return true;
    } catch (e) {
      print("Error al modificar la orden: $e");
      return false;
    }
  }

  /* 
    Método
    @Nombre --> getOrder
    @Funcion --> Devuelve una comanda en concreto fecha, nombre del menú y nombre del aula
    @Argumentos
      - date: fecha de la comanda
      - menuName: nombre del menú de la comanda
      - classroomName: nombre del aula de la comanda 
  */
  Future<Order?> getOrder(String date, String menuName, String classroomName) async {
    final db = await instance.database;
    try{
      final result = await db.query(
        tablaOrders, 
        where: 'date = ? AND menuName = ? AND classroomName = ?', 
        whereArgs : [date, menuName, classroomName]
      );
      return Order.fromMap(result.first);
    } catch (e) {
      print("Error al obtener la orden: $e");
      return null;
    }
  }

/*
  Método
  @Nombre --> getOrdersByDate
  @Funcion --> Devuelve todas las comandas de una fecha concreta
  @Argumentos
    - date: fecha de las comandas
*/
  Future<List<Order>> getOrdersByDate(String date) async {
    final db = await instance.database;
    final result = await db.query(
      tablaOrders,
      where: 'date = ?',
      whereArgs: [date],
    );
    return result.map((map) => Order.fromMap(map)).toList();
  }

/*
  Método
  @Nombre --> classCompleted
  @Funcion --> Comprueba si una clase tiene comandas en una fecha concreta
  @Argumentos
    - classroom: aula de la que se comprobará si tiene comandas
    - date: fecha de las comandas
*/
  Future<bool> classCompleted(Classroom classroom, String date) async {
    final db = await instance.database;
    final result = await db.query(
      tablaOrders,
      where: 'classroomName = ? AND date = ?',
      whereArgs: [classroom.name, date],
    );
    return result.isNotEmpty;
  }


///////////////////////////////////////////////////////////////////////////////////////////////////
///  MÉTODOS QUE GESTIONAN LA TAREA MENU Y SU ASIGNACIÓN A LOS ALUMNOS  ///
/// 

  /*
    Método
    @Nombre --> setMenuTask
    @Funcion --> Permite asignar la tarea del menu a un alumno
    @Argumentos
      - user: usuario del alumno al que se le asignará la tarea
  */
  Future<bool> setMenuTask(String user) async {
    DateTime now = DateTime.now();
    String date = '${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final db = await instance.database;
    try{
      bool result = await hasMenuTaskToday();
      if(result){
        print("La tarea del comedor ya ha sido asignada");
        return false;
      }else{
        await db.insert(
          tablaExecute,
          Execute(
            user: user,
            task_id: 1,
            date: date,
            status: 0
          ).toMap() 
        );
        return true;
      }
    } catch (e) {
      print("Error al insertar la tarea del comedor: $e");
      return false;
    }
  }

  /*
    Método
    @Nombre --> hasMenuTaskToday
    @Funcion --> Comprueba si la tarea del menú ya ha sido asignada a un alumno en el día actual
  */
  Future<bool> hasMenuTaskToday() async {
    DateTime now = DateTime.now();
    String date = '${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    print(date);
    final db = await instance.database;
    final result = await db.query(
      tablaExecute,
      where: 'date = ? AND task_id = 1',
      whereArgs: [date],
    );
    return result.isNotEmpty;
  }

  Future<bool> menuTaskCompleted() async {
    DateTime now = DateTime.now();
    String date = '${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    print(date);
    final db = await instance.database;

    try {
      int count = await db.update(
        tablaExecute,
        {'status': 1},
        where: 'task_id = ? AND date = ?',
        whereArgs: [1, date],
      );

      return count > 0;
    } catch (e) {
      print("Error al modificar el execute: $e");
      return false;
    }

  }
  
///////////////////////////////////////////////////////////////////////////////////////////////////
///  MÉTODOS PARA LA TABLA DE TAREAS  ///
  
  Future<bool> insertTask(String name, String descripction, String pictogram, String image, String? descriptive_text) async {
    final db = await instance.database;
    try {
      await db.insert(tablaTask, {
        'name': name,
        'description': descripction,
        'image': image,
        'pictogram': pictogram,
        'descriptive_text': descriptive_text
      });
      return true;
    } catch (e) {
      print("Error al insertar la tarea: $e");
      return false;
    }
  }

  Future<bool> modifyTask(int id, String data, String newData) async {
    final db = await instance.database;

    try {
      int count = await db.update(
        tablaTask,
        {data: newData},
        where: 'id = ?',
        whereArgs: [id],
      );

      return count > 0;
    } catch (e) {
      print("Error al modificar la tarea: $e");
      return false;
    }
  }

  Future<bool> modifyCompleteTask(int id, String name, String description,String pictogram, String image, String? descriptive_text) async {
    final db = await instance.database;
    try {
      int count = await db.update(
        tablaTask,
        {
          'name': name,
          'description': description,
          'image': image,
          'pictogram': pictogram,
          'descriptive_text': descriptive_text
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      return count > 0;
    } catch (e) {
      print("Error al modificar la tarea: $e");
      return false;
    }
  }

  Future<bool> deleteTask(int id) async {
    final db = await instance.database;
    try {
      int count = await db.delete(
        tablaTask, 
        where: 'id = ?', 
        whereArgs:[id]
      );
      return count > 0;
    } catch (e) {
      print("Error al eliminar la tarea: $e");
      return false;
    }
  }

  Future<Task?> getTask(int id) async {
    final db = await instance.database;
    final result = await db.query(
      tablaTask,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Task.fromMap(result.first);
    } else {
      return null; // o maneja el caso donde no se encuentra la tarea
    }
  }

  Future<Task?> getTaskByName(String name) async {
    final db = await instance.database;
    final result = await db.query(
      tablaTask,
      where: 'name = ?',
      whereArgs: [name],
    );
    if (result.isNotEmpty) {
      return Task.fromMap(result.first);
    } else {
      return null; // o maneja el caso donde no se encuentra la tarea
    }
  }

  Future<List<Task>> searchTasks(String text) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result;
    if (await hasMenuTaskToday())
      result = await db.query(
        tablaTask,
        where: 'id != 1 AND (name LIKE ? OR description LIKE ?)',
        whereArgs: ['%$text%', '%$text%'],
      );
    else 
      result = await db.query(
        tablaTask,
        where: 'name LIKE ? OR description LIKE ?',
        whereArgs: ['%$text%', '%$text%'],
      );
    return result.map((map) => Task.fromMap(map)).toList();
  }
  
  Future<List<Task>> getAllTasks() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result;
    if (await hasMenuTaskToday())
      result = await db.query(
        tablaTask,
        where: 'id != 1',
      );
    else
      result = await db.query(tablaTask);
    return result.map((map) => Task.fromMap(map)).toList();
  }

///////////////////////////////////////////////////////////////////////////////////////////////////
///  MÉTODOS PARA LA TABLA DE STEPS  ///

  Future<bool> insertStep(Step step) async {
    final db = await instance.database;
    try {
      await db.insert(tablaStep, step.toMap());
      return true;
    } catch (e) {
      print("Error al insertar el paso: $e");
      return false;
    }
  }

  Future<bool> modifyStep(int id, int task_id, String data, String newData) async {
    final db = await instance.database;

    try {
      int count = await db.update(
        tablaStep,
        {data: newData},
        where: 'id = ? and task_id = ?',
        whereArgs: [id, task_id],
      );

      return count > 0;
    } catch (e) {
      print("Error al modificar el paso: $e");
      return false;
    }
  }

  Future<bool> deleteStep(int id, int task_id) async {
    final db = await instance.database;
    try {
      int count = await db.delete(
        tablaStep, 
        where: 'id = ? AND task_id = ?', 
        whereArgs:[id, task_id]
      );

      if (count > 0)
        return await modifyAllId(id, task_id);
      else return false;
    } catch (e) {
      print("Error al eliminar el paso: $e");
      return false;
    }
  }

  Future<bool> modifyAllId(int id, int task_id) async {
    final db = await instance.database;
    try{
      final count = await db.rawUpdate('''
      UPDATE $tablaStep
      SET id = id - 1
      WHERE id > ? AND task_id = ?
    ''', [id, task_id]);
      return count > 0;
    }
    catch(e){
      print("Error al modificar todos los id: $e");
      return false;
    }
  }

  Future<Step> getStep(int id, task_id) async {
    final db = await instance.database;
    final result = await db.query(
      tablaStep,
      where: 'id = ? AND task_id = ?',
      whereArgs: [id, task_id],
    );
    return Step.fromMap(result.first);
  }

  Future<List<Step>> getAllStepsFromTask(int idTask) async {
    final db = await instance.database;
    final result = await db.query(
      tablaStep,
      where: 'task_id = ?',
      whereArgs: [idTask],
    );
    return result.map((map) => Step.fromMap(map)).toList();
  }

  Future<bool> taskIsValid(String name) async {
    final db = await instance.database;
    final result = await db.query(
      tablaTask,
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isEmpty;
  }


///////////////////////////////////////////////////////////////////////////////////////////////////
///  MÉTODOS PARA LA TABLA DE EXECUTE  ///

  Future<bool> insertExecute(Execute execute) async {
    final db = await instance.database;
    try {
      await db.insert(tablaExecute, execute.toMap());
      return true;
    } catch (e) {
      print("Error al insertar el execute: $e");
      return false;
    }
  }

  Future<bool> modifyExecuteDate(Execute execute, String date) async {
    final db = await instance.database;

    try {
      int count = await db.update(
        tablaExecute,
        {'date': date},
        where: 'id_task = ? AND user = ? AND date = ?',
        whereArgs: [execute.task_id, execute.user, execute.date],
      );

      return count > 0;
    } catch (e) {
      print("Error al modificar el execute: $e");
      return false;
    }
  }

    Future<bool> modifyExecuteStatus(Execute execute, int status) async{
      final db = await instance.database;

      try {
      int count = await db.update(
        tablaExecute,
        {'status': status},
        where: 'id_task = ? AND user = ? AND date = ?',
        whereArgs: [execute.task_id, execute.user, execute.date],
      );

      return count > 0;
    } catch (e) {
      print("Error al modificar el execute: $e");
      return false;
    }

  }

  Future<bool> deleteExecute(Execute execute) async {
    final db = await instance.database;
    try {
      int count = await db.delete(
        tablaExecute,
        where: 'user = ? AND task_id = ? AND date = ?',
        whereArgs: [execute.user, execute.task_id, execute.date],
      );
      return count > 0;
    } catch (e) {
      print("Error al eliminar el execute: $e");
      return false;
    }
  }

  Future<Execute> getExecute(int id_task, String user, String date) async {
    final db = await instance.database;
    final result = await db.query(
      tablaExecute,
      where: 'id_task = ? AND user = ? AND date = ?',
      whereArgs: [id_task, user, date],
    );
    return Execute.fromMap(result.first);
  }

  Future<List<Execute>> getStudentExecutes(String user) async {
    final db = await instance.database;
    final result = await db.query(
      tablaExecute,
      where: 'user = ?',
      whereArgs: [user],
      orderBy: 'status ASC, date ASC',
    );
    return result.map((map) => Execute.fromMap(map)).toList();
  }

  Future<List<Execute>> getStudentToDo(String user) async {
    final db = await instance.database;
    final result = await db.query(
      tablaExecute,
      where: 'user = ? AND status = 0',
      whereArgs: [user],
      orderBy: 'date ASC',
    );
    return result.map((map) => Execute.fromMap(map)).toList();
  }


}