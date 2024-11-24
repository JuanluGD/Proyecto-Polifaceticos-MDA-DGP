import 'package:flutter/material.dart';
import 'package:proyecto/bd_utils.dart';
import 'hu4.dart' as hu4;
import 'hu6.dart' as hu6;
import 'hu10.dart' as hu10;
import 'interface_utils.dart';

/// LOGIN ADMINISTRADOR ///
/// HU1: Como administrador quiero poder acceder a la aplicación con mi usuario y mi contraseña

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Admin Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: adminInterface(),
    );
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ DE LOGIN ADMINISTRADOR
// //////////////////////////////////////////////////////////////////////////////////////////
class LoginAdminPage extends StatefulWidget {
  const LoginAdminPage({super.key});

  @override
  _LoginAdminPageState createState() => _LoginAdminPageState();
}

class _LoginAdminPageState extends State<LoginAdminPage> {
  // CONTROLADORES PARA TRABAJAR CON LOS CAMPOS
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true; // Controla si el texto está oculto o visible

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Row(
          children: [
            // Parte izquierda con la imagen de fondo
            Expanded(
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/colegio.jpg'), // Imagen de fondo
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Parte derecha con el formulario
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(52.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo en la parte superior
                    Center(
                      child: Image.asset(
                        'assets/logo.png', // Logo de San Juan de Dios
                        height: 150,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        '¡Hola de nuevo!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Por favor, ingresa tus credenciales',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    // Campo de usuario
                    TextField(
                      controller: userController,
                      decoration: InputDecoration(
                        labelText: 'Usuario',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Campo de contraseña
                    TextField(
                      obscureText: _isObscure,
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
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
                    SizedBox(height: 10),
                    // Olvido de contraseña
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Acción de recuperar contraseña
                        },
                        child: Text(
                          '¿Has olvidado la contraseña?',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    // Botón de iniciar sesión
                    Center(
                      child: SizedBox(
                        width: 350,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (userController.text.isEmpty || passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('El campo de usuario y contraseña no pueden ser vacíos.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else if (await loginAdmin(userController.text, passwordController.text) == false) { // Si del check de la BD se recupera false
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
                                  builder: (context) => adminInterface(),
                                ),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => adminInterface(),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 24.0),
                          ),
                          child: Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Botón de atrás
                    Center(
                      child: SizedBox(
                        width: 350,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ PRINCIPAL DEL ADMINISTRADOR
// //////////////////////////////////////////////////////////////////////////////////////////
class adminInterface extends StatelessWidget {
  const adminInterface({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: buildMainContainer(740,650,EdgeInsets.all(20), 
          Stack(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildOption(
                      icon: Icons.group,
                      label: 'Listado de alumnos',
                      onTap: ()  async{
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => hu4.StudentListPage()),
                        );
                      },
                    ),
                    SizedBox(width: 40),
                    _buildOption(
                      icon: Icons.checklist,
                      label: 'Tareas',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => hu10.TaskListPage()),
                        );
                      } ,
                    ),
                    SizedBox(width: 40),
                    _buildOption(
                      icon: Icons.restaurant,
                      label: 'Menú',
                      onTap: () async{
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => hu6.CommandList()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // PRUEBAS, SE ELIMINARA PARA EL PRODUCTO FINAL
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 400,
                  child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap, // Agregamos el callback de tap
  }) {
    return GestureDetector(
      onTap: onTap, // Se ejecuta cuando el usuario toca el botón
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(40),
            child: Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}