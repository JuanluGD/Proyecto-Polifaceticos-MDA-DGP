import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:proyecto/classes/Menu.dart';
import 'package:proyecto/classes/Classroom.dart';
import 'package:proyecto/classes/Orders.dart';
import 'package:proyecto/classes/Student.dart';

import 'package:proyecto/interfaces/interface_utils.dart';
import 'package:proyecto/image_utils.dart';
import 'package:proyecto/bd_utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comandas de la clase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: (CommandListPage()),
    );
  }
}

// Página de lista de comandas
class CommandListPage extends StatefulWidget {
  final String className;
  final Student student;

  CommandListPage({
    required this.className,
    required this.student
    });
  @override
  _CommandListPageState createState() => _CommandListPageState(className: className, student: student);
}

class _CommandListPageState extends State<CommandListPage> {
  final List<Menu> menus = [];
  final List<Orders> orders = [];
  final String className;
  final Student student;
  final Map<String, int> orders_aux = {};
  final path = 'assets/picto_numeros/';

  _CommandListPageState({
    required this.className,
    required this.student
  });

  // Para cargar los menús.
  Future<void> loadMenus() async {
    if (menus.isEmpty) {
      setState(() {});
      menus.addAll(await getAllMenus());
      for (var menu in menus) {
        orders_aux.addAll({menu.name: 0});
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadMenus();
  }

  void addMenuCuantity(String menuName) {
    if ((orders_aux[menuName] ?? 0) < 8) 
      orders_aux[menuName] = (orders_aux[menuName] ?? 0) + 1;
    
  }

  void removeMenuCuantity(String menuName) {
    if ((orders_aux[menuName] ?? 0) > 0)
      orders_aux[menuName] = (orders_aux[menuName] ?? 0) - 1;
  }

  void createOrders(Map<String, int> orders_aux) async {
    orders.clear();
    for (var menu in orders_aux.keys) {
      if (orders_aux[menu]! > 0) {
        orders.add(Orders(date: DateTime.now().toString(), quantity: orders_aux[menu]!, menuName: menu, classroomName: className));
      }
    }

    await insertListOrders(orders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: buildMainContainer(
          740,
          625,
          EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15),
              Text(
                'Comandas Clase: $className',
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
                                  image: AssetImage(menu.image),
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
                                        addMenuCuantity(menu.name);
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
                        // Acción del botón Atrás
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
                      onPressed: () {
                        createOrders(orders_aux);
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
    );
  }
}
