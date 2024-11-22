import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/bd_utils.dart';
import 'package:proyecto/classes/ImgCode.dart';
import 'package:proyecto/classes/Student.dart';
import 'package:proyecto/interfaces/hu6.dart';
import 'package:proyecto/interfaces/interface_utils.dart';
import 'package:proyecto/interfaces/login.dart' as loginPage;
///  LOGINS ESTUDIANTES  ///
/// HU3: Como estudiante quiero poder acceder a la aplicación de forma personalizada.
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Student student;

  @override
  void initState() {
    super.initState();
    _loadStudent();
  }

  Future<void> _loadStudent() async {
    student = (await getStudent('juancito'))!;
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Estudiante',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginImagePage(student: student)
      );
  }
}
class LoginAlphanumericPage extends StatefulWidget {
  final Student student;

  LoginAlphanumericPage({required this.student});
  @override
  _LoginAlphanumericPageState createState() => _LoginAlphanumericPageState(student: student);
}

class _LoginAlphanumericPageState extends State<LoginAlphanumericPage> {
  final Student student;
  _LoginAlphanumericPageState({
    required this.student
    });
  // CONTROLADORES PARA TRABAJAR CON LOS CAMPOS
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true; // Controla si el texto está oculto o visible


  @override
  void initState() {
    super.initState();
    userController.text = student.user;
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Inicio de sesión correcto.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // TOMATE Navegar a la página del alumno
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
          avatarTopCorner(student)
        ],
      ),
    );
  }
}

class LoginImagePage extends StatefulWidget {
  final Student student;

  LoginImagePage({required this.student});
  @override
  _LoginImagePageState createState() => _LoginImagePageState(student: student);
}

class _LoginImagePageState extends State<LoginImagePage> {
  final Student student;
  late final List<ImgCode> imagenes;

  _LoginImagePageState({
    required this.student
    });
  // CONTROLADORES PARA TRABAJAR CON LOS CAMPOS
  final TextEditingController passwordController = TextEditingController();// Controla si el texto está oculto o visible

  Future<void> loadImages() async {
    setState(() {});
    imagenes = await getStudentMenuPassword(student.user);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadImages();
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
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                        ),
                        itemCount: imagenes.length,
                        itemBuilder: (context, index){
                          return GestureDetector(
                            onTap: () {
                              passwordController.text += imagenes[index].code + ' ';
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
                                  imagenes[index].path,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          );
                        }
                      ),
                    ),
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
                        } else if (await loginStudent(student.user, passwordController.text) == false) { // Si del check de la BD se recupera false
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Usuario o contraseña incorrectos.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Inicio de sesión correcto.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          // TOMATE Navegar a la página del alumno
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
            avatarTopCorner(student)
          ],
        ),
    );
  }
}