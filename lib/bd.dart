import 'dart:io';
import 'package:proyecto/classes/Classroom.dart';
import 'package:proyecto/classes/Menu.dart';
import 'package:proyecto/classes/Orders.dart';
import 'package:proyecto/classes/Student.dart';
import 'package:proyecto/classes/ImgCode.dart';
import 'package:proyecto/classes/Decrypt.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
			interfaceTXT TINYINT(1) NOT NULL,
      diningRoomTask TINYINT(1) NOT NULL
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
			FOREIGN KEY (user) REFERENCES $tablaStudents(user),
			FOREIGN KEY (path) REFERENCES $tablaImgCode(path),
			PRIMARY KEY (user, path)
			)
		''');

		
    /// TABLA MENU  ///
		await db.execute('''
			CREATE TABLE $tablaMenu(
			name VARCHAR(30),
			pictogram VARCHAR(30),
			image VARCHAR(30),
			PRIMARY KEY (name)
			)
		''');

    /// TABLA CLASSROOM  ///
		await db.execute('''
			CREATE TABLE $tablaClassroom(
			name VARCHAR(30),
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
      FOREIGN KEY (menuName) REFERENCES $tablaMenu(name),
			FOREIGN KEY (classroomName) REFERENCES $tablaClassroom(name)
			)
		''');

    /// INSERTAR DATOS DE PRUEBA ///
    await db.execute('''
      INSERT INTO $tablaStudents (user, name, surname, image, password, typePassword, interfaceIMG, interfacePIC, interfaceTXT, diningRoomTask) VALUES ('alissea', 'Alicia', '', 'assets/perfiles/alissea.png', 'rosa.png_picto azul.png_picto ', 'pictograms', 0, 1, 0, 0);
      INSERT INTO $tablaStudents (user, name, surname, image, password, typePassword, interfaceIMG, interfacePIC, interfaceTXT, diningRoomTask) VALUES ('alex123', 'Alex', '', 'assets/perfiles/alex123.png', '1234', 'alphanumeric', 0, 0, 1, 0);
      INSERT INTO $tablaStudents (user, name, surname, image, password, typePassword, interfaceIMG, interfacePIC, interfaceTXT, diningRoomTask) VALUES ('juancito', 'Juan', '', 'assets/perfiles/juancito.png', 'azul.png_img', 'images', 1, 0, 0, 0);
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
      INSERT INTO $tablaDecrypt (user, path) VALUES ('juancito', 'assets/imgs_clave/rojo.jpg');
      INSERT INTO $tablaDecrypt (user, path) VALUES ('juancito', 'assets/imgs_clave/naranja.png');
      INSERT INTO $tablaDecrypt (user, path) VALUES ('juancito', 'assets/imgs_clave/amarillo.jpg');
      INSERT INTO $tablaDecrypt (user, path) VALUES ('juancito', 'assets/imgs_clave/azul.png');
      INSERT INTO $tablaDecrypt (user, path) VALUES ('juancito', 'assets/imgs_clave/morado.jpg');
      INSERT INTO $tablaDecrypt (user, path) VALUES ('juancito', 'assets/imgs_clave/rosa.png');
    '''); 

    /// INSERTAR MENUS ///
    await db.execute('''
      INSERT INTO $tablaMenu (name, pictogram, image) VALUES ('Vegetariano', 'assets/picto_menu/vegetariano.png', 'assets/img_menu/vegetariano.jpg');
      INSERT INTO $tablaMenu (name, pictogram, image) VALUES ('Carne', 'assets/picto_menu/carne.png', 'assets/img_menu/carne.jpg');
      INSERT INTO $tablaMenu (name, pictogram, image) VALUES ('Sin gluten', 'assets/picto_menu/sin_gluten.png', 'assets/img_menu/sin_gluten.png');
    ''');

    /// INSERTAR CLASES ///
    await db.execute('''
      INSERT INTO $tablaClassroom (name) VALUES ('Clase A');
      INSERT INTO $tablaClassroom (name) VALUES ('Clase B');
      INSERT INTO $tablaClassroom (name) VALUES ('Clase C');
    ''');
	}


///////////////////////////////////////////////////////////////////////////////////////////////////
///  MÉTODOS PARA LA TABLA DE ESTUDIANTES  ///

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

///////////////////////////////////////////////////////////////////////////////////////////////////  
///  MÉTODOS PARA LA TABLA DE IMÁGENES  ///

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
      - order: objeto de la clase Orders que contiene todos los datos necesarios 
              para añadir una nueva comanda a la tabla de comandas.
  */
  Future<bool> insertOrders(Orders order) async {
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
      - order: objeto de la clase Orders que contiene todos los datos necesarios 
              para modificar una comanda en la tabla de comandas.
      - newQuantity
  */
  Future<bool> modifyOrders(Orders order, int newQuantity) async {
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
  Future<Orders?> getOrder(String date, String menuName, String classroomName) async {
    final db = await instance.database;
    try{
      final result = await db.query(
        tablaOrders, 
        where: 'date = ? AND menuName = ? AND classroomName = ?', 
        whereArgs : [date, menuName, classroomName]
      );
      return Orders.fromMap(result.first);
    } catch (e) {
      print("Error al obtener la orden: $e");
      return null;
    }
  }


///////////////////////////////////////////////////////////////////////////////////////////////////
///  MÉTODOS SOBRE LA TAREA DEL MENU  ///

  /*
    Método
    @Nombre --> setMenuTask
    @Funcion --> Permite asignar la tarea del menu a un alumno
    @Argumentos
      - user: usuario del alumno al que se le asignará la tarea
  */
  Future<bool> setMenuTask(String user) async {
    final db = await instance.database;
    try {
      await db.update(
        tablaStudents,
        {'diningRoomTask': 1},
        where: 'user = ?',
        whereArgs: [user],
      );
      return true;
    } catch (e) {
      print("Error al asignar la tarea del menú: $e");
      return false;
    }
  }

  /*
    Método
    @Nombre --> removeMenuTask
    @Funcion --> Permite eliminar la tarea del menu a un alumno
    @Argumentos
      - user: usuario del alumno al que se le eliminará la tarea
  */
  Future<bool> removeMenuTask(String user) async {
    final db = await instance.database;
    try {
      await db.update(
        tablaStudents,
        {'diningRoomTask': 0},
        where: 'user = ?',
        whereArgs: [user],
      );
      return true;
    } catch (e) {
      print("Error al eliminar la tarea del menú: $e");
      return false;
    }
  }

  /*
    Método
    @Nombre --> getStudentsWithMenuTask
    @Funcion --> Devuelve todos los usuarios de los alumnos que tienen la tarea del menú asignada
  */
  Future<List<String>> getStudentsWithMenuTask() async {
    final db = await instance.database;
    final result = await db.query(
      tablaStudents,
      where: 'diningRoomTask = 1',
    );
    return result.map((map) => map['user'].toString()).toList();
  }

  /*
    Método
    @Nombre --> hasMenuTask
    @Funcion --> Comprueba si un alumno tiene la tarea del menú asignada
    @Argumentos
      - user: usuario del alumno
  */
  Future<bool> hasMenuTask(String user) async {
    final db = await instance.database;
    final result = await db.query(
      tablaStudents,
      where: 'user = ? AND diningRoomTask = 1',
      whereArgs: [user],
    );
    return result.isNotEmpty;
  }


}