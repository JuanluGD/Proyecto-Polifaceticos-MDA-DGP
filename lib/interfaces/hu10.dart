import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proyecto/classes/Execute.dart';
import 'package:proyecto/classes/Task.dart';
import 'package:proyecto/interfaces/interface_utils.dart';
import 'package:proyecto/bd_utils.dart';

import '../classes/Student.dart';
import 'hu2.dart' as hu2;
import 'hu4.dart' as hu4;

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
              if (item.id != 1)
              IconButton(
                icon: Icon(Icons.edit),
                color: Colors.blue,
                onPressed:
                  // Navegar a la página de modificación de la tarea
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
// INTERFAZ DE INFORMACIÓN DE TAREAS
// //////////////////////////////////////////////////////////////////////////////////////////




// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ DE HISTORIAL DE TAREAS DE UN ESTUDIANTE
// //////////////////////////////////////////////////////////////////////////////////////////
class StudentHistoryTasksPage extends StatefulWidget {
  final Student student;

  StudentHistoryTasksPage({required this.student});
  
  @override
  _StudentHistoryTasksPageState createState() => _StudentHistoryTasksPageState();
}

class _StudentHistoryTasksPageState extends State<StudentHistoryTasksPage> {
  late List<Execute> executes = [];
  late List<Task> tasks = [];

  Future<void> _loadTasks() async {
    setState(() {});
    executes.addAll(await getStudentExecutes(widget.student.user));

    for (var execute in executes) {
      Task? task = await getTask(execute.task_id);
      if (task != null) {
        tasks.add(task);
      }
    }
    setState(() {});
  }

  Future<void> deleteStudentExecute(Execute execute) async {
    await deleteExecute(execute);
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15),
              Text(
                'Historial de tareas de ${widget.student.name}',
                style: titleTextStyle,
              ),
              SizedBox(height: 15),
              buildPickerRegion(
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => hu2.StudentRegistrationPage(),
                    ),
                  );
                },
                buildPickerCard(60, Icons.add, 30),
              ),
              SizedBox(height: 10),
              // Lista en un Expanded para que sea scrollable
              Expanded(
                child: ListView.builder(
                  itemCount: executes.length,
                  itemBuilder: (context, index) {
                    final item = executes[index];
                    final task = tasks[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.file(
                            File(task.image),
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        title: Text('${task.name}'),
                        subtitle: Text('Fecha límite: ${item.date}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(item.status == 1 ? 'Completado' : 'Pendiente'), 
                            IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.blue,
                              onPressed: () async {
                                // Navegar a la pagina de modificacion de la fecha de entrega
                                print("por implementar jaja");
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.blue,
                              onPressed: () async {
                                await deleteStudentExecute(item);
                                setState(() {
                                  executes.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                        
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 400,
                  child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => hu4.StudentListPage(),
                        ),
                      );
                    }
                  ),
                ),
              ),
            ],
          ),
        )  
      ),
    );
  }
}