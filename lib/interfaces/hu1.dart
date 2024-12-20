import 'package:flutter/material.dart';
import 'dart:io';
import 'package:proyecto/bd_utils.dart';
import '../classes/Order.dart';
import '../classes/Task.dart';
import 'package:proyecto/classes/Step.dart' as ownStep;
import 'hu2.dart' as hu2;
import 'hu3.dart' as hu3;
import 'hu4.dart' as hu4;
import 'hu6.dart' as hu6;
import 'hu8.dart' as hu8;
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
/// INTERFAZ DE LOGIN ADMINISTRADOR
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
                            setState(() {}); Navigator.pop(context); setState(() {});
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
/// INTERFAZ PRINCIPAL DEL ADMINISTRADOR
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
                    buildOption(
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
                    buildOption(
                      icon: Icons.checklist,
                      label: 'Tareas',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TaskListPage()),
                        );
                      },
                    ),
                    SizedBox(width: 40),
                    buildOption(
                      icon: Icons.restaurant,
                      label: 'Menú',
                      onTap: () async{
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CommandList()),
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
                  child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () async{
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => hu3.StudentLoginPage()),
                      );
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
}

// //////////////////////////////////////////////////////////////////////////////////////////
/// INTERFAZ DE LISTA DE TAREAS DISPONIBLES
// //////////////////////////////////////////////////////////////////////////////////////////

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late List<Task> tasks = [];

  Future<void> _loadTasks() async {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    
    setState(() {});
    tasks.clear();
    if (await hasMenuTaskToday()) {
      tasks.add((await getTask(1))!);
    }
    tasks.addAll(await getAllTasks());
    setState(() {});
  }


  Future<void> deleteTaskInterface(int id) async {
    await deleteTask(id);
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: buildMainContainer(740, 625, EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0), 
          buildCustomList(items: tasks, title: "Lista de tareas", addButton: true, nextPage: hu2.StudentRegistrationPage(), context: context, circle: false, fit: BoxFit.contain, buildChildren: (context, item, index) { 
            return [
              IconButton(
              icon: Icon(Icons.info_outline),
              color: Colors.blue,
              onPressed:
                // Navegar a la página de información de la tarea
                () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        if (item.id == 1) {
                          return hu6.MenuList();
                        } else {
                          return TaskInformationPage(task: item);
                        }
                      },
                    ),
                  );
                  setState(() {});
                },
              ),
              if (item.id != 1)
              IconButton(
                icon: Icon(Icons.edit),
                color: Colors.blue,
                onPressed:
                  // Navegar a la página de modificación de la tarea
                  () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => hu8.TaskModificationPage(task: item),
                      ),
                    ).then((_) {
                      // Cargar las tareas cuando se vuelva
                      _loadTasks();
                    });
                    setState(() {});
                  },
              ),
              if (item.id != 1)
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.blue,
                onPressed:
                  () async {
                    await deleteTaskInterface(item.id);
                    setState((){
                      tasks.removeAt(index);
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
// INTERFAZ QUE MUESTRA LAS COMANDAS DEL DÍA
// //////////////////////////////////////////////////////////////////////////////////////////

class CommandList extends StatefulWidget {

  @override
  _CommandListState createState() => _CommandListState();
}

class _CommandListState extends State<CommandList> {
  
  List<Order> orders = [];
  final groupeOrders = <String, List<Order>>{};

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    orders = await getOrdersByDate();
    setState(() {});

    for (var order in orders) {
      if (!groupeOrders.containsKey(order.classroomName)) {
        groupeOrders[order.classroomName] = [];
      }
      groupeOrders[order.classroomName]!.add(order);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: buildMainContainer(740,650,EdgeInsets.all(20), 
          Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 15),
                  Text(
                    "Comandas del día",
                    style: titleTextStyle,
                  ),
                  SizedBox(height: 15),
                  if (!orders.isEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: groupeOrders.length,
                        itemBuilder: (context, index) {
                          final classroomName = groupeOrders.keys.toList()[index];
                          final classroomOrders = groupeOrders[classroomName]!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Clase: ${classroomName}',
                                style: titleTextStyle.copyWith(fontSize: 24)
                              ),
                              SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true, // Permite que el ListView tome solo el espacio necesario
                                physics: NeverScrollableScrollPhysics(), // Desactiva el desplazamiento interno
                                itemCount: classroomOrders.length,
                                itemBuilder: (context, index) {
                                  final order = classroomOrders[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 8.0),
                                    child: ListTile(
                                      title: Text(order.menuName),
                                      trailing: Text(
                                        'Cantidad: ${order.quantity}',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 15), // Espaciado entre grupos
                            ],
                          );
                        }
                      ),
                    )
                  else... [
                    Spacer(),
                    Text(
                      'No se han realizado las comandas aún.',
                      style: hintTextStyle,
                    ),
                    Spacer(),
                  ],
                  SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                    width: 200,
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
        )
      )
    );
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////
/// INTERFAZ DE INFORMACIÓN DE TAREAS
// //////////////////////////////////////////////////////////////////////////////////////////

class TaskInformationPage extends StatefulWidget {
  final Task task;
  const TaskInformationPage({super.key, required this.task});

  @override
  _TaskInformationPageState createState() =>
      _TaskInformationPageState();
}

class _TaskInformationPageState extends State<TaskInformationPage> {
  // Para almacenar los pasos de la tarea
  final List<ownStep.Step> steps = [];

  // TOMATE
  // Para cargar los pasos
  Future<void> loadSteps() async {
    steps.clear();
    setState(() {});
    steps.addAll(await getAllStepsFromTask(widget.task.id));
    steps.sort((a, b) => a.id.compareTo(b.id));
    setState(() {});
  }

  late ScrollController scroll;

  @override
  void initState() {
    super.initState();
    scroll = ScrollController();
    loadSteps();
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
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
              Text('Tarea: ${widget.task.name}', style: titleTextStyle),
              widget.task.description == ''
              ? Text('Descripción: Sin descripción', style: subtitleTextStyle)
              : SizedBox(
                  height: 20,
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: scroll,
                    child: SingleChildScrollView(
                      controller: scroll,
                      child: Text(
                        'Descripción: ${widget.task.description}',
                        style: subtitleTextStyle,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 15),
              // Formulario
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 20),
                  // Pictograma e imagen
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Pictograma',
                                  style: infoTextStyle,
                                ),
                                SizedBox(height: 10),
                                Container(
                                  height: 150,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(widget.task.pictogram),
                                      fit: BoxFit.contain,
                                    ),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  Text(
                                  'Imagen',
                                  style: infoTextStyle,
                                ),
                                SizedBox(height: 10),
                                Container(
                                  height: 150,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(widget.task.image),
                                      fit: BoxFit.contain,
                                    ),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
              SizedBox(height: 20),
              // Pasos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pasos:',
                      style: infoTextStyle,
                    ),
                    SizedBox(height: 10),
                    buildBorderedContainer(Colors.grey, 1,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            // Lista de pasos registrados
                            steps.isEmpty
                              ? SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    'No hay pasos registrados.',
                                    style: hintTextStyle,
                                  ),
                                ),
                              )
                              : SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  itemCount: steps.length,
                                  itemBuilder: (context, index) {
                                    final item = steps[index];
                                    return Card(
                                      margin: EdgeInsets.symmetric(vertical: 8.0),
                                      child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: Image.file(
                                            File(item.image),
                                            fit: BoxFit.cover,
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                        title: Text('Paso ${item.id+1}'),
                                        subtitle: Text(item.description != '' ? item.description : 'Sin descripción'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Botones de navegación
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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