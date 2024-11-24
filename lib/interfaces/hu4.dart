import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:proyecto/interfaces/interface_utils.dart';
import 'package:proyecto/image_utils.dart';
import 'package:proyecto/bd_utils.dart';

import 'package:proyecto/classes/ImgCode.dart';
import 'package:proyecto/classes/Student.dart';

import 'package:proyecto/interfaces/hu2.dart' as hu2;

/// MODIFICAR ESTUDIANTE Y TIPO DE INTERFAZ ///
/// HU4: Como administrador quiero poder elegir qué tipo de interfaz se le va a mostrar a cada estudiante.
/// HU5: Como administrador quiero poder modificar el perfil del estudiante.

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Estudiantes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: StudentListPage(),
    );
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ DE LISTA DE ESTUDIANTES
// //////////////////////////////////////////////////////////////////////////////////////////

class StudentListPage extends StatefulWidget {
  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final List<Student> students = [];
  // TOMATE
  // Para cargar los estudiantes
  Future<void> _loadStudents() async {
    if (students.isEmpty) {
      setState(() {});
      students.addAll(await getAllStudents());
      setState(() {});
    }
  }
  Future<void> deleteStudentInterface(String user) async {
    Student? student = await getStudent(user);
    if (student != null) {
      //await deleteImage(student.image);
      await deleteStudent(user);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: buildMainContainer(740, 625, EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0), 
          buildCustomList(items: students, title: "Lista de estudiantes", addButton: true, nextPage: hu2.StudentRegistrationPage(), context: context, circle: true, fit: BoxFit.cover, buildChildren: (context, item, index) { 
            return [
              IconButton(
              icon: Icon(Icons.info_outline),
              color: Colors.blue,
              onPressed:
                // Navegar a la página de información del estudiante
                () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentInfoPage(student: item),
                    ),
                  );
                  setState(() {});
                },
              ),
              IconButton(
                icon: Icon(Icons.task),
                color: Colors.blue,
                onPressed:
                  // Navegar a la página de tareas del estudiante
                  () async {
                    print("no esta implementado jaja"); // TOMATE
                    setState(() {});
                  },
              ),
              IconButton(
                icon: Icon(Icons.edit),
                color: Colors.blue,
                onPressed:
                  // Navegar a la página de modificación del estudiante
                  () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentModificationPage(student: item),
                      ),
                    );
                    setState(() {});
                  },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.blue,
                onPressed:
                  () async {
                    await deleteStudentInterface(item.user);
                
                    setState((){
                      students.removeAt(index);
                    });
                  },
                ),
              ];
            }
          ), 
        )  
      ),
    );
  }
}


// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ DE INFORMACIÓN DE ESTUDIANTE
// //////////////////////////////////////////////////////////////////////////////////////////

class StudentInfoPage extends StatefulWidget {
  final Student student;

  StudentInfoPage({required this.student});

  @override
  _StudentInfoPageState createState() => _StudentInfoPageState();
}

class _StudentInfoPageState extends State<StudentInfoPage> {
  late String passwordType;

  @override
  void initState(){
    super.initState();
    if (widget.student.typePassword == 'pictograms') passwordType = 'Pictogramas';
    else if (widget.student.typePassword == 'images') passwordType = 'Imágenes';
    else if (widget.student.typePassword == 'alphanumeric') passwordType = 'Alfanumérica';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: buildMainContainer(740, 625, EdgeInsets.symmetric(vertical: 20.0, horizontal: 100.0), 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Center(
                child: Text(
                  'Configuración de ${widget.student.name}',
                  style: titleTextStyle,
                ),
              ),
              Center(
                child: Text(
                  'Ver la información de los datos del estudiante',
                  style: subtitleTextStyle,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 30),
                  // Foto del estudiante
                  Container(
                    width: 220,
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.student.image),
                        fit: BoxFit.contain,
                      ),
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre y Apellidos
                      Text(
                        '${widget.student.name} ${widget.student.surname ?? ''}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      // Opciones de interfaz
                      Row(
                        children: [
                          SizedBox(width: 15),
                          Checkbox(
                            value: widget.student.interfacePIC == 1, 
                            onChanged: null,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Pictogramas',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(width: 15),
                          Checkbox(
                            value: widget.student.interfaceIMG == 1, 
                            onChanged: null,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Imágenes',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(width: 15),
                          Checkbox(
                            value: widget.student.interfaceTXT == 1, 
                            onChanged: null,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Texto',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(width: 15),
                          Checkbox(
                            value: false, 
                            onChanged: null,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Contenido Audiovisual',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Contraseña y tipo
              Row(
                children: [
                  Text('Contraseña: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(passwordType),
                ],
              ),
              SizedBox(height: 20),
              // Espacio reservado para ver la contraseña
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.grey.shade300,
                child: Center(
                  child: Text(
                    '<espacio reservado para posteriormente implementar que se muestre la contraseña>',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 200,
                  child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () {
                    setState(() {}); Navigator.pop(context); setState(() {});
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ DE MODIFICACIÓN DE ESTUDIANTE
// //////////////////////////////////////////////////////////////////////////////////////////

class StudentModificationPage extends StatefulWidget {
  final Student student; // Recibir el estudiante seleccionado

  StudentModificationPage({required this.student});

  @override
  _StudentModificationPageState createState() =>
      _StudentModificationPageState();
}

class _StudentModificationPageState extends State<StudentModificationPage> {

  late bool interfacePIC, interfaceIMG, interfaceTXT, interfaceAV;
  late String passwordType;

  // Para almacenar la imagen que se suba
  File? image;

  // Controladores para los campos de texto
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializar los campos con los datos del estudiante
    nameController.text = widget.student.name;
    surnameController.text = widget.student.surname!;
    passwordType = widget.student.typePassword;
    image = File(widget.student.image);
    interfacePIC = widget.student.interfacePIC == 1;
    interfaceIMG = widget.student.interfaceIMG == 1;
    interfaceTXT = widget.student.interfaceTXT == 1;
    interfaceAV = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: buildMainContainer(740, 650, EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0), 
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Modificación de ${widget.student.name}',
                style: titleTextStyle,
              ),
              Text(
                'Modifica los datos del estudiante',
                style: subtitleTextStyle,
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
                        buildTextField('Nombre', nameController),
                        SizedBox(height: 10),
                        buildTextField('Apellidos', surnameController),
                        SizedBox(height: 20),
                        Text(
                          'Usuario: ${widget.student.user}',
                          style: infoTextStyle,
                        ),
                        SizedBox(height: 20),
                        // Imagen de perfil
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Imagen de perfil',
                              style: hintTextStyle,
                            ),
                            SizedBox(height: 10),
                            buildPickerRegion(pickImage, buildPickerContainer(150, Icons.cloud_upload, 'Sube una imagen', BoxFit.contain, image)),
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
                        style: hintTextStyle,
                      ),
                      SizedBox(height: 8),
                      buildSizedCheckbox('Pictogramas', 8, interfacePIC, false, (bool value) {
                        setState(() {
                          interfacePIC = value;
                        });
                      }),
                      SizedBox(height: 8),
                      buildSizedCheckbox('Imágenes', 8, interfaceIMG, false, (bool value) {
                        setState(() {
                          interfaceIMG = value;
                        });
                      }),
                      SizedBox(height: 8),
                      buildSizedCheckbox('Texto', 8, interfaceTXT, false, (bool value) {
                        setState(() {
                          interfaceTXT = value;
                        });
                      }),
                      SizedBox(height: 8),
                      buildSizedCheckbox('Contenido Audiovisual', 8, interfaceAV, false, (bool value) {
                        setState(() {
                          interfaceAV = value;
                        });
                      }),
                      SizedBox(height: 20),
                      // Opciones de tipo de contraseña
                      Text(
                        'Selecciona el tipo de contraseña del estudiante',
                        style: hintTextStyle,
                      ),
                      SizedBox(height: 8),
                      buildSizedRadio('Pictogramas', 8, 'pictograms', passwordType, 'alphanumeric', (String value) {
                        setState(() {
                          passwordType = value;
                        });
                      }),
                      SizedBox(height: 8),
                      buildSizedRadio('Imágenes', 8, 'images', passwordType, 'alphanumeric', (String value) {
                        setState(() {
                          passwordType = value;
                        });
                      }),
                      SizedBox(height: 8),
                      buildSizedRadio('Alfanumérica', 8, 'alphanumeric', passwordType, 'alphanumeric', (String value) {
                        setState(() {
                          passwordType = value;
                        });
                      }),
                      SizedBox(height: 14),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 200,
                          child: buildElevatedButton('Cambiar contraseña', buttonTextStyle, extraButtonStyle, () async {
                            List<ImgCode> selectionElements = await getStudentMenuPassword(widget.student.user);
                            if (passwordType == 'pictograms' || passwordType == 'images') {
                              setState(() {});
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ImgCodePasswordPage(
                                  student: widget.student,
                                  passwordType: passwordType,
                                  selectionElements: selectionElements,
                                )),
                              );
                            } else if (passwordType == 'alphanumeric') {
                              setState(() {});
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AlphanumericPasswordPage(
                                  student: widget.student,
                                )),
                              );
                            }
                            setState(() {});
                          }),
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
                      child: buildElevatedButton('Guardar', buttonTextStyle, nextButtonStyle, () async {
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
                              // Obtener la extensión del archivo original
                              String extension = path.extension(image!.path);
                              // Guardar la imagen de perfil en la carpeta
                              await saveImage(image!, '${widget.student.user}$extension', 'assets/perfiles');
                              
                              // TOMATE
                              modifyCompleteStudent(widget.student.user, nameStudent, surnameStudent, widget.student.password, widget.student.image, widget.student.typePassword, interfaceIMG ? 1:0, interfacePIC ? 1:0, interfaceTXT ? 1:0);

                              // Actualizar los valores de la interfaz
                              widget.student.name = nameStudent;
                              widget.student.surname = surnameStudent;
                              widget.student.interfaceIMG = interfaceIMG ? 1 : 0;
                              widget.student.interfacePIC = interfacePIC ? 1 : 0;
                              widget.student.interfaceTXT = interfaceTXT ? 1 : 0;
                              widget.student.image = 'assets/perfiles/${widget.student.user}$extension';

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
                        setState(() {});
                      }),
                    ),
                  ),
                  SizedBox(width: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () {
                        setState(() {}); Navigator.pop(context); setState(() {});
                      }),
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

// //////////////////////////////////////////////////////////////////////////////////////////
// PÁGINA DE CONTRASEÑA DE PICTOGRAMAS O IMÁGENES
// //////////////////////////////////////////////////////////////////////////////////////////

class ImgCodePasswordPage extends StatefulWidget {
  Student student;
  final String passwordType;
  List<ImgCode> selectionElements;

  ImgCodePasswordPage({
    required this.student,
    required this.passwordType,
    required this.selectionElements,
  });

  @override
  _ImgCodePasswordPageState createState() => _ImgCodePasswordPageState();
}

class _ImgCodePasswordPageState extends State<ImgCodePasswordPage> {
  // Pictogramas o imágenes opcionales para la contraseña
  List<ImgCode> selectedElements = [];
  // Pictogramas o imágenes que componen la contraseña
  List<ImgCode> passwordElements = [];

  // TOMATE
  // Si la contraseña del estudiante era del mismo tipo que la nueva, cargarla de la BD
  Future<void> loadPassword() async {
    if (widget.student.typePassword == widget.passwordType) {
      selectedElements = await getStudentMenuPassword(widget.student.user);
      passwordElements = await passwordToImageCode(widget.student.password);

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadPassword();
  }

  @override
  Widget build(BuildContext context) {
    String hintUpload = '', pluralWord = '';
    if (widget.passwordType == 'pictograms') {
      hintUpload = 'Sube un pictograma';
      pluralWord = 'pictogramas';
    }
    else if (widget.passwordType == 'images') {
      hintUpload = 'Sube una imagen';
      pluralWord = 'imágenes';
    }

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: buildMainContainer(740, 625, EdgeInsets.symmetric(vertical: 20.0, horizontal: 70.0),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Modificación de ${widget.student.name}', style: titleTextStyle),
              Text(
                'Creación de contraseña de $pluralWord',
                style: subtitleTextStyle,
              ),
              SizedBox(height: 20),
              // Área para subir y seleccionar pictogramas o imágenes
              Row(
                children: [
                  // Cuadro de subir pictograma o imagen
                  Expanded(
                    flex: 1,
                    child: buildPickerRegion(
                        () async {
                          // Seleccionar una imagen
                          final pickedFile = await pickImage();
                          if (pickedFile != null) {
                            // Obtener el nombre del archivo seleccionado
                            String fileName = pickedFile.uri.pathSegments.last;
                            String folder = '';

                            if (widget.passwordType == 'pictograms') folder = 'picto_claves';
                            else if (widget.passwordType == 'images') folder = 'imgs_claves';

                            String newName = '';

                            // TOMATE
                            // Guardar en carpeta según sea pictograma o imagen
                            // Si ya existe alguna imagen que se llame así, renombrarla
                            if(await pathExists(fileName, 'assets/$folder')) {
                              newName = await rewritePath('assets/$folder/$fileName');
                              fileName = newName.split("/").last;
                            }

                            // Quitar los espacios del nombre del archivo
                            newName = removeSpacing(fileName.split("/").last);
                            fileName = newName;

                            // Meter la tupla en la BD
                            await insertImgCode('assets/$folder/$fileName');
                            // Guardar en la carpeta
                            await saveImage(pickedFile, fileName, 'assets/$folder');
                          }
                        },
                        buildPickerContainer(100, Icons.cloud_upload, hintUpload, BoxFit.cover, null)
                      ),
                  ),
                  SizedBox(width: 10),
                  // Cuadro de selección de pictogramas o imágenes existentes
                  Expanded(
                    flex: 1,
                    child: buildPickerRegion(
                        () {
                          // Navegar a la página de selección de pictogramas o imágenes
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImgCodeSelectionPage(
                                updateSelectedElements: (newElements) {
                                  // Actualizar la lista de pictogramas o imágenes seleccionados
                                  passwordElements = [];
                                  setState(() {
                                    selectedElements = newElements;
                                    widget.selectionElements = newElements;
                                  });
                                },
                                passwordType: widget.passwordType,
                                user: widget.student.user,
                                selectionElements : widget.selectionElements,
                              ),
                            ),
                          );
                        },
                        buildPickerContainer(100, Icons.photo_library, 'Seleccionar $pluralWord existentes', BoxFit.cover, null)
                      ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Selecciona $pluralWord que formarán parte de la contraseña en el orden correcto:',
                style: hintTextStyle,
              ),
              SizedBox(height: 20),
              // Grid de pictogramas o imágenes
              Expanded(
                child: buildIndexGrid(3, 10, selectedElements, passwordElements, (ImgCode element) {
                    setState(() {
                    if (passwordElements.contains(element)) {
                      passwordElements.remove(element); // Si ya estaba, lo elimina
                    } else {
                      passwordElements.add(element); // Si no estaba, lo añade
                    }
                  });
                }),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: buildElevatedButton('Guardar', buttonTextStyle, nextButtonStyle, () async { // TOMATE
                          // Crear la contraseña del estudiante según los pictogramas o imágenes seleccionados para contraseña
                          String password = await imageCodeToPassword(passwordElements);

                          if (
                            // Asignarle la nueva contraseña al estudiante
                            await modifyPasswordStudent(widget.student.user, password) &&

                            // Asignarle el nuevo tipo al estudiante
                            await modifyTypePasswordStudent(widget.student.user, widget.passwordType)
                          ) {
                            // Eliminar los elementos anteriores asociados al estudiante
                            deleteStudentImgCodePassword(widget.student.user);

                            // Guardar los elementos que deben salir al estudiante para introducir su contraseña
                            await createStudentImgCodePassword(widget.student.user, selectedElements);

                            // Actualizar el tipo de contraseña en la interfaz
                            widget.student.typePassword = widget.passwordType;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Contraseña cambiada con éxito.'),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Recargar al estudiante
                            widget.student = (await getStudent(widget.student.user))!;

                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al cambiar la contraseña.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }

                          setState(() {});
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentModificationPage(student: widget.student),
                            ),
                          );
                          setState(() {});
                        }
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () {
                          setState(() {}); Navigator.pop(context); setState(() {});
                        }
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ DE SELECCION PICTOGRAMAS O IMÁGENES
// //////////////////////////////////////////////////////////////////////////////////////////

class ImgCodeSelectionPage extends StatefulWidget {
  final Function(List<ImgCode>) updateSelectedElements;
  final String passwordType, user;
  // Lista para seleccionar pictogramas o imágenes
  List<ImgCode> selectionElements;

  ImgCodeSelectionPage({
    required this.updateSelectedElements,
    required this.passwordType,
    required this.user,
    required this.selectionElements,
  });

  @override
  _ImgCodeSelectionPageState createState() => _ImgCodeSelectionPageState();
}

class _ImgCodeSelectionPageState extends State<ImgCodeSelectionPage> {
  final List<ImgCode> elements = [];
  String gallery = '';

  // TOMATE
  // Para cargar los elementos
  Future<void> loadGallery() async {
    if (elements.isEmpty) {
      setState(() {});
      if (widget.passwordType == "pictograms") {
        elements.addAll(await getImgCodeFromFolder('assets/picto_claves'));
        gallery = 'Pictogramas';
      } else if (widget.passwordType == "images") {
        elements.addAll(await getImgCodeFromFolder('assets/imgs_claves'));
        gallery = 'Imágenes';
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadGallery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: buildMainContainer(740, 625, EdgeInsets.all(30.0), 
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Galería de $gallery',
                style: titleTextStyle
              ),
              SizedBox(height: 20),
              Expanded(
                child: buildTickGrid(4, 8, elements, widget.selectionElements, 6, context),
              ),
              SizedBox(height: 20),
              // Botón Guardar
              SizedBox(
                width: 400,
                child: buildElevatedButton('Guardar selección', buttonTextStyle, nextButtonStyle, () {
                    widget.updateSelectedElements(widget.selectionElements);
                    Navigator.pop(context);
                  }
                ),
              ),
              SizedBox(height: 20),
              // Botón Atrás
              SizedBox(
                width: 400,
                child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () {
                    setState(() {}); Navigator.pop(context); setState(() {});
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ DE CONTRASEÑA ALFANUMÉRICA
// //////////////////////////////////////////////////////////////////////////////////////////

class AlphanumericPasswordPage extends StatefulWidget {
  final Student student;

  AlphanumericPasswordPage({
    required this.student,
  });

  @override
  _AlphanumericPasswordPageState createState() => _AlphanumericPasswordPageState();
}

class _AlphanumericPasswordPageState extends State<AlphanumericPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController samePasswordController = TextEditingController();
  bool obscurePass = true, obscureSamePass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: buildMainContainer(740, 625, EdgeInsets.all(70.0),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Modificación de ${widget.student.name}',
                style: titleTextStyle,
              ),
              Text(
                'Creación de contraseña alfanumérica',
                style: subtitleTextStyle,
              ),
              SizedBox(height: 20),
              Spacer(),
              buildPasswdTextField('Contraseña*', passwordController, obscurePass, () {
                setState(() {
                  obscurePass = !obscurePass;
                }); 
              }),
              SizedBox(height: 10),
              buildPasswdTextField('Repetir contraseña*', samePasswordController, obscureSamePass, () {
                setState(() {
                  obscureSamePass = !obscureSamePass;
                }); 
              }),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 400,
                      child: buildElevatedButton('Guardar', buttonTextStyle, nextButtonStyle, () async {
                          if (!passwordController.text.isEmpty && !samePasswordController.text.isEmpty) {
                            if (passwordController.text == samePasswordController.text) {
                              // TOMATE
                              // Cambiar la contraseña del estudiante
                              if (await modifyPasswordStudent(widget.student.user, passwordController.text)) {
                                // Eliminar los elementos anteriores asociados al estudiante
                                deleteStudentImgCodePassword(widget.student.user);

                                // Actualizar el tipo de contraseña del estudiante
                                modifyTypePasswordStudent(widget.student.user, 'alphanumeric');

                                // Actualizar el tipo de contraseña en la interfaz
                                widget.student.typePassword = 'alphanumeric';

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Contraseña modificada con éxito.'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error al cambiar la contraseña.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
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
                        }
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 400,
                      child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () {
                          Navigator.pop(context);
                        }
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