import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:proyecto/classes/Task.dart';
import 'package:proyecto/interfaces/interface_utils.dart';
import 'package:proyecto/bd_utils.dart';

import '../classes/Student.dart';

/// HU7: Como administrador quiero asginar una tarea por pasos a un alumno

void main() async {
  Student? student = await getStudent('alissea');
  runApp(MyApp(student: student!));
}

class MyApp extends StatelessWidget {
  final Student student;

  MyApp({required this.student});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tareas de ${student.name}',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', ''),
      ],
      locale: const Locale('es', ''),
      debugShowCheckedModeBanner: false,
      home: StudentAssignTasksPage(student: student),
    );
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////
// INTERFAZ DE ASIGNACIÓN DE TAREAS A UN ESTUDIANTE
// //////////////////////////////////////////////////////////////////////////////////////////

class StudentAssignTasksPage extends StatefulWidget {
  final Student student;

  StudentAssignTasksPage({required this.student});
  
  @override
  _StudentAssignTasksPageState createState() => _StudentAssignTasksPageState();
}

class _StudentAssignTasksPageState extends State<StudentAssignTasksPage> {
  final List<Task> tasks = [];
  String searchText = ''; // Texto de búsqueda
  DateTime? selectedDate; // Fecha seleccionada
  Task? selected; // Tarea seleccionada
  late ScrollController scroll;

  // Para cargar las tareas coincidentes
  Future<void> _loadTasks(String text) async {
    setState(() {
      searchText = text;
    });
    tasks.clear();
    if (selected == null) tasks.addAll(await searchTasks(text));
    else tasks.add(selected!);
    setState(() {});
  }

  // Para seleccionar la fecha
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      locale: const Locale('es', ''),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
    if (selected!= null && selected!.id == 1) {
      setState(() {
        selectedDate = DateTime.now();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La tarea del comedor solo se puede asignar para hoy.'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    scroll = ScrollController();
    _loadTasks('');
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
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
                'Asignar nueva tarea a ${widget.student.name}',
                style: titleTextStyle,
              ),
              SizedBox(height: 25),
              // Barra de búsqueda
              buildSearchField('Buscar tareas ...', (text) {
                  _loadTasks(text);
                },
              ),
              SizedBox(height: 15),
              // Lista de tareas
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: scroll,
                  child: 
                  ListView.builder(
                    controller: scroll,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Card(
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.file(
                              File(task.image),
                              fit: BoxFit.contain,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(task.name),
                              if (selected != null)...[
                                SizedBox(width: 4),
                                Icon(Icons.check_circle, size: 18),
                              ]
                            ],
                          ),
                          subtitle: Text(task.description != '' ? task.description : 'Sin descripción'),
                          onTap: () {
                            if (selected == null) {
                              selected = task;
                              if (selected!.id == 1) {
                                setState(() {
                                  selectedDate = DateTime.now();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('La tarea del comedor solo se puede asignar para hoy.'),
                                  ),
                                );
                              }
                              print(selected!.id);
                            }
                            else selected = null;
                            _loadTasks('');
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Tarea seleccionada
              if (selected != null) ...[
                SizedBox(height: 15),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Imagen de la tarea seleccionada
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(selected!.image),
                          fit: BoxFit.contain,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      SizedBox(width: 20), 
                      // Flecha
                      Icon(Icons.arrow_forward),
                      SizedBox(width: 20),
                      // Imagen del alumno
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(widget.student.image),
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
              ]
              else
                SizedBox(height: 20),
              // Botón de fecha de finalización
              SizedBox(
                width: 200,
                child: buildPickerButton(
                  selectedDate != null
                  ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                  : 'Fecha de finalización',
                    _pickDate
                ),
              ),
              SizedBox(height: 25),
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
                      child: buildElevatedButton('Guardar', buttonTextStyle, nextButtonStyle, () async {
                        if (selected != null) {
                          if (selectedDate != null) {
                            // TOMATE
                            String date = '${selectedDate!.year.toString()}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';
                            if (await insertExecute(selected!.id, widget.student.user, 0, date)) {
                              print(selected!.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Tarea asignada con éxito.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error al asignar la tarea.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Selecciona la fecha de finalización.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Selecciona la tarea a asignar.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        setState(() {});
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

