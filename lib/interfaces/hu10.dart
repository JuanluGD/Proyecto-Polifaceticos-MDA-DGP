import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proyecto/classes/Execute.dart';
import 'package:proyecto/classes/Task.dart';
import 'package:proyecto/interfaces/interface_utils.dart';
import 'package:proyecto/bd_utils.dart';

import '../classes/Student.dart';
import 'hu7.dart' as hu7;
/// CREAR TAREAS ///
/// HU6: Como administrador quiero poder asignar a un estudiante la tarea de tomar las comandas para el menú del comedor.
/// HU10: Como administrador quiero poder acceder al historial de actividades realizadas de los estudiantes.
/// 

Future<void> main() async {
  Student student = (await getStudent('alissea'))!;
  runApp(MyApp(student: student));
}

class MyApp extends StatelessWidget {
  final Student student;
  const MyApp({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tareas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: StudentHistoryTasksPage(student: student,),
    );
  }
}




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
  final List<Execute> executes = [];
  final List<Task> tasks = [];

  Future<void> _loadTasks() async {
    setState(() {});
    executes.clear();
    tasks.clear();
    executes.addAll(await getStudentExecutes(widget.student.user));

    for (var execute in executes) {
      Task? task = await getTask(execute.task_id);
      if (task != null) {
        tasks.add(task);
      }
    }
    setState(() {});
  }

  Future<void> deleteStudentTask(Execute execute, int index) async {
    await deleteExecute(execute);
    tasks.removeAt(index);
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
                      builder: (context) => hu7.StudentAssignTasksPage(student: widget.student)
                    ),
                  ).then((_) {
                    // Cargar las tareas asignadas cuando se vuelva
                    _loadTasks();
                  });
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
                                await deleteStudentTask(item, index);
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
                  child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () {
                      Navigator.pop(context);
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