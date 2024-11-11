import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'Student.dart';
import 'ImgCode.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Estudiantes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StudentListPage(),
    );
  }
}

// Página de lista de estudiantes
class StudentListPage extends StatelessWidget {
  // TOMATE se recuperan los estudiantes de la BD
  final List<Student> students = List.generate(20, (index) => Student(user: 'estudiante$index', name: 'Estudiante $index', surname: 'Apellidos $index', password: 'a', image: 'assets/perfiles/imagen_guardada.jpg', typePassword: 'alphanumeric', interfaceIMG: 0, interfacePIC: 0, interfaceTXT: 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: Container(
          width: 740,
          height: 625,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lista de Estudiantes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                'Selecciona un estudiante para modificar',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 30),
              // Lista de estudiantes en un Expanded para que sea scrollable
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text('${student.name} ${student.surname}'),
                        subtitle: Text('Usuario: ${student.user}'),
                        onTap: () {
                          // Navegar a la página de modificación del estudiante
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentModificationPage(student: student),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página de modificación de estudiante
class StudentModificationPage extends StatefulWidget {
  final Student student; // Recibir el estudiante seleccionado

  StudentModificationPage({required this.student});

  @override
  _StudentModificationPageState createState() =>
      _StudentModificationPageState();
}

class _StudentModificationPageState extends State<StudentModificationPage> {
  // TOMATE valores iniciales según los que tuviese el estudiante
  bool interfacePIC = false;
  bool interfaceIMG = false;
  bool interfaceTXT = false;
  bool interfaceAV = false;

  late String passwordType; // TOMATE valor anterior para la selección de contraseña

  // Para almacenar la imagen que se suba
  File? image;

  // Método para seleccionar la imagen
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  // Método para guardar la imagen
  Future<void> saveImage(File image, String imgName, String dir) async {
    try {
      final directory = Directory('$dir');
      
      // Crea la carpeta si no existe
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final fileName = '$imgName';
      final String newPath = path.join(directory.path, fileName);

      // Copia la imagen a la ruta relativa
      final File localImage = await image.copy(newPath);
      print('Imagen guardada en: ${localImage.path}');
      
    } catch (e) {
      print("Error al guardar la imagen: $e");
    }
  }

  // Controladores para los campos de texto
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController userController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializar los campos con los datos del estudiante
    nameController.text = widget.student.name;
    surnameController.text = widget.student.surname!;
    userController.text = widget.student.user;
    passwordType = widget.student.typePassword;
    image = File(widget.student.image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: Container(
          width: 740,
          height: 650,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Modificación de ${widget.student.name}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                'Modifica los datos del estudiante',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 30),
              // Formulario
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campos de texto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: surnameController,
                          decoration: InputDecoration(
                            labelText: 'Apellidos',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Usuario del estudiante: ${widget.student.user}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Imagen de perfil
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Imagen de perfil',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: pickImage,  // Lógica para seleccionar una imagen
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click, // Cambiar el cursor
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: image == null
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.cloud_upload,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                              Text(
                                                'Sube una imagen',
                                                style: TextStyle(color: Colors.grey),
                                              ),
                                            ],
                                          )
                                        : Image.file(
                                            image!,
                                            fit: BoxFit.contain,
                                            width: double.infinity,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 40),
                  // Opciones de selección
                  Expanded(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Opciones de visualización
                      Text(
                        'Selecciona cómo ve la aplicación el estudiante',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: interfacePIC,
                            onChanged: (bool? value) {
                              setState(() {
                                interfacePIC = value ?? false;
                              });
                            },
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Pictogramas',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: interfaceIMG,
                            onChanged: (bool? value) {
                              setState(() {
                                interfaceIMG = value ?? false;
                              });
                            },
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Imágenes',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: interfaceTXT,
                            onChanged: (bool? value) {
                              setState(() {
                                interfaceTXT = value ?? false;
                              });
                            },
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Texto',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: interfaceAV,
                            onChanged: (bool? value) {
                              setState(() {
                                interfaceAV = value ?? false;
                              });
                            },
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Contenido Audiovisual',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Opciones de tipo de contraseña
                      Text(
                        'Selecciona el tipo de contraseña del estudiante',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'pictograms',
                            groupValue: passwordType,
                            onChanged: (String? value) {
                              setState(() {
                                passwordType = value!;
                              });
                            },
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Pictogramas',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'images',
                            groupValue: passwordType,
                            onChanged: (String? value) {
                              setState(() {
                                passwordType = value!;
                              });
                            },
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Imágenes',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'alphanumeric',
                            groupValue: passwordType,
                            onChanged: (String? value) {
                              setState(() {
                                passwordType = value!;
                              });
                            },
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Alfanumérica',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 14),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              if (passwordType == 'pictograms') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PictogramPasswordPage(
                                    userStudent: userController.text,
                                    nameStudent: nameController.text,
                                    surnameStudent: surnameController.text,
                                    interfacePIC: interfacePIC,
                                    interfaceIMG: interfaceIMG,
                                    interfaceTXT: interfaceTXT,
                                    interfaceAV: interfaceAV,
                                    perfilImage: image!,
                                    saveImage: saveImage,
                                    pickImage: pickImage,
                                  )),
                                );
                              } else if (passwordType == 'images') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ImagePasswordPage(
                                    userStudent: userController.text,
                                    nameStudent: nameController.text,
                                    surnameStudent: surnameController.text,
                                    interfacePIC: interfacePIC,
                                    interfaceIMG: interfaceIMG,
                                    interfaceTXT: interfaceTXT,
                                    interfaceAV: interfaceAV,
                                    perfilImage: image!,
                                    saveImage: saveImage,
                                    pickImage: pickImage,
                                  )),
                                );
                              } else if (passwordType == 'alphanumeric') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AlphanumericPasswordPage(
                                    userStudent: userController.text,
                                    nameStudent: nameController.text,
                                    surnameStudent: surnameController.text,
                                    interfacePIC: interfacePIC,
                                    interfaceIMG: interfaceIMG,
                                    interfaceTXT: interfaceTXT,
                                    interfaceAV: interfaceAV,
                                    perfilImage: image!,
                                    saveImage: saveImage,
                                  )),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue[200],
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                            ),
                            child: Text(
                              'Cambiar contraseña',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              // Botones de navegación
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () async {
                          String userStudent = userController.text;
                          String nameStudent = nameController.text;
                          String surnameStudent = surnameController.text;

                          if (!nameStudent.isEmpty) {
                            if (!interfaceAV && !interfaceIMG && !interfacePIC && !interfaceTXT) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Hay que seleccionar al menos un modo de visualización.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              if (image != null) {
                                await widget.saveImage(widget.image!, '$userStudent$extension', 'assets/perfiles');
                                // Lógica para guardar las modificaciones en la BD
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Cambios realizados con éxito.'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Inserta la imagen de perfil.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('El nombre no puede ser vacío.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                        ),
                        child: Text(
                          'Guardar',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange[400],
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                        ),
                        child: Text(
                          'Atrás',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página para la contraseña con pictogramas
class PictogramPasswordPage extends StatefulWidget {
  final String userStudent, nameStudent, surnameStudent;
  final bool interfacePIC, interfaceIMG, interfaceTXT, interfaceAV;
  final File? perfilImage;
  final Function(File, String, String) saveImage;
  final Function() pickImage;

  PictogramPasswordPage({
    required this.userStudent,
    required this.nameStudent,
    required this.surnameStudent,
    required this.interfacePIC,
    required this.interfaceIMG,
    required this.interfaceTXT,
    required this.interfaceAV,
    required this.perfilImage,
    required this.saveImage,
    required this.pickImage,
  });

  @override
  _PictogramPasswordPageState createState() => _PictogramPasswordPageState(
    userStudent: userStudent,
    nameStudent: nameStudent,
    surnameStudent: surnameStudent,
    interfacePIC: interfacePIC,
    interfaceIMG: interfaceIMG,
    interfaceTXT: interfaceTXT,
    interfaceAV: interfaceAV,
    perfilImage: perfilImage,
    saveImage: saveImage,
    pickImage: pickImage,
  );
}

class _PictogramPasswordPageState extends State<PictogramPasswordPage> {
  final String userStudent, nameStudent, surnameStudent;
  final bool interfacePIC, interfaceIMG, interfaceTXT, interfaceAV;
  final File? perfilImage;
  final Function(File, String, String) saveImage;
  final Function() pickImage;

  _PictogramPasswordPageState({
    required this.userStudent,
    required this.nameStudent,
    required this.surnameStudent,
    required this.interfacePIC,
    required this.interfaceIMG,
    required this.interfaceTXT,
    required this.interfaceAV,
    required this.perfilImage,
    required this.saveImage,
    required this.pickImage,
  });

  // Pictogramas opcionales para la contraseña
  List<ImgCode> selectedPictograms = [];
  // Pictogramas que componen la contraseña
  List<ImgCode> passwordPictograms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: Container(
          width: 740,
          height: 625,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 70.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Alta de $nameStudent',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                'Creación de contraseña de pictogramas',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              // Área para subir y seleccionar pictogramas
              Row(
                children: [
                  // Cuadro de subir imagen
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () async {
                        // Seleccionar una imagen
                        final pickedFile = await widget.pickImage();
                        if (pickedFile != null) {
                          // Obtener el nombre del archivo seleccionado
                          String fileName = pickedFile.uri.pathSegments.last;

                          // TOMATE quizá aquí sí es interesante que si ya hay una que se llame igual en picto_clave,
                          // añadirle algo al nombre para que no se sobreescriba en la carpeta,
                          // en la de perfiles no pq si se la cambia es mejor que se sobreescriba, solo hay una imagen de perfil

                          if(await pathExists(fileName, 'assets/picto_claves')){
                            String newName = await rewritePath('assets/picto_claves/$fileName');
                            fileName = newName.split("/").last;
                          }


                          // Guardar la imagen seleccionada en la galería de pictogramas para contraseñas
                          await widget.saveImage(pickedFile, fileName, 'assets/picto_claves');

                          await insertImgCode('assets/picto_claves/$fileName');
                        }
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.cloud_upload,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'Sube un pictograma',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Cuadro de selección de imágenes existentes
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        // Navegar a la página de selección de imágenes
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PictogramSelectionPage(
                              updateSelectedPictograms: (newPictograms) {
                                // Actualizar la lista de pictogramas seleccionados
                                passwordPictograms = [];
                                setState(() {
                                  selectedPictograms = newPictograms;
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.photo_library,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'Selecciona un pictograma existente',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Selecciona los pictogramas que formarán parte de la contraseña en el orden correcto:',
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Grid de pictogramas
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,  // Número de columnas en el grid
                    crossAxisSpacing: 10,  // Espacio entre las columnas
                    mainAxisSpacing: 10,   // Espacio entre las filas
                  ),
                  itemCount: selectedPictograms.length,
                  itemBuilder: (context, index) {
                    final pictogram = selectedPictograms[index];
                    bool isSelected = passwordPictograms.contains(pictogram); // Verificar si el pictograma está en la contraseña

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            passwordPictograms.remove(pictogram); // Si estaba, se elimina
                          } else {
                            passwordPictograms.add(pictogram); // Si no lo estaba, se añade
                          }
                        });
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey,
                              width: isSelected ? 3 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  pictogram.path,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if (isSelected) // Mostrar el índice del pictograma en la contraseña
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    color: Colors.blue.withOpacity(0.7),
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    child: Text(
                                      '${passwordPictograms.indexOf(pictogram) + 1}', // Mostrar el orden de la contraseña
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Obtener la extensión del archivo original
                          String extension = path.extension(widget.perfilImage!.path);
                          // Guardar la imagen de perfil en la carpeta
                          await widget.saveImage(widget.perfilImage!, '$userStudent$extension', 'assets/perfiles');

                          password = await imageCodeToPassword(passwordPictograms);
                          await registerStudent(userStudent, nameStudent, surnameStudent, password, perfilImage!.path, 
                            'pictograms', interfaceIMG ? 1:0, interfacePIC ? 1:0, interfaceTXT ? 1:0);
                          // TOMATE guardar al estudiante en la BD (la contraseña en los códigos de passwordPictograms)
                          // TOMATE guardar los pictogramas que deben salir para que introduzca su contraseña (en selectedPictograms)
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                        ),
                        child: Text(
                          'Guardar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange[400],
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                        ),
                        child: Text(
                          'Atrás',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página para la contraseña con imágenes
class ImagePasswordPage extends StatefulWidget {
  final String userStudent, nameStudent, surnameStudent;
  final bool interfacePIC, interfaceIMG, interfaceTXT, interfaceAV;
  final File? perfilImage;
  final Function(File, String, String) saveImage;
  final Function() pickImage;

  ImagePasswordPage({
    required this.userStudent,
    required this.nameStudent,
    required this.surnameStudent,
    required this.interfacePIC,
    required this.interfaceIMG,
    required this.interfaceTXT,
    required this.interfaceAV,
    required this.perfilImage,
    required this.saveImage,
    required this.pickImage,
  });

  @override
  _ImagePasswordPageState createState() => _ImagePasswordPageState(
    userStudent: userStudent,
    nameStudent: nameStudent,
    surnameStudent: surnameStudent,
    interfacePIC: interfacePIC,
    interfaceIMG: interfaceIMG,
    interfaceTXT: interfaceTXT,
    interfaceAV: interfaceAV,
    perfilImage: perfilImage,
    saveImage: saveImage,
    pickImage: pickImage,
  );
}

class _ImagePasswordPageState extends State<ImagePasswordPage> {
  final String userStudent, nameStudent, surnameStudent;
  final bool interfacePIC, interfaceIMG, interfaceTXT, interfaceAV;
  final File? perfilImage;
  final Function(File, String, String) saveImage;
  final Function() pickImage;

  _ImagePasswordPageState({
    required this.userStudent,
    required this.nameStudent,
    required this.surnameStudent,
    required this.interfacePIC,
    required this.interfaceIMG,
    required this.interfaceTXT,
    required this.interfaceAV,
    required this.perfilImage,
    required this.saveImage,
    required this.pickImage,
  });

  // Imágenes opcionales para la contraseña
  List<ImgCode> selectedImages = [];
  // Pictogramas que componen la contraseña
  List<ImgCode> passwordImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: Container(
          width: 740,
          height: 625,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 70.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Alta de $nameStudent',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                'Creación de contraseña de imágeness',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              // Área para subir y seleccionar imágenes
              Row(
                children: [
                  // Cuadro de subir imagen
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () async {
                        // Seleccionar una imagen
                        final pickedFile = await widget.pickImage();
                        if (pickedFile != null) {
                          // Obtener el nombre del archivo seleccionado
                          String fileName = pickedFile.uri.pathSegments.last;

                          // TOMATE quizá aquí sí es interesante que si ya hay una que se llame igual en imgs_clave,
                          // añadirle algo al nombre para que no se sobreescriba en la carpeta,
                          // en la de perfiles no pq si se la cambia es mejor que se sobreescriba, solo hay una imagen de perfil
                          if(await pathExists(fileName, 'assets/imgs_claves')){
                            String newName = await rewritePath('assets/imgs_claves/$fileName');
                            fileName = newName.split("/").last;
                          }

                          // Guardar la imagen seleccionada en la galería de imágenes para contraseñas
                          await widget.saveImage(pickedFile, fileName, 'assets/imgs_claves');
                          await insertImgCode('assets/imgs_claves/$fileName');
                        }
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.cloud_upload,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'Sube una imagen',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Cuadro de selección de imágenes existentes
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        // Navegar a la página de selección de imágenes
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageSelectionPage(
                              updateSelectedImages: (newImages) {
                                // Actualizar la lista de imágenes seleccionadas
                                passwordImages = [];
                                setState(() {
                                  selectedImages = newImages;
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.photo_library,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'Selecciona una imagen existente',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Selecciona las imágenes que formarán parte de la contraseña en el orden correcto:',
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Grid de imágenes
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,  // Número de columnas en el grid
                    crossAxisSpacing: 10,  // Espacio entre las columnas
                    mainAxisSpacing: 10,   // Espacio entre las filas
                  ),
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    final img = selectedImages[index];
                    bool isSelected = passwordImages.contains(img); // Verificar si la imagen está en la contraseña

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            passwordImages.remove(img); // Si estaba, se elimina
                          } else {
                            passwordImages.add(img); // Si no lo estaba, se añade
                          }
                        });
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey,
                              width: isSelected ? 3 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  img.path,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if (isSelected) // Mostrar el índice de la imagen en la contraseña
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    color: Colors.blue.withOpacity(0.7),
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    child: Text(
                                      '${passwordImages.indexOf(img) + 1}', // Mostrar el orden de la contraseña
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Obtener la extensión del archivo original
                          String extension = path.extension(widget.perfilImage!.path);
                          // Guardar la imagen de perfil en la carpeta
                          await widget.saveImage(widget.perfilImage!, '$userStudent$extension', 'assets/perfiles');

                          password = await imageCodeToPassword(passwordImages);
                          await registerStudent(userStudent, nameStudent, surnameStudent, password, perfilImage!.path, 
                            'images', interfaceIMG ? 1:0, interfacePIC ? 1:0, interfaceTXT ? 1:0);
                          // TOMATE guardar al estudiante en la BD (la contraseña en los códigos de passwordImages)
                          // TOMATE guardar los pictogramas que deben salir para que introduzca su contraseña (en selectedImages)
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                        ),
                        child: Text(
                          'Guardar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange[400],
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                        ),
                        child: Text(
                          'Atrás',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página para la contraseña alfanumérica
class AlphanumericPasswordPage extends StatelessWidget {
  final String userStudent, nameStudent, surnameStudent;
  final bool interfacePIC , interfaceIMG, interfaceTXT, interfaceAV;
  final File? perfilImage; 
  final Function(File, String, String) saveImage;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController samePasswordController = TextEditingController();

  AlphanumericPasswordPage({
    required this.userStudent,
    required this.nameStudent,
    required this.surnameStudent,
    required this.interfacePIC,
    required this.interfaceIMG,
    required this.interfaceTXT,
    required this.interfaceAV,
    required this.perfilImage,
    required this.saveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: Container(
          width: 740,
          height: 625,
          padding: EdgeInsets.all(70.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Alta de $nameStudent',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                'Creación de contraseña alfanumérica',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              Spacer(),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña*',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: samePasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Repetir contraseña*',
                  border: OutlineInputBorder(),
                ),
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 400,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!passwordController.text.isEmpty && !samePasswordController.text.isEmpty) {
                            if (passwordController.text == samePasswordController.text) {
                              await saveImage(perfilImage!, userStudent, 'assets/perfiles'); // Guardar la imagen de perfil en la carpeta
                              // TOMATE guardar al estudiante en la BD (contraseña en passwordController.text)
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Las contraseñas no coinciden.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Los campos no pueden ser vacíos.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                        ),
                        child: Text(
                          'Guardar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 400,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange[400],
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                        ),
                        child: Text(
                          'Atrás',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página para seleccionar un pictograma que formará parte de las posibilidades de contraseña del estudiante
class PictogramSelectionPage extends StatefulWidget {
  final Function(List<ImgCode>) updateSelectedPictograms;

  PictogramSelectionPage({
    required this.updateSelectedPictograms,
  });

  @override
  _PictogramSelectionPageState createState() => _PictogramSelectionPageState();
}

class _PictogramSelectionPageState extends State<PictogramSelectionPage> {
  // TOMATE
  // Recuperar la lista de pictogramas clave que ya se han subido anteriormente a la BD
  final List<ImgCode> pictograms = List.generate(
    10,
    (index) => ImgCode(
      path: 'assets/picto_claves/pictograma${index+1}.png',
      code: '$index',
    ),
  );

  // Lista para seleccionar pictogramas
  final List<ImgCode> selectionPictograms = [];

  void toggleSelection(ImgCode pictogram) {
    setState(() {
      if (selectionPictograms.contains(pictogram)) {
        selectionPictograms.remove(pictogram);
      } else {
        if (selectionPictograms.length < 6) {
          selectionPictograms.add(pictogram);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Máximo de 6 pictogramas seleccionados")),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: Container(
          width: 740,
          height: 625,
          padding: EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Galería de Pictogramas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: pictograms.map((pictogram) {
                    final isSelected = selectionPictograms.contains(pictogram);
                    return GestureDetector(
                      onTap: () => toggleSelection(pictogram),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey,
                              width: isSelected ? 3 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  pictogram.path,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if (isSelected)
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.blue,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              // Botón Guardar
              SizedBox(
                width: 400,
                child: ElevatedButton(
                  onPressed: () {
                    widget.updateSelectedPictograms(selectionPictograms);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                  ),
                  child: Text(
                    'Guardar selección',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Botón Atrás
              SizedBox(
                width: 400,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange[400],
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                  ),
                  child: Text(
                    'Atrás',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página para seleccionar una iagen que formará parte de las posibilidades de contraseña del estudiante
class ImageSelectionPage extends StatefulWidget {
  final Function(List<ImgCode>) updateSelectedImages;

  ImageSelectionPage({
    required this.updateSelectedImages,
  });

  @override
  _ImageSelectionPageState createState() => _ImageSelectionPageState();
}

class _ImageSelectionPageState extends State<ImageSelectionPage> {
  // TOMATE
  // Recuperar la lista de imágenes clave que ya se han subido anteriormente a la BD
  final List<ImgCode> images = List.generate(
    8,
    (index) => ImgCode(
      path: 'assets/imgs_claves/imagen${index+1}.png',
      code: '$index',
    ),
  );

  // Lista para seleccionar imágenes
  final List<ImgCode> selectionImages = [];

  void toggleSelection(ImgCode img) {
    setState(() {
      if (selectionImages.contains(img)) {
        selectionImages.remove(img);
      } else {
        if (selectionImages.length < 6) {
          selectionImages.add(img);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Máximo de 6 imágenes seleccionadas")),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: Container(
          width: 740,
          height: 625,
          padding: EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Galería de Imágenes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: images.map((img) {
                    final isSelected = selectionImages.contains(img);
                    return GestureDetector(
                      onTap: () => toggleSelection(img),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey,
                              width: isSelected ? 3 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  img.path,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if (isSelected)
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.blue,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              // Botón Guardar
              SizedBox(
                width: 400,
                child: ElevatedButton(
                  onPressed: () {
                    widget.updateSelectedImages(selectionImages);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                  ),
                  child: Text(
                    'Guardar selección',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Botón Atrás
              SizedBox(
                width: 400,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange[400],
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                  ),
                  child: Text(
                    'Atrás',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}