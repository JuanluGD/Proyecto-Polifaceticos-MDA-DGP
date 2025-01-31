import 'package:flutter/material.dart';
import 'package:proyecto/classes/Student.dart';
import 'package:proyecto/classes/Task.dart';
import 'dart:io';

import '../classes/ImgCode.dart';
import '../image_utils.dart';

import"hu1.dart" as hu1;

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

// Crear campo de texto básico
Widget buildTextField(String labelText, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(),
    ),
  );
}

// Crear área de texto básica
Widget buildAreaField(String labelText, int lines, TextEditingController controller) {
  return TextField(
    controller: controller,
    maxLines: lines,
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(),
    ),
  );
}

// Crear campo de texto relleno
Widget buildFilledTextField(String labelText, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.grey[200],
    ),
  );
}

// Crear campo de contraseña
Widget buildPasswdTextField(String labelText, TextEditingController controller, bool obscure, VoidCallback onPressed) {
  return TextField(
    controller: controller,
    obscureText: obscure,
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.grey[200],
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: onPressed
      ),
    ),
  );
}

// Crear campo de búsqueda
Widget buildSearchField(String text, Function(String) onChanged) {
  return TextField(
    decoration: InputDecoration(
      hintText: text,
      hintStyle: TextStyle(color: Colors.grey[600]),
      filled: true,
      fillColor: Color.fromARGB(255, 247, 242, 250),
      suffixIcon: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Icon(Icons.search),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.0),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.0),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.0),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    ),
    onChanged: onChanged,
    style: TextStyle(color: Colors.black),
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

// Crear botón adaptado a la interfaz del estudiante
Widget buildStudentElevatedButton(Student student, String text, IconData icon, Color? color, bool firstText, double width, VoidCallback onPressed) {
  return Center(
    child: SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: color, padding: EdgeInsets.symmetric(vertical: 24.0)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (firstText)... [
              if (student.interfaceTXT == 1)
                Text(
                  text,
                  style: buttonTextStyle,
                ),
              SizedBox(width: 10),
              if (student.interfaceIMG == 1 || student.interfacePIC == 1)
                Icon(
                  icon,
                  color: Colors.white,
                ),
            ]
            else... [
              if (student.interfaceIMG == 1 || student.interfacePIC == 1)
                Icon(
                  icon,
                  color: Colors.white,
                ),
              SizedBox(width: 10),
              if (student.interfaceTXT == 1)
                Text(
                  text,
                  style: buttonTextStyle,
                ),
            ]
          ],
        ),
      ),
    ),
  );
}

// Crear botón de iconos
Widget buildIconButton(String tip, Color background, Color iconColor, IconData icon, VoidCallback onPressed) {
  return Tooltip(
    message: tip,
    child: Container(
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: iconColor,
        ),
        onPressed: onPressed,
      ),
    ),
  );
}

// Crear botón de selección
Widget buildPickerButton(String text, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: extraButtonStyle,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 8),
        Text(
          text,
          style: buttonTextStyle,
        ),
        Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
          size: 30,
        ),
      ],
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

// Crear opción para pick
Widget buildOption({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return buildPickerRegion(onTap, 
    Column(
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

// Crear card para pick
Widget buildPickerCard(double height, IconData icon, double size) {
  return Container(
    height: height,
    width: double.infinity,
    decoration: BoxDecoration(
      color:Color.fromARGB(255, 247, 242, 250),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(0, 1),
          blurRadius: 1,
        ),
      ],
    ),
    child: Center(
      child: Icon(
        icon,
        size: size,
        color: Colors.grey,
      ),
    ),
  );
}

// Crear un grid de elementos
Widget buildGrid(int columns, double spacing, List<ImgCode> elements) {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: columns,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
    ),
    itemCount: elements.length,
    itemBuilder: (context, index) {
      final element = elements[index];
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Image.file(
                File(element.path),
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      );
    },
  );
}

// Crear un grid de navegación de estudiantes
Widget navigationGrid(int columns, double spacing, List<Student> elements, Function(Student) onTap) {
  return Expanded(
      child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: elements.length,
      itemBuilder: (context, index) {
        final student = elements[index];
        return buildPickerRegion(
          () => onTap(student),
          Card(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(student.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  student.name,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
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
Widget buildTickGrid(int columns, double spacing, List<ImgCode> allElements, List<ImgCode> selectionElements, int max, BuildContext context, VoidCallback onSelection) {
  return GridView.count(
    crossAxisCount: columns,
    crossAxisSpacing: spacing,
    mainAxisSpacing: spacing,
    children: allElements.map((element) {
      final isSelected = selectionElements.contains(element);
      return buildPickerRegion(
        () {
          toggleSelection(selectionElements, element, max, context, onSelection);
          // Actualizar el estado
          (context as Element).markNeedsBuild();
        },
        buildToggleContainer(isSelected, element, selectionElements, false),
      );
    }).toList(),
  );
}
Widget buildSizedIconTickGrid(int columns, double spacing, double size, List<ImgCode> allElements, List<ImgCode> selectionElements, int max, BuildContext context, VoidCallback onSelection) {
  return GridView.count(
    crossAxisCount: columns,
    crossAxisSpacing: spacing,
    mainAxisSpacing: spacing,
    children: allElements.map((element) {
      final isSelected = selectionElements.contains(element);
      return buildPickerRegion(
        () {
          toggleSelection(selectionElements, element, max, context, onSelection);
          // Actualizar el estado
          (context as Element).markNeedsBuild();
        },
        buildSizedIconToggleContainer(size, isSelected, element, selectionElements, false),
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
              right: 4,
              top: 4,
              child: indexView
                  ? buildIndexViewContainer(selectedElements, element)
                  : Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                    ),
            ),
        ],
      ),
    ),
  );
}
Widget buildSizedIconToggleContainer(double size, bool selected, ImgCode element, List<ImgCode> selectedElements, bool indexView) {
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
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: indexView
                  ? buildIndexViewContainer(selectedElements, element)
                  : Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                      size: size,
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

// Crear contenedor con bordes
Widget buildBorderedContainer (Color color, double width, Widget child) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: color,
        width: width
      ),
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: child,
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

// Mostrar el estudiante actual arriba a la derecha
Widget avatarTopCorner(Student student) {
  return Align(
    alignment: Alignment.topRight,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
        margin: EdgeInsets.only(top: 20, right: 20),
        child: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(student.image),
        ),
      ),
        SizedBox(height: 5),
        Padding(
          padding: EdgeInsets.only(right: 15),
          child:  
            Text(
              student.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
        ),
      ],
    ),
  );
}

// Crear listas de objetos
Widget buildCustomList({
  required List<dynamic> items,
  required List<Widget> Function(BuildContext context, dynamic item, int index)? buildChildren,
  required String title,
  required bool addButton,
  Widget? nextPage,
  required BuildContext context,
  bool? circle,
  BoxFit? fit,
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
        buildPickerRegion(
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => nextPage!,
              ),
            );
          },
          buildPickerCard(60, Icons.add, 30),
        ),
        SizedBox(height: 10),
      // Lista en un Expanded para que sea scrollable
      Expanded(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: circle == true
                  ? ClipOval(
                    child: Image.file(
                      File(item.image),
                      fit: fit,
                      width: 50,
                      height: 50,
                    ),
                  )
                  : ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.file(
                      File(item.image),
                      fit: fit,
                      width: 50,
                      height: 50,
                    ),
                  ),
                title: Text('${item.name} ${item is Student ? item.surname ?? '' : ''}'),
                subtitle: item is Student ? Text(item.user) 
                        : item is Task ? item.description == '' ? Text('Sin descripción') : Text(item.description)
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
          child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => hu1.adminInterface(),
                ),
              );
            }
          ),
        ),
      ),
    ],
  );
}

// ESTILOS

// Estilo de texto de títulos
TextStyle titleTextStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue);

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

// ESTÁNDARES

// Obtener fecha con el formato para la BD
String getBDate(DateTime date) {
    return '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
