import 'package:flutter/material.dart';
import 'package:proyecto/bd_utils.dart';
import 'package:proyecto/classes/ImgCode.dart';
import 'package:proyecto/classes/Student.dart';
import 'package:proyecto/image_utils.dart';
import 'package:proyecto/interfaces/interface_utils.dart';

import 'package:proyecto/interfaces/hu1.dart' as hu1;
import 'package:proyecto/interfaces/hu9.dart' as hu9;
///  LOGINS ESTUDIANTES  ///
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
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                  '¿Quién eres?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  ),
                ),
                  Expanded(
                    child: Padding(
                    padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                        ),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          return GestureDetector(
                            onTap: () async {
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
                          },
                            child: Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image(
                                        image: AssetImage(student.image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 8),
                                Text(
                                  student.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () async{
                // Acción cuando el texto sea tocado
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => hu1.LoginAdminPage(),
                  ),
                );
                // Aquí puedes agregar la lógica que quieras al hacer clic en el texto
              },
              child: Container(
                margin: EdgeInsets.only(top: 20, right: 20),
                child: Text(
                  'Soy administrador',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 0, 63, 102),
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
      backgroundColor: Colors.lightBlueAccent.shade100, // Color de fondo
      body: Stack(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white, // Fondo blanco del contenedor
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: userController,
                    decoration: InputDecoration(
                      hintText: 'Usuario',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          }); 
                        },
                      ),  
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async{
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
                        print('Inicio de sesión correcto.');
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => hu9.StudentInterfacePage(student: widget.student),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange[400],
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Atrás',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
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
// INTERFAZ LOGIN DE ESTUDIANTE CON IMÁGENES
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

  // CONTROLADORES PARA TRABAJAR CON LOS CAMPOS
  final TextEditingController passwordController = TextEditingController();// Controla si el texto está oculto o visible

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Usuario',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 10),
                        Icon(Icons.person, color: Colors.blue, size: 30),
                      ],
                    ),
                    SizedBox(height: 20),
                    //Grid de imagenes
                    Expanded(
                      child: buildTickGrid(3, 8, imagesSelection, imagesPassword, imagesMax!, context),
                    ),
                    /*Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                        ),
                        itemCount: imagesSelection.length,
                        itemBuilder: (context, index){
                          return GestureDetector(
                            onTap: () {
                              passwordController.text += imagesSelection[index].code + ' ';
                              // habria que hacer q el seleccionado se resalte
                              // que solo se pueda seleccionar una vez y si se le da otra
                              // se deselecciona
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  imagesSelection[index].path,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          );
                        }
                      ),
                    ),*/
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async{
                        if (passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('El campo de usuario y contraseña no pueden ser vacíos.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (await loginStudent(widget.student.user, passwordController.text) == false) { // Si del check de la BD se recupera false
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Usuario o contraseña incorrectos.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          print('Inicio de sesión correcto.');
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => hu9.StudentInterfacePage(student: widget.student),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Iniciar Sesión',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange[400],
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Atrás',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
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