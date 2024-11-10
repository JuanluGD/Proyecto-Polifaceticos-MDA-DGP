import 'package:flutter/material.dart';
import 'dart:io';

import 'ImgCode.dart';
import 'image_utils.dart';

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
            child: Image.asset(
              element.path,
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
                      color: Colors.blue,
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

// ESTILOS

// Estilo de texto de títulos
TextStyle titleTextStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue);

// Estilo de texto de subtítulos
TextStyle subtitleTextStyle = TextStyle(fontSize: 16, color: Colors.blueAccent);

// Estilo de texto de botones
TextStyle buttonTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16);

// Estilo de texto de indicadores
TextStyle hintTextStyle = TextStyle(fontWeight: FontWeight.bold, color: Colors.black54);

// Estilo de botones para continuar
ButtonStyle nextButtonStyle = ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: EdgeInsets.symmetric(vertical: 24.0));

// Estilo de botones para volver
ButtonStyle returnButtonStyle = ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange[400], padding: EdgeInsets.symmetric(vertical: 24.0));

