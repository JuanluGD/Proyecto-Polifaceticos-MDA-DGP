import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alta de Estudiante',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StudentRegistrationPage(),
    );
  }
}

class StudentRegistrationPage extends StatefulWidget {
  @override
  _StudentRegistrationPageState createState() =>
      _StudentRegistrationPageState();
}

class _StudentRegistrationPageState extends State<StudentRegistrationPage> {
  bool pictogramsView = false;
  bool imagesView = false;
  bool textView = false;
  bool audiovisualContentView = false;

  String passwordType = "alphanumeric"; // Valor inicial para la selección de contraseña

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
  Future<void> saveImage(File image, String imgName) async {
    try {
      final directory = Directory('assets/perfiles');
      
      // Crea la carpeta si no existe
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final fileName = '$imgName.jpg';
      final String newPath = path.join(directory.path, fileName);

      // Copia la imagen a la ruta relativa
      final File localImage = await image.copy(newPath);
      print('Imagen guardada en: ${localImage.path}');
      
    } catch (e) {
      print("Error al guardar la imagen: $e");
    }
  }

  // CONTROLADORES PARA TRABAJAR CON LOS CAMPOS
  final TextEditingController dniController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surname1Controller = TextEditingController();
  final TextEditingController surname2Controller = TextEditingController();

  // FUNCIONES PARA COMPROBAR LA VALIDEZ DE LOS CAMPOS

  bool dniIsValid(String dni) {
    bool isValid = true;

    if (dni.length != 9) {
      isValid = false;
    } else if (!RegExp(r'^[A-Za-z]$').hasMatch(dni[8])) {
      isValid = false;
    } else {
      for (int i = 0; i < 8 && isValid; i++) {
        if (!RegExp(r'^[0-9]$').hasMatch(dni[i])) {
          isValid = false;
        }
      }
    }
    
    return isValid;
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
                'Alta de estudiante',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                'Ingresa los datos del estudiante',
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
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: surname1Controller,
                                decoration: InputDecoration(
                                  labelText: '1er Apellido',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: surname2Controller,
                                decoration: InputDecoration(
                                  labelText: '2o Apellido',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: dniController,
                          decoration: InputDecoration(
                            labelText: 'DNI',
                            border: OutlineInputBorder(),
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
                                            fit: BoxFit.cover,
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
                        CheckboxListTile(
                          title: Text('Pictogramas'),
                          value: pictogramsView,
                          onChanged: (bool? value) {
                            setState(() {
                              pictogramsView = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Imágenes'),
                          value: imagesView,
                          onChanged: (bool? value) {
                            setState(() {
                              imagesView = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Texto'),
                          value: textView,
                          onChanged: (bool? value) {
                            setState(() {
                              textView = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Contenido Audiovisual'),
                          value: audiovisualContentView,
                          onChanged: (bool? value) {
                            setState(() {
                              audiovisualContentView = value ?? false;
                            });
                          },
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
                        RadioListTile(
                          title: Text('Pictogramas'),
                          value: 'pictograms',
                          groupValue: passwordType,
                          onChanged: (String? value) {
                            setState(() {
                              passwordType = value!;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('Imágenes'),
                          value: 'images',
                          groupValue: passwordType,
                          onChanged: (String? value) {
                            setState(() {
                              passwordType = value!;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('Alfanumérica'),
                          value: 'alphanumeric',
                          groupValue: passwordType,
                          onChanged: (String? value) {
                            setState(() {
                              passwordType = value!;
                            });
                          },
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
                          String dniStudent = dniController.text;
                          String nameStudent = nameController.text;
                          String surname1Student = surname1Controller.text;
                          String surname2Student = surname1Controller.text;
                          if (!nameStudent.isEmpty && !surname1Student.isEmpty && !surname2Student.isEmpty) {
                            if (!dniIsValid(dniStudent)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('El formato del DNI es inválido o el DNI ya está registrado.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              if (!audiovisualContentView && !imagesView && !pictogramsView && !textView) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Hay que seleccionar al menos un modo de visualización.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                if (image != null) {
                                  if (passwordType == 'pictograms') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PictogramPasswordPage(
                                          dniStudent: dniStudent,
                                          nameStudent: nameStudent,
                                          surname1Student: surname1Student,
                                          surname2Student: surname2Student,
                                          pictogramsView: pictogramsView,
                                          imagesView: imagesView,
                                          textView: textView,
                                          audiovisualContentView: audiovisualContentView,
                                          image: image!,
                                          saveImage: saveImage,
                                        ),
                                      ),
                                    );
                                  } else if (passwordType == 'images') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ImagePasswordPage(
                                          dniStudent: dniStudent,
                                          nameStudent: nameStudent,
                                          surname1Student: surname1Student,
                                          surname2Student: surname2Student,
                                          pictogramsView: pictogramsView,
                                          imagesView: imagesView,
                                          textView: textView,
                                          audiovisualContentView: audiovisualContentView,
                                          image: image!,
                                          saveImage: saveImage,
                                        )
                                      ),
                                    );
                                  } else if (passwordType == 'alphanumeric') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AlphanumericPasswordPage(
                                          dniStudent: dniStudent,
                                          nameStudent: nameStudent,
                                          surname1Student: surname1Student,
                                          surname2Student: surname2Student,
                                          pictogramsView: pictogramsView,
                                          imagesView: imagesView,
                                          textView: textView,
                                          audiovisualContentView: audiovisualContentView,
                                          image: image!,
                                          saveImage: saveImage,
                                        )
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Inserta la imagen de perfil.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('El nombre y los apellidos no pueden ser vacíos.'),
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
                          'Siguiente',
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

// Página para la contraseña con pictogramas
class PictogramPasswordPage extends StatelessWidget {
  final String dniStudent, nameStudent, surname1Student, surname2Student;
  final bool pictogramsView , imagesView, textView, audiovisualContentView;
  final File? image; 
  final Function(File, String) saveImage;

  PictogramPasswordPage({
    required this.dniStudent,
    required this.nameStudent,
    required this.surname1Student,
    required this.surname2Student,
    required this.pictogramsView,
    required this.imagesView,
    required this.textView,
    required this.audiovisualContentView,
    required this.image,
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
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 70.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Alta de estudiante',
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
              Container(
                height: 100,
                width: double.infinity,
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
                        'Sube los pictogramas',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Selecciona los pictogramas que formarán parte de la contraseña en el orden correcto:',
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              // Grid de pictogramas
              SizedBox(
                height: 275, // Altura total
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: List.generate(6, (index) {
                    return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          'URL_DE_EJEMPLO_PICTOGRAMA',
                          fit: BoxFit.cover,
                        ),
                      );
                  }),
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
                          await saveImage(image!, dniStudent); // Lógica para guardar la imagen de perfil en la carpeta
                          // Lógica para guardar la imagen de perfil en la BD
                          // Lógica para guardar al estudiante en la BD
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
class ImagePasswordPage extends StatelessWidget {
  final String dniStudent, nameStudent, surname1Student, surname2Student;
  final bool pictogramsView , imagesView, textView, audiovisualContentView;
  final File? image; 
  final Function(File, String) saveImage;

  ImagePasswordPage({
    required this.dniStudent,
    required this.nameStudent,
    required this.surname1Student,
    required this.surname2Student,
    required this.pictogramsView,
    required this.imagesView,
    required this.textView,
    required this.audiovisualContentView,
    required this.image,
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
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 70.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Alta de estudiante',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                'Creación de contraseña de imágenes',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              // Área para subir y seleccionar imágenes
              Container(
                height: 100,
                width: double.infinity,
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
                        'Sube las imágenes',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Selecciona las imágenes que formarán parte de la contraseña en el orden correcto:',
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              // Grid de imágenes
              SizedBox(
                height: 275, // Altura total
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: List.generate(6, (index) {
                    return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          'URL_DE_EJEMPLO_IMAGEN',
                          fit: BoxFit.cover,
                        ),
                      );
                  }),
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
                          await saveImage(image!, dniStudent); // Lógica para guardar la imagen de perfil en la carpeta
                          // Lógica para guardar la imagen de perfil en la BD
                          // Lógica para guardar al estudiante en la BD
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
  final String dniStudent, nameStudent, surname1Student, surname2Student;
  final bool pictogramsView , imagesView, textView, audiovisualContentView;
  final File? image; 
  final Function(File, String) saveImage;

  AlphanumericPasswordPage({
    required this.dniStudent,
    required this.nameStudent,
    required this.surname1Student,
    required this.surname2Student,
    required this.pictogramsView,
    required this.imagesView,
    required this.textView,
    required this.audiovisualContentView,
    required this.image,
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
                'Alta de estudiante',
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
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Repetir contraseña',
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
                          await saveImage(image!, dniStudent); // Lógica para guardar la imagen de perfil en la carpeta
                          // Lógica para guardar la imagen de perfil en la BD
                          // Lógica para guardar al estudiante en la BD
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