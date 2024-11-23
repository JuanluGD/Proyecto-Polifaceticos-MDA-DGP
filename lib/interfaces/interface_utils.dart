import 'package:flutter/material.dart';
import 'package:proyecto/classes/Student.dart';
import 'package:proyecto/classes/Task.dart';
import 'dart:io';

import '../classes/ImgCode.dart';
import '../image_utils.dart';

// FUNCIONES PARA CREAR

// Crear el contenedor principal
Widget buildMainContainer(double width, double height, EdgeInsets margin, Widget child) {
  return Container(
    width: width,
    height: height,
    padding: margin,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: child
  );
}

// Crear campo de texto
Widget buildTextField(String labelText, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(),
    ),
  );
}

// Crear campo de contraseña
Widget buildPasswdTextField(String labelText, TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: true,
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(),
    ),
  );
}


// Crear botón con estilos
Widget buildElevatedButton(String text, TextStyle textStyle, ButtonStyle buttonStyle, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: buttonStyle,    
    child: Text(
        text,
        style: textStyle,
      ),
  );
}

// Crear región para pick
Widget buildPickerRegion(VoidCallback onTap, Widget child) {
  return GestureDetector(
    onTap: onTap,
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: child,
    ),
  );
}

// Crear contenedor para pick
Widget buildPickerContainer(double height, IconData icon, String text, BoxFit fit, File? image) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8), // Bordes redondeados
    child: Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: image == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 40,
                    color: Colors.grey,
                  ),
                  Text(
                    '$text',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              )
            : Image.file(
                image,
                fit: fit,
                width: double.infinity,
              ),
      ),
    ),
  );
}

// Crear un grid de selección de elementos de la clave, mostrando el orden de selección
Widget buildIndexGrid(int columns, double spacing, List<ImgCode> selectedElements, List<ImgCode> passwordElements, Function(ImgCode) onTap) {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: columns,
      crossAxisSpacing: spacing,  // Espacio entre las columnas
      mainAxisSpacing: spacing,   // Espacio entre las filas
    ),
    itemCount: selectedElements.length,
    itemBuilder: (context, index) {
      final element = selectedElements[index];
      bool isSelected = passwordElements.contains(element); // Verificar si el elemento está en la contraseña

      return buildPickerRegion(
        () => onTap(element),
        buildToggleContainer(isSelected, element, passwordElements, true),
      );
    },
  );
}

// Crear un grid de selección de elementos candidatos para la clave
Widget buildTickGrid(int columns, double spacing, List<ImgCode> allElements, List<ImgCode> selectionElements, int max, BuildContext context) {
  return GridView.count(
    crossAxisCount: columns,
    crossAxisSpacing: spacing,
    mainAxisSpacing: spacing,
    children: allElements.map((element) {
      final isSelected = selectionElements.contains(element);
      return buildPickerRegion(
        () {
          toggleSelection(selectionElements, element, max, context);
          // Actualizar el estado
          (context as Element).markNeedsBuild();
        },
        buildToggleContainer(isSelected, element, selectionElements, false),
      );
    }).toList(),
  );
}

// Crear contenedor para seleccionar elementos de la clave
Widget buildToggleContainer(bool selected, ImgCode element, List<ImgCode> selectedElements, bool indexView) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8), // Bordes redondeados
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: selected ? Colors.blue : Colors.grey,
          width: selected ? 3 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.file(
              File(element.path),
              fit: BoxFit.cover,
            ),
          ),
          if (selected)
            Positioned(
              top: 4,
              right: 4,
              child: indexView
                  ? buildIndexViewContainer(selectedElements, element)
                  : Icon(
                      Icons.check_circle,
                      color: Colors.blue
                    ),
            ),
        ],
      ),
    ),
  );
}

// Crear contenedor de vista de índices de elementos clave seleccionados
Widget buildIndexViewContainer(List<ImgCode> selectedElements, ImgCode element) {
  return Container(
    color: Colors.blue.withOpacity(0.7),
    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    child: Text(
      '${selectedElements.indexOf(element) + 1}', // Mostrar el orden de la contraseña
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  );
}

// Crear elemento de lista con multi-respuesta
Widget buildCheckbox (String text, bool element, bool def, Function(bool) onChanged) {
  return CheckboxListTile(
    title: Text(text),
    value: element,
    onChanged: (bool? value) {
      onChanged(value ?? def);
    },
  );
}
Widget buildSizedCheckbox (String text, double size, bool element, bool def, Function(bool) onChanged) {
  return Row(
    children: [
      Checkbox(
        value: element,
        onChanged: (bool? value) {
          onChanged (value ?? def);
        }
      ),
      SizedBox(width: size),
      Text(
        text,
        style: TextStyle(fontSize: 2*size),
      ),
    ],
  );
}

// Crear elemento de lista con mono-respuesta
Widget buildRadio (String text, String element, String group, String def, Function(String) onChanged) {
  return RadioListTile(
    title: Text(text),
    value: element,
    groupValue: group,
    onChanged: (String? value) {
      onChanged(value ?? def);
    },
  );
}
Widget buildSizedRadio (String text, double size, String element, String group, String def, Function(String) onChanged) {
  return Row(
    children: [
      Radio<String>(
        value: element,
        groupValue: group,
        onChanged: (String? value) {
          onChanged(value ?? def);
        },
      ),
      SizedBox(width: 8),
      Text(
        text,
        style: TextStyle(fontSize: size*2),
      ),
    ],
  );
}

// Muestra el estudiante actual arriba a la derecha
Widget avatarTopCorner(Student student) {
  return Align(
    alignment: Alignment.topRight,
    child: Column(
      children: [
        Container(
        margin: EdgeInsets.only(top: 20, right: 20),
        child: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(student.image),
        ),
      ),
        SizedBox(height: 8),
        Text(
          student.name,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

// crear listas de objetos
Widget buildCustomList({
  required List<dynamic> items,
  required List<Widget> Function(BuildContext context, dynamic item, int index)? buildChildren,
  required String title,
  required bool addButton,
  Widget? nextPage,
  required BuildContext context
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(height: 15),
      Text(
        title,
        style: titleTextStyle,
      ),
      SizedBox(height: 15),
      if (addButton)
        SizedBox(
          height: 70, // Ajusta la altura aquí según lo necesites
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => nextPage!, // Navegar a la página de registro
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Center(
                    child: Icon(Icons.add, size: 30, color: Colors.black26),
                  ),
                ),
              ),
            ),
          ),
        ),
      if(addButton)
        SizedBox(height:0),
      // Lista de estudiantes en un Expanded para que sea scrollable
      Expanded(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(item.image),
                  radius: 30,
                ),
                title: Text('${item.name} ${item is Student ? item.surname ?? '' : ''}'),
                subtitle: item is Student ? Text(item.user) 
                        : item is Task ? Text(item.description)
                        : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: buildChildren != null
                    ? buildChildren(context, item, index) // Usa hijos personalizados
                    : [], // Sin hijos si no se especifica,
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
  );
}

// ESTILOS

// Estilo de texto de títulos
TextStyle titleTextStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue);

// Estilo de texto de subtítulos
TextStyle subtitleTextStyle = TextStyle(fontSize: 16, color: Colors.blueAccent);

// Estilo de texto de botones
TextStyle buttonTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16);

// Estilo de texto de indicadores
TextStyle hintTextStyle = TextStyle(fontWeight: FontWeight.bold, color: Colors.black54);

// Estilo de texto de informadores
TextStyle infoTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

// Estilo de botones para continuar
ButtonStyle nextButtonStyle = ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: EdgeInsets.symmetric(vertical: 24.0));

// Estilo de botones para volver
ButtonStyle returnButtonStyle = ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange[400], padding: EdgeInsets.symmetric(vertical: 24.0));

// Estilo de botones adicionales
ButtonStyle extraButtonStyle = ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue[200], padding: EdgeInsets.symmetric(vertical: 16.0));

