import 'package:flutter/material.dart';
import 'package:proyecto/interfaces/interface_utils.dart';
import 'package:proyecto/bd_utils.dart';

import 'package:proyecto/classes/Task.dart';
import 'package:proyecto/classes/Student.dart';

import 'package:proyecto/interfaces/hu6.dart' as hu6;
import 'package:proyecto/interfaces/hu3.dart' as hu3;

import '../classes/Execute.dart';

/// PAGINA PRINCIPAL DEL ESTUDIANTE ///
/// HU9: Como estudiante quiero ver las tareas que tengo pendientes de hacer.
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
      title: 'Tareas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: StudentInterfacePage(student: student),
    );
  }
}

// Página de lista de estudiantes
class StudentInterfacePage extends StatefulWidget {
  final Student student;
  StudentInterfacePage({required this.student});
  @override
  _StudentInterfacePageState createState() => _StudentInterfacePageState();
}

class _StudentInterfacePageState extends State<StudentInterfacePage> {

  List<Execute> executes = [];
  List<Task> tasks = [];
  

  @override
  void initState() {
    super.initState();
    loadStudentsTasks();
  }

  Future<void> loadStudentsTasks() async {
    setState(() {});
    executes = await getStudentToDo(widget.student.user);
    for (var execute in executes) {
      Task? task = await getTask(execute.task_id);
      if (task != null) {
        tasks.add(task);
      }
    }
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
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment, size: 30, color: Colors.blue), // Icono de "Tareas"
                    SizedBox(width: 10),
                    Text(
                      'Tareas',
                      style: TextStyle(
                        fontSize: 30, // Título más grande
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                // Lista de tarjetas con solo imágenes y texto
                Expanded(
                  child: ListView.builder(
                    itemCount: executes.length,
                    itemBuilder: (context, index) {
                      final item = executes[index];
                      final task = tasks[index];
                      return Column(
                        children: [
                          Row(
                            children: [
                              if(widget.student.interfaceTXT == 1)
                              Text( '${index + 1}',
                                style: titleTextStyle
                              )
                              else if(widget.student.interfaceIMG == 1 || widget.student.interfacePIC == 1)
                              Image.asset(
                                'assets/numeros/${index + 1}.png',// Comienza desde el número 3
                                width: 80,
                                height: 80,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          if (task.id == 1) {
                                            return hu6.ClassSelection(student: widget.student);
                                          } else {
                                            print("por implementar jaja");
                                            return Container(); // Return an empty container or another widget
                                          }
                                        },
                                      ),
                                    );
                                  },
                                  child: Card(
                                    margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              if(widget.student.interfaceTXT == 1)
                                              Text(
                                                task.name,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              Text(
                                                item.date,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              if(widget.student.interfaceIMG == 1 || widget.student.interfacePIC == 1)
                                              Image.asset(
                                                task.image,
                                                width: 60,
                                                height: 60,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // ESTO ES SOLO PARA PRUEBAS
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 400,
                    child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => hu3.StudentLoginPage(),
                          ),
                        );
                      }),
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
