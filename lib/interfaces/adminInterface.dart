import 'package:flutter/material.dart';
import 'hu4.dart' as hu4;

class adminInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.lightBlueAccent.shade100,
        body: Center(
          child: buildMainContainer(
            740,
            650,
            EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            context
          ),
        ),
      ),
    );
  }

  Widget buildMainContainer(double width, double height, EdgeInsets padding, BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOption(
              icon: Icons.group,
              label: 'Listado de alumnos',
              onTap: ()  async{
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => hu4.StudentListPage()),
                );
              },
            ),
            SizedBox(width: 40),
            _buildOption(
              icon: Icons.checklist,
              label: 'Tareas',
              onTap: (){
                print('Tareas seleccionado');
              } ,
            ),
            SizedBox(width: 40),
            _buildOption(
              icon: Icons.restaurant,
              label: 'Menú',
              onTap: () => print('Menú seleccionado'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap, // Agregamos el callback de tap
  }) {
    return GestureDetector(
      onTap: onTap, // Se ejecuta cuando el usuario toca el botón
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(40),
            child: Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

