import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/classes/Classroom.dart';
import 'package:proyecto/classes/Menu.dart';
import 'package:proyecto/classes/Orders.dart';

import 'package:proyecto/interfaces/interface_utils.dart';
import 'package:proyecto/bd_utils.dart';

import 'package:proyecto/classes/Student.dart';

import 'package:proyecto/interfaces/hu9.dart' as hu9;
/// TAREA MENU COMEDOR
/// HU6: Como alumno quiero poder realizar la tarea de comandas
Future<void> main() async {
  Student student = (await getStudent('alex123'))!;
  runApp(MyApp(student: student));
}

class MyApp extends StatefulWidget {
  final Student student;
  const MyApp({super.key, required this.student});

  @override
  _MyAppState createState() => _MyAppState(student: student);
}

class _MyAppState extends State<MyApp> {
  final Student student;
  _MyAppState({required this.student});
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Comandas',
        // theme: ThemeData(
        //   // useMaterial3: true,
        //   // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        // ),
        home: ClassSelection(student: student),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  List<Classroom> classrooms = [];// Clases completadas

  MyAppState() {
    _initializeAppState();
  }

  Future<void> _initializeAppState() async {
    await _initializeClassrooms();
    await markClassAsCompleted(classrooms);
  }

  Future<void> _initializeClassrooms() async {
    classrooms = await getAllClassrooms();
    notifyListeners();
  }
  Future<void> markClassAsCompleted(List<Classroom> classrooms) async{
    for(Classroom c in classrooms) {
      await classCompleted(c); // Marca una clase como completada
    }
    notifyListeners();
  }


}


// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ DE SELECCIÓN DE CLASES 
// //////////////////////////////////////////////////////////////////////////////////////////
class ClassSelection extends StatefulWidget {
  final Student student;
  const ClassSelection({super.key, required this.student});

  @override
  _ClassSelectionState createState() => _ClassSelectionState();
}

class _ClassSelectionState extends State<ClassSelection> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Stack(
        children: [
          Center(
            child: buildMainContainer(
              740,
              625,
              EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 15),
                  Text(
                    'Comandas',
                    style: titleTextStyle,
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                      children: [
                        ...appState.classrooms.map((classroom) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommandListPage(
                                      classroom: classroom,
                                      student: widget.student,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color:
                                      Colors.white10,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4.0,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        if (widget.student.interfacePIC == 1 || widget.student.interfaceIMG == 1) 
                                        Image(
                                          image: AssetImage(classroom.image),
                                        ),
                                        if(widget.student.interfaceTXT == 1)
                                        Text(
                                          'Clase ${classroom.name}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (classroom.task_completed) ...[
                                          SizedBox(height: 8.0),
                                          Icon(Icons.check_circle,
                                              color: Colors.blue, size: 80.0),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  if( appState.classrooms.every((c) => c.task_completed == true))
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 400,
                      child: buildElevatedButton('Terminar', buttonTextStyle, nextButtonStyle, () {
                          Navigator.pop(context);
                        },
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


class CommandListPage extends StatefulWidget {
  final Classroom classroom;
  final Student student;

  CommandListPage({
    required this.classroom,
    required this.student
    });
    
  @override
  _CommandListPageState createState() => _CommandListPageState();
}

class _CommandListPageState extends State<CommandListPage> {
  final List<Menu> menus = [];
  final List<Orders> orders = [];
  final Map<String, int> orders_aux = {};
  final path = 'assets/numeros/';

  final List<String> images = [];



  // Para cargar los menús.
  Future<void> loadMenus() async {
    
    DateTime now = DateTime.now();
    String date = now.day.toString() + "/" + now.month.toString() + "/" + now.year.toString();
    if (menus.isEmpty) {
      setState(() {});
      menus.addAll(await getAllMenus());
      for (var menu in menus) {
        orders_aux[menu.name] = await getQuantity(date, widget.classroom.name, menu.name);
      }
    }
    if(widget.student.interfacePIC == 1){
      for(Menu m in menus){
        images.add(m.pictogram);
      }
    }
    else{
      for(Menu m in menus){
        images.add(m.image);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadMenus();
  }

  void addMenuQuantity(String menuName) {
    if ((orders_aux[menuName] ?? 0) < 8) 
      orders_aux[menuName] = (orders_aux[menuName] ?? 0) + 1;
    
  }

  void removeMenuCuantity(String menuName) {
    if ((orders_aux[menuName] ?? 0) > 0)
      orders_aux[menuName] = (orders_aux[menuName] ?? 0) - 1;
  }

  Future<void> createOrders(Map<String, int> orders_aux) async {
    orders.clear();
    DateTime now = DateTime.now();
    String date = now.day.toString() + "/" + now.month.toString() + "/" + now.year.toString();
    for (var menu in orders_aux.keys) {
      if (orders_aux[menu]! > 0) {
        Orders? order = await getOrder(date, widget.classroom.name, menu);
        if (order != null){
          await modifyOrders(menu, widget.classroom.name, orders_aux[menu]!);
        } else {
          Orders order = Orders(date: date, quantity: orders_aux[menu]!, menuName: menu, classroomName: widget.classroom.name);
          await insertObjectOrder(order);
        }
      }
    }
  }

  // //////////////////////////////////////////////////////////////////////////////////////////
  // INTERFAZ DE REALIZCIÓN DE COMANDAS
  // //////////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Stack(
        children: [
          Center(
            child: buildMainContainer(
              740,
              625,
              EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 15),
                  Text(
                    'Comandas Clase: $widget.classroom.name',
                    style: titleTextStyle,
                  ),
                  SizedBox(height: 15),
                  // Lista de menús en un Expanded para que sea scrollable
                  Expanded(
                    child: ListView.builder(
                      itemCount: menus.length,
                      itemBuilder: (context, index) {
                        Menu menu = menus[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 4.0), // Reduce el espacio vertical entre las tarjetas
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Imagen con recuadro
                                Container(
                                  width: 80, // Tamaño de la imagen aumentado
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8), // Esquinas redondeadas
                                    border: Border.all(
                                      color: Colors.grey.shade300, // Color del borde
                                      width: 2, // Grosor del borde
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage(images[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10), // Espaciado entre la imagen y el texto
                                // Información del menú con tamaño de texto aumentado
                                Expanded(
                                  child: Text(
                                    '${menu.name}',
                                    style: TextStyle(
                                      fontSize: 36, // Tamaño mucho mayor del texto
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // Puedes ajustar el color si lo deseas
                                    ),
                                  ),
                                ),
                                // Controles de cantidad
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Botón de remover 
                                    Container(
                                      width: 50, 
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle, 
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.remove, color: Colors.white),
                                        iconSize: 30, 
                                        onPressed: () {
                                          setState(() {
                                            removeMenuCuantity(menu.name);
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    // Contador
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 31, vertical: 20.5), 
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 2, // Grosor del borde
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${orders_aux[menu.name]}',
                                        style: TextStyle(fontSize: 24), // Aumenta el tamaño de la fuente del contador
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    // Pictograma de números
                                    Container(
                                      width: 80, // Tamaño de la imagen adicional
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8), // Esquinas redondeadas
                                        border: Border.all(
                                          color: Colors.grey, // Color del borde
                                          width: 2, // Grosor del borde
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(path + (orders_aux[menu.name]?.toString() ?? '0') + '.png'), 
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    // Botón de agregar 
                                    Container(
                                      width: 50, 
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle, // Forma redonda
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.add, color: Colors.white),
                                        iconSize: 30, // Aumenta el tamaño del icono
                                        onPressed: () {
                                          setState(() {
                                            addMenuQuantity(menu.name);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Botones de Atrás y Terminar con flechas y texto blanco
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 255, 168, 37),
                            minimumSize: Size(160, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_back, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Atrás',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            createOrders(orders_aux);
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FinishedTask(student: widget.student),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(160, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Terminar',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
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




// //////////////////////////////////////////////////////////////////////////////////////////
  // INTERFAZ DE ORDEN TERMINADA
// //////////////////////////////////////////////////////////////////////////////////////////
class FinishedOrder extends StatefulWidget{
 final Student student;
 final Classroom classroom;
  const
 FinishedOrder({required this.student, required this.classroom}); 

  @override
  _FinishedOrderState createState() => _FinishedOrderState();
}


class _FinishedOrderState extends State<FinishedOrder> {
  @override
  void initState() {
    super.initState();
  }
 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.lightBlueAccent.shade100, // Fondo azul claro
        body: Stack(
          children: [
            Center(
              child: buildMainContainer(
                740, // Ancho del contenedor
                625, // Alto del contenedor
                EdgeInsets.all(20), // Margen interno
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16), // Márgenes alrededor del texto
                      child: (widget.student.interfaceIMG == 1 || widget.student.interfacePIC == 1)
                          ? Image(
                              image: AssetImage("assets/tareas/terminada.png"),
                            )
                          : Text(
                              '¡Comanda de la Clase ${widget.classroom.name} terminada!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                    ),
                    SizedBox(height: 60), // Espaciado adicional
                    Center( // Asegura que el botón esté centrado horizontalmente
                      child: ElevatedButton(
                        onPressed: () async {
                          print(widget.classroom.task_completed);
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClassSelection(student: widget.student),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Bordes redondeados
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del botón al contenido
                          children: [
                            Text(
                              'Seguir',
                              style: TextStyle(
                                color: Colors.white, // Letras en blanco
                                fontSize: 24, // Tamaño más grande
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10), // Espaciado entre texto e ícono
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white, // Ícono en blanco
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            avatarTopCorner(widget.student), // Muestra el avatar en la esquina superior
          ],
        ),
      ),
    );
  }
}

class FinishedTask extends StatefulWidget{
 final Student student;
  const
 FinishedTask({required this.student}); 

  @override
  _FinishedTaskState createState() => _FinishedTaskState();
}


class _FinishedTaskState extends State<FinishedTask> {
  @override
  void initState() {
    super.initState();
  }
 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.lightBlueAccent.shade100, // Fondo azul claro
        body: Stack(
          children: [
            Center(
              child: buildMainContainer(
                740, // Ancho del contenedor
                625, // Alto del contenedor
                EdgeInsets.all(20), // Margen interno
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16), // Márgenes alrededor del texto
                      child: (widget.student.interfaceIMG == 1 || widget.student.interfacePIC == 1)
                          ? Image(
                              image: AssetImage("assets/tareas/terminada.png"),
                            )
                          : Text(
                              '¡Tarea terminada!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                    ),
                    SizedBox(height: 60), // Espaciado adicional
                    Center( // Asegura que el botón esté centrado horizontalmente
                      child: ElevatedButton(
                        onPressed: () async {
                          // TOMATE marcar como completada la tarea del comedor del alumno
                          // PORQUE NO FUNCIONA?
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => hu9.StudentInterfacePage(student: widget.student),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Bordes redondeados
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del botón al contenido
                          children: [
                            Text(
                              'Seguir',
                              style: TextStyle(
                                color: Colors.white, // Letras en blanco
                                fontSize: 24, // Tamaño más grande
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10), // Espaciado entre texto e ícono
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white, // Ícono en blanco
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            avatarTopCorner(widget.student), // Muestra el avatar en la esquina superior
          ],
        ),
      ),
    );
  }
}
