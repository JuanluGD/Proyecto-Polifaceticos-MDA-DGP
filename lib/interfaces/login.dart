import 'package:flutter/material.dart';
import 'package:proyecto/bd_utils.dart';
import 'package:proyecto/classes/Student.dart';
import 'package:proyecto/interfaces/interface_utils.dart';
import 'package:proyecto/interfaces/hu1.dart' as hu1;
import 'package:proyecto/interfaces/hu3.dart' as hu3;

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Estudiantes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: StudentListPage(),
    );
  }
}

// Página de lista de estudiantes
class StudentListPage extends StatefulWidget {
  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage>  {
  final List<Student> students = [];

  // TOMATE
  // Para cargar los estudiantes
  Future<void> loadStudents() async {
    if (students.isEmpty) {
      setState(() {});
      students.addAll(await getAllStudents());
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadStudents();
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
                children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                  '¿Quién eres?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  ),
                ),
                  Expanded(
                    child: Padding(
                    padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                        ),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          return GestureDetector(
                            onTap: () async {
                            if (student.typePassword == 'alphanumeric') {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => hu3.LoginAlphanumericPage(student : student),
                                ),
                              );
                            } else {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => hu3.LoginImgCodePage(student : student),
                                ),
                              );
                            }
                          },
                            child: Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image(
                                        image: AssetImage(student.image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 8),
                                Text(
                                  student.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
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
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () async{
                // Acción cuando el texto sea tocado
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => hu1.LoginAdminPage(),
                  ),
                );
                // Aquí puedes agregar la lógica que quieras al hacer clic en el texto
              },
              child: Container(
                margin: EdgeInsets.only(top: 20, right: 20),
                child: Text(
                  'Soy administrador',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 0, 63, 102),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
