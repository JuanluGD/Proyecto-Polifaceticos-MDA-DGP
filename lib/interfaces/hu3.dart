import 'package:flutter/material.dart';
import '../bd_utils.dart';
import '../classes/ImgCode.dart';
import '../classes/Student.dart';
import '../image_utils.dart';
import 'interface_utils.dart';
import 'hu1.dart' as hu1;
import 'hu9.dart' as hu9;

///  LOGIN ESTUDIANTES  ///
/// HU3: Como estudiante quiero poder acceder a la aplicación de forma personalizada.

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
      home: StudentLoginPage(),
    );
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ DE SELECCION DE ESTUDIANTE LOGIN
// //////////////////////////////////////////////////////////////////////////////////////////

class StudentLoginPage extends StatefulWidget {
  @override
  _StudentLoginPageState createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage>  {
  final List<Student> students = [];

  // TOMATE
  // Para cargar los estudiantes
  Future<void> loadStudents() async {
    if (students.isEmpty) {
      setState(() {});
      students.addAll(await getAllStudents());
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
        body: Stack(
          children: [
            Center(
              child: buildMainContainer(740, 625, EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0), 
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Text(
                    '¿Quién eres?',
                    style: titleTextStyle
                    ),
                  ),
                  SizedBox(height: 15),
                  navigationGrid(3, 16.0, students, (student) async {
                    if (student.typePassword == 'alphanumeric') {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginAlphanumericPage(student : student),
                        ),
                      );
                    } else {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginImgCodePage(student : student),
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: buildPickerRegion(
              () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => hu1.LoginAdminPage(),
                  ),
                );
              },
              Container(
                margin: EdgeInsets.only(top: 10, right: 20),
                child: Text(
                  'Soy administrador',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ LOGIN ESTUDIANTE ALFANUMÉRICO
// //////////////////////////////////////////////////////////////////////////////////////////

class LoginAlphanumericPage extends StatefulWidget {
  final Student student;

  LoginAlphanumericPage({required this.student});
  @override
  _LoginAlphanumericPageState createState() => _LoginAlphanumericPageState();
}

class _LoginAlphanumericPageState extends State<LoginAlphanumericPage> {
  // CONTROLADORES PARA TRABAJAR CON LOS CAMPOS
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true; // Controla si el texto está oculto o visible

  @override
  void initState() {
    super.initState();
    userController.text = widget.student.user;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Stack(
        children: [
          Center(
            child: buildMainContainer(740, 625, EdgeInsets.all(70.0),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 80),
                  Text(
                    'Iniciar Sesión',
                    style: titleTextStyle
                  ),
                  SizedBox(height: 40),
                  buildFilledTextField('Usuario', userController),
                  SizedBox(height: 15),
                  buildPasswdTextField('Contraseña', passwordController, _isObscure, () {
                    setState(() {
                      _isObscure = !_isObscure;
                    }); 
                  }),
                  SizedBox(height: 30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          width: 400,
                          child: buildElevatedButton('Iniciar Sesión', buttonTextStyle, nextButtonStyle, () async {
                              if (userController.text.isEmpty || passwordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('El campo de usuario y contraseña no pueden ser vacíos.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else if (await loginStudent(userController.text, passwordController.text) == false) { // Si del check de la BD se recupera false
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Usuario o contraseña incorrectos.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => hu9.StudentInterfacePage(student: widget.student),
                                  ),
                                );
                              }
                            }
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
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
          avatarTopCorner(widget.student),
        ],
      ),
    );
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ LOGIN DE ESTUDIANTE CON IMÁGENES O PICTOGRAMAS
// //////////////////////////////////////////////////////////////////////////////////////////

class LoginImgCodePage extends StatefulWidget {
  final Student student;

  LoginImgCodePage({required this.student});
  @override
  _LoginImgCodePageState createState() => _LoginImgCodePageState();
}

class _LoginImgCodePageState extends State<LoginImgCodePage> {
  List<ImgCode> imagesSelection = [];
  List<ImgCode> imagesPassword = [];

  Future<void> loadImages() async {
    setState(() {});
    imagesSelection = await getStudentMenuPassword(widget.student.user);
    setState(() {});
  }

  int? imagesMax;

  Future<void> loadPasswordCount() async {
    imagesMax = await getImagePasswdCount(widget.student.user);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadImages();
    loadPasswordCount();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
        body: Stack(
          children: [
            Center(
              child: buildMainContainer(740, 625, EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                Column(
                  children: [
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.student.user} \t',
                          style: titleTextStyle
                        ),
                        Icon(Icons.person, color: Colors.blue, size: 30),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Grid de la selección de imágenes o pictogramas
                    if (imagesSelection.length > 3)
                      Expanded(
                        child: buildBorderedContainer(Colors.grey, 2,
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildSizedIconTickGrid(3, 8, 200, imagesSelection, imagesPassword, imagesMax!, context),
                          ),
                        ),
                      )
                    else
                      Container(
                        constraints: BoxConstraints(maxHeight: 230),
                        child: buildBorderedContainer(Colors.grey, 2,
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildSizedIconTickGrid(3, 8, 200, imagesSelection, imagesPassword, imagesMax!, context),
                          ),
                        ),
                      ),
                    SizedBox(height: imagesSelection.length > 3 ? 10 : 20),
                    // Grid que muestra las imágenes ya seleccionadas
                    Container(
                      constraints: BoxConstraints(maxHeight: 220),
                      child: buildBorderedContainer(Colors.grey, 2, buildGrid(3, 8, imagesPassword)),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildIconButton('Volver', Colors.deepOrange[400]!, Colors.white, Icons.arrow_back, () {
                          Navigator.pop(context);
                        }),
                        buildIconButton('Borrar', Colors.red, Colors.white, Icons.delete, () {
                          if (imagesPassword.isNotEmpty) {
                            imagesPassword.removeLast();
                            setState(() {});
                          }
                        }),
                        buildIconButton('Iniciar sesión', Colors.blue, Colors.white, Icons.arrow_forward, () async {
                          // TOMATE
                          // Crear la contraseña que correspondería a los elementos seleccionados
                          String password = await imageCodeToPassword(imagesPassword);
                          // Comprobar si es correcta e informar de que no o acceder si sí
                          if (await loginStudent(widget.student.user, password) == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Contraseña incorrecta.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => hu9.StudentInterfacePage(student: widget.student),
                              ),
                            );
                          }
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            avatarTopCorner(widget.student)
          ],
        ),
    );
  }
}