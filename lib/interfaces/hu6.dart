import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:proyecto/classes/Classroom.dart';
import 'package:proyecto/classes/Menu.dart';
import 'package:proyecto/classes/Order.dart';
import 'dart:io';

import 'package:proyecto/interfaces/interface_utils.dart';
import 'package:proyecto/bd_utils.dart';
import 'package:proyecto/image_utils.dart';

import 'package:proyecto/classes/Student.dart';

import 'package:proyecto/interfaces/hu9.dart' as hu9;

/// TAREA MENU COMEDOR
/// HU6: Como alumno quiero poder realizar la tarea de comandas
/// 
Future<void> main() async {
  Student student = (await getStudent('alex123'))!;
  runApp(MyApp(student: student));
}

class MyApp extends StatelessWidget {
  final Student student;
  const MyApp({super.key, required this.student});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comandas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MenuList(), //ClassSelection(student: student),
    );
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
  final List<Classroom> classrooms = []; // Clases
  // TOMATE
  // Para cargar las clases
  Future<void> _loadClassrooms() async {
    classrooms.clear();
    setState(() {});
    classrooms.addAll(await getAllClassrooms());
    setState(() {});
  }

  Future<void> markClassAsCompleted(List<Classroom> classrooms) async {
    for(Classroom c in classrooms) {
      await classCompleted(c); // Marcar una clase como completada
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadClassrooms();
    await markClassAsCompleted(classrooms);
    setState(() {});
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 15),
                  Text(
                    'Comandas',
                    style: titleTextStyle,
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: classrooms.length,
                      itemBuilder: (context, index) {
                        Classroom classroom = classrooms[index];
                        return buildPickerRegion(
                          () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommandListPage(classroom: classroom, student: widget.student),
                              ),
                            ).then((_) {
                              // Cargar las clases cuando se vuelva
                              _loadData();
                            });
                          }, 
                          Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    (widget.student.interfaceTXT == 1) ?
                                    Text(
                                      'Clase ${classroom.name}',
                                      style: titleTextStyle
                                    )
                                    : Image.file(
                                        File(classroom.image),
                                        fit: BoxFit.cover,
                                    ),
                                    if (classroom.task_completed) ...[
                                      SizedBox(height: 8.0),
                                      Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.lightBlueAccent.shade100, size: 200.0
                                      ),   
                                    ],
                                  ],
                                ),
                              ]
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                  if(classrooms.every((c) => c.task_completed == true))
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 400,
                      child: buildElevatedButton('Terminar', buttonTextStyle, nextButtonStyle, () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FinishedTask(student: widget.student),
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
          avatarTopCorner(widget.student),
        ],
      ),
    );
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ DE REALIZACIÓN DE COMANDAS
// //////////////////////////////////////////////////////////////////////////////////////////

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
  final List<Order> orders = [];
  final Map<String, int> orders_aux = {};
  final path = 'assets/numeros/';

  final List<String> images = [];

  // Para cargar los menús
  Future<void> loadMenus() async {
    DateTime now = DateTime.now();
    String date = '${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

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

  void removeMenuQuantity(String menuName) {
    if ((orders_aux[menuName] ?? 0) > 0)
      orders_aux[menuName] = (orders_aux[menuName] ?? 0) - 1;
  }

  Future<void> createOrders(Map<String, int> orders_aux) async {
    orders.clear();
    DateTime now = DateTime.now();
    String date = '${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    for (var menu in orders_aux.keys) {
      Order? order = await getOrder(date, widget.classroom.name, menu);
      if (order != null){
        await modifyOrders(menu, widget.classroom.name, orders_aux[menu]!);
      } else {
        Order order = Order(date: date, quantity: orders_aux[menu]!, menuName: menu, classroomName: widget.classroom.name);
        await insertObjectOrder(order);
      }
    }
    widget.classroom.task_completed = true;
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 15),
                  Text(
                    'Comandas Clase: ${widget.classroom.name}',
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
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Imagen con recuadro
                                if (widget.student.interfaceIMG == 1 || widget.student.interfacePIC == 1)
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 2,
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage(images[index]),
                                      fit: BoxFit.cover,
                                    )
                                      
                                  ),
                                ),
                                SizedBox(width: 10),
                                // Información del menú
                                if(widget.student.interfaceTXT == 1)  
                                Expanded(
                                  child: Text(
                                    '${menu.name}',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ), 
                                ),
                                // Controles de cantidad
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Botón de quitar 
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
                                            removeMenuQuantity(menu.name);
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    // Contador
                                    if(widget.student.interfaceTXT == 1)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 31, vertical: 20.5), 
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${orders_aux[menu.name]}',
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    // Pictograma de números
                                    if(widget.student.interfacePIC == 1 || widget.student.interfaceIMG == 1)
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 2,
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
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.add, color: Colors.white),
                                        iconSize: 30,
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
                  // Botones
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
                                builder: (context) => FinishedOrder(student: widget.student, classroom: widget.classroom),
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
        backgroundColor: Colors.lightBlueAccent.shade100,
        body: Stack(
          children: [
            Center(
              child: buildMainContainer(740, 625, EdgeInsets.all(20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: (widget.student.interfaceTXT == 1)
                      ? Text(
                          '¡Comanda de la Clase ${widget.classroom.name} terminada!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Image(
                        image: AssetImage("assets/tareas/terminar.png"),
                      ),
                    ),
                    SizedBox(height: 60),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Seguir',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
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

// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ DE TAREA COMEDOR TERMINADA
// //////////////////////////////////////////////////////////////////////////////////////////

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
        backgroundColor: Colors.lightBlueAccent.shade100,
        body: Stack(
          children: [
            Center(
              child: buildMainContainer(740, 625, EdgeInsets.all(20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: (widget.student.interfaceTXT == 1)
                      ? Text(
                        '¡Tarea terminada!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      : Image(
                          image: AssetImage("assets/tareas/terminar.png"),
                      ),
                    ),
                    SizedBox(height: 60), 
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          // TOMATE marcar como completada la tarea del comedor del alumno
                          await menuTaskCompleted();
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Seguir',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
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

// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ QUE MUESTRA LOS MENUS DISPONIBLES
// //////////////////////////////////////////////////////////////////////////////////////////

class MenuList extends StatefulWidget {

  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList>{
  final List<Menu> menus = [];

  @override
  void initState() {
    super.initState();
    loadMenus();
  }

  Future<void> loadMenus() async {
    menus.clear();
    menus.addAll(await getAllMenus());
    setState(() {});
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: buildMainContainer(740, 625, EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0), 
          buildCustomList(items: menus, title: "Lista de menus", addButton: true, nextPage: MenuRegistration(), context: context,
          buildChildren: (context, item, index) { 
            return [
              IconButton(
                icon: Icon(Icons.task),
                color: Colors.blue,
                onPressed:
                  // Navegar a la página de tareas del estudiante
                  () async {
                    print("no esta implementado jaja"); //TOMATE
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
                      builder: (context) => MenuModification(menu: item),
                    ),
                  );
                  },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.blue,
                onPressed:
                  () async {
                    await deleteMenuInterface(item.name);
                    setState((){
                      menus.removeAt(index);
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
  
  deleteMenuInterface(name) async{
    await deleteMenu(name);
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ DE REGISTRAR MENÚ
// //////////////////////////////////////////////////////////////////////////////////////////

class MenuRegistration extends StatefulWidget {
  const MenuRegistration({super.key});

  @override
  _MenuRegistration createState() =>
      _MenuRegistration();
}

class _MenuRegistration extends State<MenuRegistration> {
  // Para almacenar las imágenes que se suban
  File? imagePIC, imageIMG;

  // CONTROLADORES PARA TRABAJAR CON LOS CAMPOS
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: buildMainContainer(740, 650, EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título
              Text('Crear un Menú', style: titleTextStyle),
              Text('Ingresa los datos del menú', style: subtitleTextStyle),
              SizedBox(height: 40),
              // Campo de nombre
              buildTextField('Nombre*', nameController),
              SizedBox(height: 20),
              // Campos de imagen y pictograma
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del menú
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Imagen del menú*', style: hintTextStyle),
                        SizedBox(height: 10),
                        buildPickerRegion(
                          () async {
                            final pickedImage = await pickImage();
                            if (pickedImage != null) {
                              setState(() {
                                imageIMG = pickedImage;
                              });
                            }
                          },
                          buildPickerContainer(300, Icons.cloud_upload, 'Sube una imagen', BoxFit.contain, imageIMG),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  // Pictograma del menú
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pictograma del menú*', style: hintTextStyle),
                        SizedBox(height: 10),
                        buildPickerRegion(
                          () async {
                            final pickedImage = await pickImage();
                            if (pickedImage != null) {
                              setState(() {
                                imagePIC = pickedImage;
                              });
                            }
                          },
                          buildPickerContainer(300, Icons.cloud_upload, 'Sube un pictograma', BoxFit.contain, imagePIC),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              // Botones de navegación
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: buildElevatedButton('Guardar', buttonTextStyle, nextButtonStyle, () async {
                        String nameMenu = nameController.text;
                        if (!(await menuIsValid(nameMenu))) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Ya hay un menú registrado con ese nombre.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          if (imagePIC != null && imageIMG != null) {
                            // Obtener la extensión del archivo original
                            String extensionIMG = path.extension(imageIMG!.path);
                            String extensionPIC = path.extension(imagePIC!.path);

                            // Sustituir los espacios
                            String name = removeSpacing(nameMenu);

                            // TOMATE
                            // Meter el menú en la BD
                            if (await insertMenu(
                              nameMenu, 'assets/picto_menu/$name$extensionPIC', 'assets/imgs_menu/$name$extensionIMG'
                            )) 
                            {
                              // Guardar las imágenes en las carpetas
                              await saveImage(imageIMG!, '$name$extensionIMG', 'assets/imgs_menu');
                              await saveImage(imagePIC!, '$name$extensionPIC', 'assets/picto_menu');

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Menú creado con éxito.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                      
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) => MenuList(),
                              ),
                            );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Para crear un menú hay que introducir tanto una imagen como un pictograma.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }),
                    ),
                  ),
                  SizedBox(width: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () async {
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
// INTERFAZ DE MODIFICAR MENÚ
// //////////////////////////////////////////////////////////////////////////////////////////

class MenuModification extends StatefulWidget {
  final Menu menu; // Recibir el menú seleccionado
  
  MenuModification({required this.menu});

  @override
  _MenuModification createState() =>
      _MenuModification();
}

class _MenuModification extends State<MenuModification> {
  // Para comprobar si se ha cambiado el nombre
  late String nameMenu;

  // Para almacenar las imágenes que se suban
  File? imagePIC, imageIMG;

  // Controladores para los campos de texto
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializar los campos con los datos del menú
    nameMenu = widget.menu.name;
    nameController.text = widget.menu.name;
    imagePIC = File(widget.menu.pictogram);
    imageIMG = File(widget.menu.image);
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
              // Título
              Text('Modificar un Menú', style: titleTextStyle),
              Text('Modifica los datos del menú', style: subtitleTextStyle),
              SizedBox(height: 40),
               // Campo de nombre
              buildTextField('Nombre*', nameController),
              SizedBox(height: 20),
              // Campos de imagen y pictograma
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del menú
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Imagen del menú*', style: hintTextStyle),
                        SizedBox(height: 10),
                        buildPickerRegion(
                          () async {
                            final pickedImage = await pickImage();
                            if (pickedImage != null) {
                              setState(() {
                                imageIMG = pickedImage;
                              });
                            }
                          },
                          buildPickerContainer(300, Icons.cloud_upload, 'Sube una imagen', BoxFit.contain, imageIMG),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  // Pictograma del menú
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pictograma del menú*', style: hintTextStyle),
                        SizedBox(height: 10),
                        buildPickerRegion(
                          () async {
                            final pickedImage = await pickImage();
                            if (pickedImage != null) {
                              setState(() {
                                imagePIC = pickedImage;
                              });
                            }
                          },
                          buildPickerContainer(300, Icons.cloud_upload, 'Sube un pictograma', BoxFit.contain, imagePIC),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              // Botones de navegación
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: buildElevatedButton('Guardar', buttonTextStyle, nextButtonStyle, () async {
                        String newNameMenu = nameController.text;
                        if (newNameMenu != nameMenu) {
                          if (!(await menuIsValid(newNameMenu))) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Ya hay un menú registrado con ese nombre.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          else {
                            // Obtener la extensión del archivo original
                            String extensionIMG = path.extension(imageIMG!.path);
                            String extensionPIC = path.extension(imagePIC!.path);

                            // Sustituir los espacios
                            String name = removeSpacing(newNameMenu);

                            // TOMATE
                            await modifyCompleteMenu(nameMenu, newNameMenu, 'assets/picto_menu/$name$extensionPIC', 'assets/imgs_menu/$name$extensionIMG');

                            // Guardar las imágenes en las carpetas
                            await saveImage(imageIMG!, '$name$extensionIMG', 'assets/imgs_menu');
                            await saveImage(imagePIC!, '$name$extensionPIC', 'assets/picto_menu');

                            // TODO: estaria bien que las imágenes anteriores se borrasen de la carpeta (se llaman como el menú anterior, con la extensión anterior)

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Menú modificado con éxito.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                    
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                              builder: (context) => MenuList(),
                            ),
                          );
                          }
                        } else {
                          // Obtener la extensión del archivo original
                          String extensionIMG = path.extension(imageIMG!.path);
                          String extensionPIC = path.extension(imagePIC!.path);

                          // Sustituir los espacios
                          String name = removeSpacing(newNameMenu);

                          // TOMATE
                          modifyMenuPictogram(name, 'assets/picto_menu/$name$extensionPIC');
                          modifyMenuImage(name, 'assets/imgs_menu/$name$extensionIMG');

                          // Guardar las imágenes en las carpetas
                          await saveImage(imageIMG!, '$name$extensionIMG', 'assets/imgs_menu');
                          await saveImage(imagePIC!, '$name$extensionPIC', 'assets/picto_menu');

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Menú modificado con éxito.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                  
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => MenuList(),
                          ),
                        );
                        }
                      }),
                    ),
                  ),
                  SizedBox(width: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () async {
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