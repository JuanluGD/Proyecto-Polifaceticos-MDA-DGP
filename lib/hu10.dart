import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:proyecto/interfaces/interface_utils.dart';
import 'package:proyecto/image_utils.dart';
import 'package:proyecto/bd_utils.dart';

import 'package:proyecto/classes/ImgCode.dart';
import 'package:proyecto/classes/Student.dart';


/// CREAR TAREAS ///
/// HU7: Como administrador quiero poder eliminar una tarea de la lista de tareas pendientes de un estudiante.
/// HU6: Como administrador quiero poder asignar a un estudiante la tarea de tomar las comandas para el menú del comedor.
/// HU10: Como administrador quiero poder acceder al historial de actividades realizadas de los estudiantes.
/// HU13: Como administrador quiero poder asignar a un estudiante la tarea de realizar el inventario.
/// HU14: Como administrador quiero poder asignar a un estudiante la tarea de repartir el material.