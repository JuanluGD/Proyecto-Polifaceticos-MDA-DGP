import 'package:flutter/material.dart';
import 'package:proyecto/classes/Task.dart';
import 'package:proyecto/interfaces/interface_utils.dart';
import 'package:proyecto/image_utils.dart';
import 'package:proyecto/bd_utils.dart';

import 'hu2.dart' as hu2;


/// CREAR TAREAS ///
/// HU6: Como administrador quiero poder asignar a un estudiante la tarea de tomar las comandas para el menú del comedor.
/// HU10: Como administrador quiero poder acceder al historial de actividades realizadas de los estudiantes.
/// HU13: Como administrador quiero poder asignar a un estudiante la tarea de realizar el inventario.
/// HU14: Como administrador quiero poder asignar a un estudiante la tarea de repartir el material.
/// 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tareas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: TaskListPage(),
    );
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ DE LISTA DE TAREAS DISPONIBLES
// //////////////////////////////////////////////////////////////////////////////////////////
class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late List<Task> tasks = [];

  Future<void> _loadTasks() async {
    setState(() {});
    tasks.addAll(await getAllTasks());
    setState(() {});
  }


  Future<void> deleteTaskInterface(String name) async {
    await deleteTask(name);
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
          buildCustomList(items: tasks, title: "Lista de tareas", addButton: true, nextPage: hu2.StudentRegistrationPage(), context: context,
          buildChildren: (context, item, index) { 
            return [
              IconButton(
              icon: Icon(Icons.info_outline),
              color: Colors.blue,
              onPressed:
                // Navegar a la página de información del estudiante
                () async {
                  /*await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskInfoPage(task: item),
                    ),
                  );
                  */
                  print("no esta implementado jaja");
                  setState(() {});
                },
              ),
              IconButton(
                icon: Icon(Icons.edit),
                color: Colors.blue,
                onPressed:
                  // Navegar a la página de modificación del estudiante
                  () async {
                    /*
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskModificationPage(tarea: item),
                      ),
                    );*/
                    print("no esta implementado jaja");
                    setState(() {});
                  },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.blue,
                onPressed:
                  () async {
                    await deleteTaskInterface(item.name);
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
// INTERFAZ DE INFORMACIÓN DE TAREAS PROVISIONAL
// //////////////////////////////////////////////////////////////////////////////////////////