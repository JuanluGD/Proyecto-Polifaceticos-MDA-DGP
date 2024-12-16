import 'package:flutter/material.dart';
import 'dart:io';
import 'package:proyecto/interfaces/interface_utils.dart';
import 'package:proyecto/bd_utils.dart';

import 'package:proyecto/classes/Task.dart';
import 'package:proyecto/classes/Student.dart';
import 'package:proyecto/classes/Step.dart' as ownStep;

import 'package:proyecto/interfaces/hu6.dart' as hu6;
import 'package:proyecto/interfaces/hu3.dart' as hu3;

import '../classes/Execute.dart';

/// PÁGINA PRINCIPAL DEL ESTUDIANTE ///
/// HU9: Como estudiante quiero ver las tareas que tengo pendientes de hacer.
/// HU11: Como estudiante quiero poder confirmar la realización de una tarea.

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
      title: 'Tareas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: StudentInterfacePage(student: student),
    );
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////
/// INTERFAZ PRINCIPAL ESTUDIANTE
// //////////////////////////////////////////////////////////////////////////////////////////
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
    executes.clear();
    tasks.clear();
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
                    Icon(Icons.assignment, size: 30, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(
                      'Tareas',
                      style: titleTextStyle,
                    ),
                  ],
                ),
                SizedBox(height: 15),
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
                                'assets/numeros/${index + 1}.png',
                                width: 80,
                                height: 80,
                              ),
                              Expanded(
                                child: buildPickerRegion(
                                  () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          if (task.id == 1) {
                                            return hu6.ClassSelection(student: widget.student);
                                          } else {
                                            return StudentTaskInterfacePage(student:  widget.student, task: task, date: item.date);
                                          }
                                        },
                                      ),
                                    );
                                  }, 
                                  Card(
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
                                  )
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

// //////////////////////////////////////////////////////////////////////////////////////////
/// INTERFAZ DE EJECUCIÓN DE TAREAS
// //////////////////////////////////////////////////////////////////////////////////////////

class StudentTaskInterfacePage extends StatefulWidget {
  final Student student;
  final Task task;
  final String date;
  StudentTaskInterfacePage({required this.student, required this.task, required this.date});
  @override
  _StudentTaskInterfacePageState createState() => _StudentTaskInterfacePageState();
}

class _StudentTaskInterfacePageState extends State<StudentTaskInterfacePage> {
  final List<ownStep.Step> steps = [];

  @override
  void initState() {
    super.initState();
    loadSteps();
  }

  Future<void> loadSteps() async {
    setState(() {});
    steps.clear();
    steps.addAll(await getAllStepsFromTask(widget.task.id));
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
                    'Tarea: ${widget.task.name}',
                    style: titleTextStyle,
                  ),
                  if (widget.student.interfaceIMG == 1) ...[
                    Spacer(),
                    // Imagen
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Image.file(
                        File(widget.task.image),
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                    Spacer(),
                  ],
                  if (widget.student.interfacePIC == 1) ...[
                    Spacer(),
                    // Pictograma
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Image.file(
                        File(widget.task.pictogram),
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                  ],
                  if (widget.student.interfaceTXT == 1) ...[
                    Spacer(),
                    // Descripción
                    Text(
                      widget.task.description == '' ? 'Sin descripción disponible' : widget.task.description,
                      textAlign: TextAlign.center,
                      style: infoTextStyle,
                    ),
                  ],
                  Spacer(),
                  // Botones de navegación
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          width: 200,
                          child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () {
                            setState(() {}); Navigator.pop(context); setState(() {});
                          }),
                        ),
                      ),
                      SizedBox(width: 20),
                      Center(
                        child: SizedBox(
                          width: 200,
                          child: buildElevatedButton('Comenzar', buttonTextStyle, nextButtonStyle, () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentStepInterfacePage(student: widget.student, steps: steps, index: 0, date: widget.date)
                              ),
                            );
                            setState(() {});
                          }),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
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
/// INTERFAZ DE EJECUCIÓN DE PASO
// //////////////////////////////////////////////////////////////////////////////////////////

class StudentStepInterfacePage extends StatefulWidget {
  final Student student;
  final List<ownStep.Step> steps;
  final int index;
  final String date;
  StudentStepInterfacePage({required this.student, required this.steps, required this.index, required this.date});
  @override
  _StudentStepInterfacePageState createState() => _StudentStepInterfacePageState();
}

class _StudentStepInterfacePageState extends State<StudentStepInterfacePage> {
  late int num = widget.steps.length;
  late double progress = num == 1 ? 1 : (widget.index) / (num-1);

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
                    'Paso ${widget.index+1}',
                    style: titleTextStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    ),
                  ),
                  if (widget.student.interfaceIMG == 1) ...[
                    Spacer(),
                    // Imagen
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Image.file(
                        File(widget.steps[widget.index].image),
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                    Spacer(),
                  ],
                  if (widget.student.interfacePIC == 1) ...[
                    Spacer(),
                    // Pictograma
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Image.file(
                        File(widget.steps[widget.index].pictogram),
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                  ],
                  if (widget.student.interfaceTXT == 1) ...[
                    Spacer(),
                    // Descripción
                    Text(
                      widget.steps[widget.index].description == '' ? 'Sin descripción disponible' : widget.steps[widget.index].description,
                      textAlign: TextAlign.center,
                      style: infoTextStyle,
                    ),
                  ],
                  Spacer(),
                  // Botones de navegación
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 25),
                      Center(
                        child: SizedBox(
                          width: 200,
                          child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () {
                            setState(() {}); Navigator.pop(context); setState(() {});
                          }),
                        ),
                      ),
                      SizedBox(width: 20),
                      Center(
                        child: SizedBox(
                          width: 200,
                          child: widget.index < num-1
                            ? buildElevatedButton('Siguiente', buttonTextStyle, nextButtonStyle, () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudentStepInterfacePage(student: widget.student, steps: widget.steps, index: widget.index+1, date: widget.date)
                                ),
                              );
                              setState(() {});
                            })
                            : buildElevatedButton('Terminar', buttonTextStyle, nextButtonStyle, () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FinishedTask(student: widget.student, idTask: widget.steps[widget.index].task_id, date: widget.date),
                                ),
                              );
                              setState(() {});
                            }),
                        ),
                      ),
                    ],
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
/// INTERFAZ DE TAREA TERMINADA
// //////////////////////////////////////////////////////////////////////////////////////////

class FinishedTask extends StatefulWidget{
  final Student student;
  final int idTask;
  final String date;
  const
  FinishedTask({required this.student, required this.idTask, required this.date}); 

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
                    if (widget.student.interfaceTXT == 1) ...[
                      Spacer(),
                      Text(
                        '¡Tarea terminada!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    if (widget.student.interfaceIMG == 1 || widget.student.interfacePIC == 1) ...[
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Image.file(
                          File("assets/tareas/terminar.png"),
                          fit: BoxFit.cover,
                          height: 350,
                        ),
                      ),
                    ],
                    Spacer(), 
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          // TOMATE
                          // Recuperar la ejecución que se ha llevado a cabo
                          Execute? execute = await getExecute(widget.idTask, widget.student.user, widget.date);
                          // Marcar la ejecución como completada
                          await modifyExecuteStatus(execute!, 1);
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentInterfacePage(student: widget.student),
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