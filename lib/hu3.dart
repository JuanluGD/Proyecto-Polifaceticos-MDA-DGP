import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'Student.dart';

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
  final List<Student> students = List.generate(20, (index) => Student(name: 'Estudiante $index', lastName1: 'Apellido1 $index', lastName2: 'Apellido2 $index', DNI: '${10000000 + index}', password: '', photo: 'assets/perfiles/imagen_guardada.jpg', typePassword: 'alphanumeric', interfaceIMG: false, interfacePIC: false, interfaceTXT: false));

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
                        title: Text('${student.name} ${student.lastName1} ${student.lastName2}'),
                        subtitle: Text('DNI: ${student.DNI}'),
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
  final Student student; // Recibimos el estudiante seleccionado

  StudentModificationPage({required this.student});

  @override
  _StudentModificationPageState createState() =>
      _StudentModificationPageState();
}

class _StudentModificationPageState extends State<StudentModificationPage> {
  // Valores iniciales según los que tuviese el estudiante
  bool pictogramsView = false;
  bool imagesView = false;
  bool textView = false;
  bool audiovisualContentView = false;

  late String passwordType; // Valor anterior para la selección de contraseña

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

  // Controladores para los campos de texto
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surname1Controller = TextEditingController();
  final TextEditingController surname2Controller = TextEditingController();
  final TextEditingController dniController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializar los campos con los datos del estudiante
    nameController.text = widget.student.name;
    surname1Controller.text = widget.student.lastName1;
    surname2Controller.text = widget.student.lastName2;
    dniController.text = widget.student.DNI;
    passwordType = widget.student.typePassword;
    image = File(widget.student.photo!);
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
                'Modificación de estudiante',
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
                        SizedBox(height: 30),
                        Text(
                          'DNI del estudiante: ${widget.student.DNI}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
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
                            value: pictogramsView,
                            onChanged: (bool? value) {
                              setState(() {
                                pictogramsView = value ?? false;
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
                            value: imagesView,
                            onChanged: (bool? value) {
                              setState(() {
                                imagesView = value ?? false;
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
                            value: textView,
                            onChanged: (bool? value) {
                              setState(() {
                                textView = value ?? false;
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
                            value: audiovisualContentView,
                            onChanged: (bool? value) {
                              setState(() {
                                audiovisualContentView = value ?? false;
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
                                  MaterialPageRoute(builder: (context) => PictogramPasswordPage()),
                                );
                              } else if (passwordType == 'images') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ImagePasswordPage()),
                                );
                              } else if (passwordType == 'alphanumeric') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AlphanumericPasswordPage()),
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
                          String dniStudent = dniController.text;
                          String nameStudent = nameController.text;
                          String surname1Student = surname1Controller.text;
                          String surname2Student = surname1Controller.text;

                          if (!nameStudent.isEmpty && !surname1Student.isEmpty && !surname2Student.isEmpty) {
                            if (!audiovisualContentView && !imagesView && !pictogramsView && !textView) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Hay que seleccionar al menos un modo de visualización.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              if (image != null) {
                                saveImage(image!, dniStudent);
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
class PictogramPasswordPage extends StatelessWidget {
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
                'Modificación de estudiante',
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
                        onPressed: () {
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
                'Modificación de estudiante',
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
                        onPressed: () {
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
                        onPressed: () {
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
