import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:proyecto/interfaces/interface_utils.dart';
import 'package:proyecto/image_utils.dart';
import 'package:proyecto/bd_utils.dart';

import 'package:proyecto/classes/ImgCode.dart';

import 'package:proyecto/interfaces/hu4.dart' as hu4;

///  DAR DE ALTA A UN ESTUDIANTE  ///
/// HU2 Como administrador quiero poder dar de alta a un estudiante

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

// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ DE REGISTRAR ALUMNO
// //////////////////////////////////////////////////////////////////////////////////////////

class StudentRegistrationPage extends StatefulWidget {
  const StudentRegistrationPage({super.key});

  @override
  _StudentRegistrationPageState createState() =>
      _StudentRegistrationPageState();
}

class _StudentRegistrationPageState extends State<StudentRegistrationPage> {
  bool interfacePIC = false;
  bool interfaceIMG = false;
  bool interfaceTXT = false;
  bool interfaceAV = false;

  String typePassword = "alphanumeric"; // Valor inicial para la selección de contraseña

  // Para almacenar la imagen que se suba
  File? image;

  // CONTROLADORES PARA TRABAJAR CON LOS CAMPOS
  final TextEditingController userController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: buildMainContainer(740, 650, EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0), 
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Alta de estudiante', style: titleTextStyle),
              Text('Ingresa los datos del estudiante', style:subtitleTextStyle),
              SizedBox(height: 20),
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
                        buildTextField('Usuario*', userController),
                        SizedBox(height: 10),
                        buildTextField('Nombre*', nameController),
                        SizedBox(height: 10),
                        buildTextField('Apellidos', surnameController),
                        SizedBox(height: 40),
                        // Imagen de perfil
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Imagen de perfil*',
                              style: hintTextStyle,
                            ),
                            SizedBox(height: 10),
                            buildPickerRegion(
                              () async {
                                final pickedImage = await pickImage(); // Seleccionar la imagen
                                if (pickedImage != null) {
                                  setState(() {
                                    image = pickedImage; // Asignar la imagen seleccionada
                                  });
                                }
                              }, 
                              buildPickerContainer(150, Icons.cloud_upload, 'Sube una imagen', BoxFit.contain, image),
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
                          'Selecciona cómo ve la aplicación el estudiante*',
                          style: hintTextStyle,
                        ),
                        buildCheckbox('Pictogramas', interfacePIC, false, (bool value) {
                          setState(() {
                            interfacePIC = value;
                          });
                        }),
                        buildCheckbox('Imágenes', interfaceIMG, false, (bool value) {
                          setState(() {
                            interfaceIMG = value;
                          });
                        }),
                        buildCheckbox('Texto', interfaceTXT, false, (bool value) {
                          setState(() {
                            interfaceTXT = value;
                          });
                        }),
                        buildCheckbox('Contenido Audiovisual', interfaceAV, false, (bool value) {
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
                        buildRadio('Pictogramas', 'pictograms', typePassword, 'alphanumeric', (String value) {
                          setState(() {
                            typePassword = value;
                          });
                        }),
                        buildRadio('Imágenes', 'images', typePassword, 'alphanumeric', (String value) {
                          setState(() {
                            typePassword = value;
                          });
                        }),
                        buildRadio('Alfanumérica', 'alphanumeric', typePassword, 'alphanumeric', (String value) {
                          setState(() {
                            typePassword = value;
                          });
                        }),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Botones de navegación
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: buildElevatedButton(
                        'Siguiente',
                        buttonTextStyle,
                        nextButtonStyle, 
                        () async {
                          String userStudent = userController.text;
                          String nameStudent = nameController.text;
                          String surnameStudent = surnameController.text;
                          if (!nameStudent.isEmpty && !userStudent.isEmpty) {
                            if(!userFormat(userStudent)){ // TOMATE
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('El usuario no puede contener espacios ni caracteres especiales.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else if (!(await userIsValid(userStudent))) { // TOMATE
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('El usuario ingresado ya está registrado.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              if (!interfaceAV && !interfaceIMG && !interfacePIC && !interfaceTXT) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Hay que seleccionar al menos un modo de visualización.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                if (image != null) {
                                  if (typePassword == 'pictograms' || typePassword == 'images') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImgCodePasswordPage(
                                          userStudent: userStudent,
                                          nameStudent: nameStudent,
                                          surnameStudent: surnameStudent,
                                          interfacePIC: interfacePIC,
                                          interfaceIMG: interfaceIMG,
                                          interfaceTXT: interfaceTXT,
                                          interfaceAV: interfaceAV,
                                          perfilImage: image!,
                                          typePassword: typePassword,
                                        ),
                                      ),
                                    );
                                  } else if (typePassword == 'alphanumeric') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AlphanumericPasswordPage(
                                          userStudent: userStudent,
                                          nameStudent: nameStudent,
                                          surnameStudent: surnameStudent,
                                          interfacePIC: interfacePIC,
                                          interfaceIMG: interfaceIMG,
                                          interfaceTXT: interfaceTXT,
                                          interfaceAV: interfaceAV,
                                          perfilImage: image!,
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
                                content: Text('El nombre y el usuario no pueden ser vacíos.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () async {
                          setState(() {});
                          Navigator.pop(context);
                          setState(() {});
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

// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ DE CONTRASEÑA DE IMÁGENES O PICTOGRAMAS
// //////////////////////////////////////////////////////////////////////////////////////////

class ImgCodePasswordPage extends StatefulWidget {
  final String userStudent, nameStudent, surnameStudent, typePassword;
  final bool interfacePIC, interfaceIMG, interfaceTXT, interfaceAV;
  final File? perfilImage;

  ImgCodePasswordPage({
    required this.userStudent,
    required this.nameStudent,
    required this.surnameStudent,
    required this.interfacePIC,
    required this.interfaceIMG,
    required this.interfaceTXT,
    required this.interfaceAV,
    required this.perfilImage,
    required this.typePassword,
  });

  @override
  _ImgCodePasswordPageState createState() => _ImgCodePasswordPageState();
}

class _ImgCodePasswordPageState extends State<ImgCodePasswordPage> {
  // Pictogramas o imágenes opcionales para la contraseña
  List<ImgCode> selectedElements = [];
  // Pictogramas o imágenes que componen la contraseña
  List<ImgCode> passwordElements = [];

  @override
  Widget build(BuildContext context) {
    String hintUpload = '', pluralWord = '';
    if (widget.typePassword == 'pictograms') {
      hintUpload = 'Sube un pictograma';
      pluralWord = 'pictogramas';
    }
    else if (widget.typePassword == 'images') {
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
              Text('Alta de ${widget.nameStudent}', style: titleTextStyle),
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

                            if (widget.typePassword == 'pictograms') folder = 'picto_claves';
                            else if (widget.typePassword == 'images') folder = 'imgs_claves';

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

                            setState(() {});
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
                                  });
                                },
                                typePassword: widget.typePassword,
                              ),
                            ),
                          );
                          setState(() {});
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
                    setState(() {});
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

                          // Obtener la extensión del archivo original
                          String extension = path.extension(widget.perfilImage!.path);

                          // Meter al estudiante en la BD
                          if (await insertStudent(
                            widget.userStudent, widget.nameStudent, widget.surnameStudent, password, 'assets/perfiles/${widget.userStudent}$extension', 
                            widget.typePassword, widget.interfaceIMG ? 1:0, widget.interfacePIC ? 1:0, widget.interfaceTXT ? 1:0
                          )) 
                          {
                              // Guardar la imagen de perfil en la carpeta
                              await saveImage(widget.perfilImage!, '${widget.userStudent}$extension', 'assets/perfiles');

                              // Guardar los elementos que deben salir al estudiante para introducir su contraseña
                              createStudentImgCodePassword(widget.userStudent, selectedElements);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Estudiante registrado con éxito.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                  builder: (context) => hu4.StudentListPage(),
                                ),
                              );
                              setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al registrar al estudiante.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          setState(() {});
                          Navigator.pop(context);
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
                          setState(() {});
                          Navigator.pop(context);
                          setState(() {});
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
// INTERFAZ DE SELECCIÓN DE PICTOGRAMAS O IMÁGENES
// //////////////////////////////////////////////////////////////////////////////////////////

// Página para seleccionar pictogramas o imágenes que formarán parte de las posibilidades de contraseña del estudiante
class ImgCodeSelectionPage extends StatefulWidget {
  final Function(List<ImgCode>) updateSelectedElements;
  final String typePassword;

  ImgCodeSelectionPage({
    required this.updateSelectedElements,
    required this.typePassword,
  });

  @override
  _ImgCodeSelectionPageState createState() => _ImgCodeSelectionPageState();
}

class _ImgCodeSelectionPageState extends State<ImgCodeSelectionPage> {
  final List<ImgCode> elements = [];
  String gallery = '';

  // Lista para seleccionar pictogramas o imágenes
  final List<ImgCode> selectionElements = [];

  // TOMATE
  // Para cargar los elementos
  Future<void> loadGallery() async {
    if (elements.isEmpty) {
      setState(() {});
      if (widget.typePassword == "pictograms") {
        elements.addAll(await getImgCodeFromFolder('assets/picto_claves'));
        gallery = 'Pictogramas';
      } else if (widget.typePassword == "images") {
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
    setState(() {});
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
                child: buildTickGrid(4, 8, elements, selectionElements, 6, context),
              ),
              SizedBox(height: 20),
              // Botón Guardar
              SizedBox(
                width: 400,
                child: buildElevatedButton('Guardar selección', buttonTextStyle, nextButtonStyle, () {
                    widget.updateSelectedElements(selectionElements);
                    setState(() {});
                    Navigator.pop(context);
                    setState(() {});
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
  final String userStudent, nameStudent, surnameStudent;
  final bool interfacePIC , interfaceIMG, interfaceTXT, interfaceAV;
  final File? perfilImage;

  bool is_obscure = true;

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
  });
  @override
  _AlphanumericPasswordPage createState() => _AlphanumericPasswordPage(
    userStudent: userStudent,
    nameStudent: nameStudent,
    surnameStudent: surnameStudent,
    interfacePIC: interfacePIC,
    interfaceIMG: interfaceIMG,
    interfaceTXT: interfaceTXT,
    interfaceAV: interfaceAV,
    perfilImage: perfilImage,
  );
}

class _AlphanumericPasswordPage extends State<AlphanumericPasswordPage>{
  final String userStudent, nameStudent, surnameStudent;
  final bool interfacePIC , interfaceIMG, interfaceTXT, interfaceAV;
  final File? perfilImage;

  bool obscurePass = true, obscureSamePass = true;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController samePasswordController = TextEditingController();

  _AlphanumericPasswordPage({
    required this.userStudent,
    required this.nameStudent,
    required this.surnameStudent,
    required this.interfacePIC,
    required this.interfaceIMG,
    required this.interfaceTXT,
    required this.interfaceAV,
    required this.perfilImage,
  });

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
                'Alta de $nameStudent',
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
                              // Obtener la extensión del archivo original
                              String extension = path.extension(perfilImage!.path);

                              // TOMATE
                              // Meter al estudiante en la BD
                              if (await insertStudent(
                                userStudent, nameStudent, surnameStudent, passwordController.text, 'assets/perfiles/$userStudent$extension', 
                                'alphanumeric', interfaceIMG ? 1:0, interfacePIC ? 1:0, interfaceTXT ? 1:0
                              )) 
                              {
                                // Guardar la imagen de perfil en la carpeta
                                await saveImage(perfilImage!, '$userStudent$extension', 'assets/perfiles');

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Estudiante registrado con éxito.'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                        
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                  builder: (context) => hu4.StudentListPage(),
                                ),
                              );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error al registrar al estudiante.'),
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