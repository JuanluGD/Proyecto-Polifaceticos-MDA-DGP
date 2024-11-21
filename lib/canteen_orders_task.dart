import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'interface_utils.dart';
import 'image_utils.dart';
import 'bd_utils.dart';
import 'image_management.dart';

import 'ImgCode.dart';
import 'Student.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Comandas',
        // theme: ThemeData(
        //   // useMaterial3: true,
        //   // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        // ),
        // home: ClassSelection(),
        home: ClassSelection(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var classroom_names = ['A', 'B', 'C', 'D', 'F', 'G', 'H']; // Lista de clases
}

class ClassSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

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
                'Comandas',
                style: titleTextStyle,
              ),
              SizedBox(height: 15),
              // Fila de botones para cada clase
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  children: [
                    ...appState.classroom_names.map((className) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              print('Clase ${className} seleccionada');
                            },
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(0, 160, 223, 1),
                                borderRadius: BorderRadius.circular(
                                    8.0), // Bordes redondeados si se desea
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4.0,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'Clase ${className}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ));
                    }).toList(),
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


// class ClassCanteenOrder extends StatelessWidget {


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightBlueAccent.shade100,
//       body: Center(
//         child: buildMainContainer(
//           740,
//           625,
//           EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(height: 15),
//               Text(
//                 'Comanda clase',
//                 style: titleTextStyle,
//               ),
//               SizedBox(height: 15),
//               // Lista de estudiantes en un Expanded para que sea scrollable
//               Expanded(
//                 child: ListView.builder(
//                   // itemCount: students.length,
//                   itemBuilder: (context, index) {
//                     // Student student = students[index];
//                     return Card(
//                       margin: EdgeInsets.symmetric(vertical: 8.0),
//                       child: ListTile(
//                         // leading: CircleAvatar(
//                         // backgroundImage: AssetImage(student.image),
//                         //   radius: 30,
//                         // ),
//                         // title: Text('${student.name} ${student.surname}'),
//                         title: Text('Menu'),
//                         // subtitle: Text(menu.name),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: Icon(Icons.info_outline),
//                               color: Colors.blue,
//                               onPressed: () {},
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.edit),
//                               color: Colors.blue,
//                               onPressed: () {},
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // import 'package:english_words/english_words.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => MyAppState(),
//       child: MaterialApp(
//         title: 'Comandas',
//         // theme: ThemeData(
//         //   // useMaterial3: true,
//         //   // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
//         // ),
//         home: MyHomePage(),
//       ),
//     );
//   }
// }

// class MyAppState extends ChangeNotifier {
//   // var current = WordPair.random();
// }

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();

//     return Scaffold(
//       backgroundColor: Colors.blue,
//       body: Padding(
//         padding: const EdgeInsets.all(30.0), // Margen uniforme de 30 píxeles
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30.0),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0), // Espaciado interno del Card
//             child: Column(
//               children: [
//                 // Título en la parte superior
//                 Text(
//                   'Comandas:',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 // Expande el espacio para centrar la fila de botones
//                 Expanded(
//                   child: Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // Botón de flecha a la izquierda
//                         IconButton(
//                           icon: Icon(Icons.arrow_left),
//                           onPressed: () {
//                             print('Flecha izquierda presionada');
//                           },
//                         ),

//                         // Botones de Clase A, B y C
//                         ElevatedButton(
//                           style: class_button_style,
//                           onPressed: () {
//                             print('Clase A seleccionada');
//                           },
//                           child: Text('Clase A'),
//                         ),
//                         SizedBox(width: 10), // Espacio entre los botones
//                         ElevatedButton(
//                           style: class_button_style,
//                           onPressed: () {
//                             print('Clase B seleccionada');
//                           },
//                           child: Text('Clase B'),
//                         ),
//                         SizedBox(width: 10), // Espacio entre los botones
//                         ElevatedButton(
//                           style: class_button_style,
//                           onPressed: () {
//                             print('Clase C seleccionada');
//                           },
//                           child: Text('Clase C'),
//                         ),

//                         // Botón de flecha a la derecha
//                         IconButton(
//                           icon: Icon(Icons.arrow_right),
//                           onPressed: () {
//                             print('Flecha derecha presionada');
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ButtonStyle class_button_style = ElevatedButton.styleFrom(
//   shape: RoundedRectangleBorder(
//     borderRadius: BorderRadius.circular(20),
//   ),
// );
