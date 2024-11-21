import 'package:flutter/material.dart';
import 'package:proyecto/bd_utils.dart';
import 'package:proyecto/classes/ImgCode.dart';
import 'package:proyecto/classes/Student.dart';
import 'package:proyecto/interfaces/interface_utils.dart';
import 'package:proyecto/interfaces/login.dart' as loginPage;
///  LOGINS ESTUDIANTES  ///
/// HU3: Como estudiante quiero poder acceder a la aplicación de forma personalizada.

class LoginAlphanumericPage extends StatefulWidget {
  final String user;

  LoginAlphanumericPage({required this.user});
  @override
  _LoginAlphanumericPageState createState() => _LoginAlphanumericPageState(user: user);
}

class _LoginAlphanumericPageState extends State<LoginAlphanumericPage> {
  final String user;
  late final Student student;
  _LoginAlphanumericPageState({
    required this.user
    });
  // CONTROLADORES PARA TRABAJAR CON LOS CAMPOS
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true; // Controla si el texto está oculto o visible

  Future<void> loadStudent() async {
    setState(() {});
    student = (await getStudent(user))!;
    userController.text = student.user;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadStudent();
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
                    
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => loginPage.StudentListPage(),
                        ),
                      );
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
          AvatarTopCorner(student)
        ],
      ),
    );
  }
}

class LoginImagePage extends StatefulWidget {
  final String user;

  LoginImagePage({required this.user});
  @override
  _LoginImagePageState createState() => _LoginImagePageState(user: user);
}

class _LoginImagePageState extends State<LoginImagePage> {
  final String user;
  late final Student student;
  late final List<ImgCode> imagenes;

  _LoginImagePageState({
    required this.user
    });
  // CONTROLADORES PARA TRABAJAR CON LOS CAMPOS
  final TextEditingController passwordController = TextEditingController();// Controla si el texto está oculto o visible

  Future<void> loadStudent() async {
    setState(() {});
    student = (await getStudent(user))!;
    imagenes = await getStudentMenuPassword(user);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadStudent();
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
                        } else if (await loginStudent(user, passwordController.text) == false) { // Si del check de la BD se recupera false
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
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => loginPage.StudentListPage(),
                          ),
                        );
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
            AvatarTopCorner(student)
          ],
        ),
    );
  }
}