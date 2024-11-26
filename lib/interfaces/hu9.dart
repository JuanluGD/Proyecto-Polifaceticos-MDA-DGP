import 'package:flutter/material.dart';
import 'package:proyecto/interfaces/interface_utils.dart';
import 'package:proyecto/bd_utils.dart';

import 'package:proyecto/classes/Task.dart';
import 'package:proyecto/classes/Student.dart';

import 'package:proyecto/interfaces/hu6.dart' as hu6;
import 'package:proyecto/interfaces/hu3.dart' as hu3;

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
                  child: ListView(
                    children: [
                      if(widget.student.diningRoomTask == 1)
                      Row(
                        children: [
                          if(widget.student.interfaceTXT == 1)
                          Text(
                            '1',
                            style: titleTextStyle,
                          )
                          else if(widget.student.interfaceIMG == 1 || widget.student.interfacePIC == 1)
                          Image.asset(
                            'assets/numeros/1.png',
                            width: 80,
                            height: 80,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                // Navegar a la interfaz de "Comandas comedor"
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => hu6.ClassSelection(student: widget.student), // Asegúrate de que esta es la clase correcta
                                  ),
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if(widget.student.interfaceTXT == 1)
                                      Text(
                                        'Comandas comedor',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if(widget.student.interfaceIMG == 1 || widget.student.interfacePIC == 1)
                                      Image.asset(
                                        'assets/imgs_menu/comedor.png',
                                        width: 60,
                                        height: 60,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Cargar tareas dinámicas desde el Future
                      FutureBuilder<List<Task>>(
                        future: getAllTasks(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  'No se pudieron cargar las tareas adicionales.',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  'No hay tareas adicionales disponibles.',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          } else {
                            List<Task> tareas = snapshot.data!;
                            return Column(
                              children: tareas.asMap().entries.map((entry) {
                                int index = entry.key; // Índice de la tarea
                                Task tarea = entry.value; // Tarea actual
                                return Row(
                                  children: [
                                    if(widget.student.interfaceTXT == 1)
                                    Text(
                                      (widget.student.diningRoomTask == 1)
                                      ? '${index + 2}'
                                      : '${index + 1}',
                                      style: titleTextStyle
                                    )
                                    else if(widget.student.interfaceIMG == 1 || widget.student.interfacePIC == 1)
                                    Image.asset(
                                      (widget.student.diningRoomTask == 1)
                                      ?'assets/numeros/${index + 2}.png'
                                      :'assets/numeros/${index + 1}.png',// Comienza desde el número 3
                                      width: 80,
                                      height: 80,
                                    ),
                                    Expanded(
                                      child: Card(
                                        margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              if(widget.student.interfaceTXT == 1)
                                              Text(
                                                tarea.name,
                                                style: TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if(widget.student.interfaceIMG == 1 || widget.student.interfacePIC == 1)
                                              Image.asset(
                                                tarea.image,
                                                width: 60,
                                                height: 60,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ],
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
