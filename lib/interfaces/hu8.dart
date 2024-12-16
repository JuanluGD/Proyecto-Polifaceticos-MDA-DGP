import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/painting.dart';

import 'package:proyecto/interfaces/interface_utils.dart';
import 'package:proyecto/image_utils.dart';
import 'package:proyecto/bd_utils.dart';

import 'package:proyecto/classes/Task.dart';
import 'package:proyecto/classes/Step.dart' as ownStep;

/// HU8: Como administrador quiero poder crear una tarea por pasos.
/// HU13: Como administrador quiero poder modificar la información de una tarea.

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creación de Tarea',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      
      home: TaskRegistrationPage(),
    );
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////
/// INTERFAZ DE REGISTRAR TAREA
// //////////////////////////////////////////////////////////////////////////////////////////

class TaskRegistrationPage extends StatefulWidget {
  const TaskRegistrationPage({super.key});

  @override
  _TaskRegistrationPageState createState() =>
      _TaskRegistrationPageState();
}

class _TaskRegistrationPageState extends State<TaskRegistrationPage> {
  // Para almacenar la tarea
  Task? task;

  // Para almacenar los pasos que se vayan añadiendo
  final List<ownStep.Step> steps = [];

  // TOMATE
  // Para cargar los pasos
  Future<void> loadSteps(int idTask) async {
    final pic = pictogram;
    final img = image;

    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();

    pictogram = pic;
    image = img;

    steps.clear();
    setState(() {});
    steps.addAll(await getAllStepsFromTask(idTask));
    steps.sort((a, b) => a.id.compareTo(b.id));
    setState(() {});
  }

  // Para almacenar el pictograma y la imagen que se suban
  File? pictogram;
  File? image;

  // CONTROLADORES PARA TRABAJAR CON LOS CAMPOS
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: buildMainContainer(740, 650, EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0), 
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Creación de tarea por pasos', style: titleTextStyle),
              Text('Ingresa los datos de la tarea', style: subtitleTextStyle),
              SizedBox(height: 30),
              // Formulario
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campos de texto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextField('Nombre*', nameController),
                        SizedBox(height: 20),
                        buildAreaField('Descripción', 3, descriptionController),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  // Pictograma
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pictograma*',
                          style: hintTextStyle,
                        ),
                        SizedBox(height: 10),
                        buildPickerRegion(
                          () async {
                            final pickedImage = await pickImage(); // Seleccionar la imagen
                            if (pickedImage != null) {
                              setState(() {
                                pictogram = pickedImage; // Asignar la imagen seleccionada
                              });
                            }
                          },
                          buildPickerContainer(135, Icons.cloud_upload, 'Sube un pictograma', BoxFit.contain, pictogram),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  // Imagen
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Imagen*',
                          style: hintTextStyle,
                        ),
                        SizedBox(height: 10),
                        buildPickerRegion(
                          () async {
                            final pickedImage = await pickImage(); // Seleccionar la imagen
                            if (pickedImage != null) {
                              setState(() {
                                image = pickedImage; // Asignar la imagen seleccionada
                              });
                            }
                          },
                          buildPickerContainer(135, Icons.cloud_upload, 'Sube una imagen', BoxFit.contain, image),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Pasos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pasos:',
                      style: hintTextStyle,
                    ),
                    SizedBox(height: 10),
                    buildBorderedContainer(Colors.grey, 1,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            buildPickerRegion(
                              () async {
                                if (task == null) {
                                  if (nameController.text.isEmpty || image == null || pictogram == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Es necesario rellenar los campos de nombre, pictograma e imagen para comenzar a crear pasos.'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else {
                                    if (await taskIsValid(nameController.text)) {
                                      // Obtener la extensión del archivo original
                                      String extensionIMG = path.extension(image!.path);
                                      String extensionPIC = path.extension(pictogram!.path);

                                      // Sustituir los espacios
                                      String name = removeSpacing(nameController.text);

                                      // TOMATE
                                      // Tarea temporal para crear los pasos, cuando se guarde habrá que actualizar las imágenes y el nombre por si han cambiado tras crear los pasos
                                      if (await insertTask(nameController.text, descriptionController.text, 'assets/picto_tasks/$name$extensionPIC', 'assets/imgs_tasks/$name$extensionIMG')) {
                                        task = await getTaskByName(nameController.text);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StepRegistrationPage(task: task!)
                                          ),
                                        ).then((_) {
                                          // Cargar los pasos creados cuando se vuelva
                                          loadSteps(task!.id);
                                        });
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('El nombre ya está registrado.'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    }
                                  }
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StepRegistrationPage(task: task!)
                                    ),
                                  ).then((_) {
                                    // Cargar los pasos creados cuando se vuelva
                                    loadSteps(task!.id);
                                  });
                                }
                              },
                              buildPickerCard(60, Icons.add, 30),
                            ),
                            SizedBox(height: 10),
                            // Lista de pasos registrados
                            steps.isEmpty
                              ? Text(
                                'No hay pasos registrados aún.',
                                style: hintTextStyle,
                              )
                              : SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  itemCount: steps.length,
                                  itemBuilder: (context, index) {
                                    final item = steps[index];
                                    return Card(
                                      margin: EdgeInsets.symmetric(vertical: 8.0),
                                      child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: Image.file(
                                            File(item.image),
                                            fit: BoxFit.cover,
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                        title: Text('Paso ${item.id+1}'),
                                        subtitle: Text(item.description != '' ? item.description : 'Sin descripción'),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [ 
                                            IconButton(
                                              icon: Icon(Icons.keyboard_double_arrow_up),
                                              color: Colors.blue,
                                              onPressed: () async {
                                                // Decrementar el número del paso
                                                if (item.id > 0) {
                                                  await decrementStep(item.id, task!.id);
                                                  loadSteps(task!.id);
                                                }
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.keyboard_double_arrow_down),
                                              color: Colors.blue,
                                              onPressed: () async {
                                                // Incrementar el número del paso
                                                if (item.id < steps.length-1) {
                                                  await incrementStep(item.id, task!.id);
                                                  loadSteps(task!.id);
                                                }
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              color: Colors.blue,
                                              onPressed: () async {
                                                // Navegar a la página de modificación del paso
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => StepModificationPage(step: item)
                                                  ),
                                                ).then((_) {
                                                  // Cargar los pasos creados cuando se vuelva
                                                  loadSteps(task!.id);
                                                });
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              color: Colors.blue,
                                              onPressed: () async {
                                                // Eliminar el paso
                                                await deleteStep(item.id, task!.id);
                                                loadSteps(task!.id);
                                              },
                                            ),
                                          ],
                                        ),
                                        
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Botones de navegación
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () async {
                          setState(() {});
                          Navigator.pop(context);
                          if (task != null) await deleteTask(task!.id);
                          setState(() {});
                        }
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: buildElevatedButton('Guardar', buttonTextStyle, nextButtonStyle, () async {
                          // Obtener la extensión del archivo original
                          String extensionIMG = path.extension(image!.path);
                          String extensionPIC = path.extension(pictogram!.path);

                          // Sustituir los espacios
                          String name = removeSpacing(nameController.text);

                          // TOMATE
                          if (task != null && !steps.isEmpty) {
                            if (task!.name != nameController.text) {
                              if (await taskIsValid(name))
                                await modifyTaskName(task!.id, nameController.text);
                              else
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('El nombre ya está registrado.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                            }
                            
                            await modifyTaskPictogram(task!.id, 'assets/picto_tasks/$name$extensionPIC');
                            await modifyTaskImage(task!.id, 'assets/imgs_tasks/$name$extensionIMG');
                            await modifyTaskDescription(task!.id, descriptionController.text);

                            // Guardar las imágenes en las carpetas
                            await saveImage(image!, '$name$extensionIMG', 'assets/imgs_tasks');
                            await saveImage(pictogram!, '$name$extensionPIC', 'assets/picto_tasks');

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Tarea creada con éxito.'),
                                backgroundColor: Colors.green,
                              ),
                            );

                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('La tarea debe tener al menos un paso.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////
/// INTERFAZ DE REGISTRAR PASO
// //////////////////////////////////////////////////////////////////////////////////////////

class StepRegistrationPage extends StatefulWidget {
  final Task task;

  StepRegistrationPage({required this.task});
  @override
  _StepRegistrationPageState createState() =>
      _StepRegistrationPageState();
}

class _StepRegistrationPageState extends State<StepRegistrationPage> {
  // Para almacenar las imágenes que se suban
  File? imagePIC, imageIMG;

  // CONTROLADORES PARA TRABAJAR CON LOS CAMPOS
  final TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: buildMainContainer(740, 650, EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título
              Text('Crear un Paso', style: titleTextStyle),
              Text('Ingresa los datos del paso', style: subtitleTextStyle),
              SizedBox(height: 30),
              // Campo de descripción
              buildAreaField('Descripción', 3, description),
              SizedBox(height: 20),
              // Campos de imagen y pictograma
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del paso
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Imagen del paso*', style: hintTextStyle),
                        SizedBox(height: 10),
                        buildPickerRegion(
                          () async {
                            final pickedImage = await pickImage();
                            if (pickedImage != null) {
                              setState(() {
                                imageIMG = pickedImage;
                              });
                            }
                          },
                          buildPickerContainer(250, Icons.cloud_upload, 'Sube una imagen', BoxFit.contain, imageIMG),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  // Pictograma del paso
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pictograma del paso*', style: hintTextStyle),
                        SizedBox(height: 10),
                        buildPickerRegion(
                          () async {
                            final pickedImage = await pickImage();
                            if (pickedImage != null) {
                              setState(() {
                                imagePIC = pickedImage;
                              });
                            }
                          },
                          buildPickerContainer(250, Icons.cloud_upload, 'Sube un pictograma', BoxFit.contain, imagePIC),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              // Botones de navegación
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () async {
                        setState(() {}); Navigator.pop(context); setState(() {});
                      }),
                    ),
                  ),
                  SizedBox(width: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: buildElevatedButton('Guardar', buttonTextStyle, nextButtonStyle, () async {
                        if (imagePIC != null && imageIMG != null) {
                          // Obtener la extensión del archivo original
                          String extensionIMG = path.extension(imageIMG!.path);
                          String extensionPIC = path.extension(imagePIC!.path);

                          // Número del paso
                          int num = (await getAllStepsFromTask(widget.task.id)).length;
                          // Sustituir los espacios
                          String name = removeSpacing('${widget.task.id} step $num');

                          // TOMATE
                          // Meter el paso en la BD
                          if (await insertStep(
                            widget.task.id, description.text, 'assets/picto_steps/$name$extensionPIC', 'assets/imgs_steps/$name$extensionIMG', ''
                          )) 
                          {
                            // Guardar las imágenes en las carpetas
                            await saveImage(imageIMG!, '$name$extensionIMG', 'assets/imgs_steps');
                            await saveImage(imagePIC!, '$name$extensionPIC', 'assets/picto_steps');

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Paso creado con éxito.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                    
                            Navigator.pop( context);
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Para crear un paso hay que introducir tanto una imagen como un pictograma.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////
/// INTERFAZ DE MODIFICAR PASO
// //////////////////////////////////////////////////////////////////////////////////////////

class StepModificationPage extends StatefulWidget {
  final ownStep.Step step;

  StepModificationPage({required this.step});
  @override
  _StepModificationPageState createState() =>
      _StepModificationPageState();
}

class _StepModificationPageState extends State<StepModificationPage> {
  // Para almacenar las imágenes que se suban y manejar si se han cambiado
  File? imagePIC, imageIMG;
  bool pic = false, img = false;

  // CONTROLADORES PARA TRABAJAR CON LOS CAMPOS
  final TextEditingController description = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializar los campos con los datos del paso
    description.text = widget.step.description;
    imagePIC = File(widget.step.pictogram);
    imageIMG = File(widget.step.image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: buildMainContainer(740, 650, EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título
              Text('Modificar un Paso', style: titleTextStyle),
              Text('Cambia los datos del paso', style: subtitleTextStyle),
              SizedBox(height: 30),
              // Campo de descripción
              buildAreaField('Descripción', 3, description),
              SizedBox(height: 20),
              // Campos de imagen y pictograma
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del paso
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Imagen del paso*', style: hintTextStyle),
                        SizedBox(height: 10),
                        buildPickerRegion(
                          () async {
                            final pickedImage = await pickImage();
                            if (pickedImage != null) {
                              setState(() {
                                imageIMG = pickedImage;
                                img = true;
                              });
                            }
                          },
                          buildPickerContainer(250, Icons.cloud_upload, 'Sube una imagen', BoxFit.contain, imageIMG),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  // Pictograma del paso
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pictograma del paso*', style: hintTextStyle),
                        SizedBox(height: 10),
                        buildPickerRegion(
                          () async {
                            final pickedImage = await pickImage();
                            if (pickedImage != null) {
                              setState(() {
                                imagePIC = pickedImage;
                                pic = true;
                              });
                            }
                          },
                          buildPickerContainer(250, Icons.cloud_upload, 'Sube un pictograma', BoxFit.contain, imagePIC),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              // Botones de navegación
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () async {
                        setState(() {}); Navigator.pop(context); setState(() {});
                      }),
                    ),
                  ),
                  SizedBox(width: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: buildElevatedButton('Guardar', buttonTextStyle, nextButtonStyle, () async {
                        // TOMATE
                        // Cambiar la descripción del paso en la BD
                        await modifyStepDescription(widget.step.id, widget.step.task_id, description.text);
                        
                        if (pic) {
                          // Obtener la extensión del archivo original
                          String extensionPIC = path.extension(imagePIC!.path);
                          // Obtener el nombre
                          String name = getImageName(widget.step.pictogram);
                          // Sobreescribir el pictograma en la carpeta
                          //await deleteImage(widget.step.pictogram);
                          await saveImage(imagePIC!, '$name$extensionPIC', 'assets/picto_steps');
                          // Actualizar la ruta en la BD
                          await modifyStepPictogram(widget.step.id, widget.step.task_id, 'assets/picto_steps/$name$extensionPIC');
                        }

                        if (img) {
                          // Obtener la extensión del archivo original
                          String extensionIMG = path.extension(imageIMG!.path);
                          // Obtener el nombre
                          String name = getImageName(widget.step.image);
                          // Sobreescribir la imagen en la carpeta
                          //await deleteImage(widget.step.image);
                          await saveImage(imageIMG!, '$name$extensionIMG', 'assets/imgs_steps');
                          // Actualizar la ruta en la BD
                          await modifyStepImage(widget.step.id, widget.step.task_id, 'assets/imgs_steps/$name$extensionIMG');
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Paso modificado con éxito.'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        Navigator.pop(context);
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// //////////////////////////////////////////////////////////////////////////////////////////
/// INTERFAZ DE MODIFICAR TAREA
// //////////////////////////////////////////////////////////////////////////////////////////

class TaskModificationPage extends StatefulWidget {
  final Task task;

  TaskModificationPage({required this.task});
  @override
  _TaskModificationPageState createState() =>
      _TaskModificationPageState();
}

class _TaskModificationPageState extends State<TaskModificationPage> {
  // Para almacenar los pasos
  final List<ownStep.Step> steps = [];

  // TOMATE
  // Para cargar los pasos
  Future<void> loadSteps(int idTask) async {
    final pic = pictogram;
    final img = image;

    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();

    pictogram = pic;
    image = img;
    
    steps.clear();
    setState(() {});
    steps.addAll(await getAllStepsFromTask(idTask));
    print(steps);
    setState(() {});
  }

  // Para almacenar el pictograma y la imagen que se suban
  File? pictogram;
  File? image;

  // CONTROLADORES PARA TRABAJAR CON LOS CAMPOS
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializar los campos con los datos de la tarea
    nameController.text = widget.task.name;
    descriptionController.text = widget.task.description;
    pictogram = File(widget.task.pictogram);
    image = File(widget.task.image);
    loadSteps(widget.task.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: buildMainContainer(740, 650, EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0), 
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Modificación de tarea por pasos', style: titleTextStyle),
              Text('Cambia los datos de la tarea', style: subtitleTextStyle),
              SizedBox(height: 30),
              // Formulario
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campos de texto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextField('Nombre*', nameController),
                        SizedBox(height: 20),
                        buildAreaField('Descripción', 3, descriptionController),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  // Pictograma
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pictograma*',
                          style: hintTextStyle,
                        ),
                        SizedBox(height: 10),
                        buildPickerRegion(
                          () async {
                            final pickedImage = await pickImage(); // Seleccionar la imagen
                            if (pickedImage != null) {
                              setState(() {
                                pictogram = pickedImage; // Asignar la imagen seleccionada
                              });
                            }
                          },
                          buildPickerContainer(135, Icons.cloud_upload, 'Sube un pictograma', BoxFit.contain, pictogram),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  // Imagen
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Imagen*',
                          style: hintTextStyle,
                        ),
                        SizedBox(height: 10),
                        buildPickerRegion(
                          () async {
                            final pickedImage = await pickImage(); // Seleccionar la imagen
                            if (pickedImage != null) {
                              setState(() {
                                image = pickedImage; // Asignar la imagen seleccionada
                              });
                            }
                          },
                          buildPickerContainer(135, Icons.cloud_upload, 'Sube una imagen', BoxFit.contain, image),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Pasos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pasos:',
                      style: hintTextStyle,
                    ),
                    SizedBox(height: 10),
                    buildBorderedContainer(Colors.grey, 1,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            buildPickerRegion(
                              () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StepRegistrationPage(task: widget.task)
                                  ),
                                ).then((_) {
                                  // Cargar los pasos creados cuando se vuelva
                                  loadSteps(widget.task.id);
                                });
                                
                              },
                              buildPickerCard(60, Icons.add, 30),
                            ),
                            SizedBox(height: 10),
                            // Lista de pasos registrados
                            steps.isEmpty
                              ? Text(
                                'No hay pasos registrados aún.',
                                style: hintTextStyle,
                              )
                              : SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  itemCount: steps.length,
                                  itemBuilder: (context, index) {
                                    final item = steps[index];
                                    return Card(
                                      margin: EdgeInsets.symmetric(vertical: 8.0),
                                      child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: Image.file(
                                            File(item.image),
                                            fit: BoxFit.cover,
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                        title: Text('Paso ${item.id+1}'),
                                        subtitle: Text(item.description != '' ? item.description : 'Sin descripción'),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.keyboard_double_arrow_up),
                                              color: Colors.blue,
                                              onPressed: () async {
                                                // Decrementar el número del paso
                                                if (item.id > 0) {
                                                  await decrementStep(item.id, widget.task.id);
                                                  loadSteps(widget.task.id);
                                                }
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.keyboard_double_arrow_down),
                                              color: Colors.blue,
                                              onPressed: () async {
                                                // Incrementar el número del paso
                                                if (item.id < steps.length-1) {
                                                  await incrementStep(item.id, widget.task.id);
                                                  loadSteps(widget.task.id);
                                                }
                                              },
                                            ), 
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              color: Colors.blue,
                                              onPressed: () async {
                                                // Navegar a la página de modificación del paso
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => StepModificationPage(step: item)
                                                  ),
                                                ).then((_) {
                                                  // Cargar los pasos creados cuando se vuelva
                                                  loadSteps(widget.task.id);
                                                });
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              color: Colors.blue,
                                              onPressed: () async {
                                                // Eliminar el paso
                                                await deleteStep(item.id, widget.task.id);
                                                loadSteps(widget.task.id);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Botones de navegación
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: buildElevatedButton('Atrás', buttonTextStyle, returnButtonStyle, () async {
                          setState(() {});
                          Navigator.pop(context);
                          setState(() {});
                        }
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: buildElevatedButton('Guardar', buttonTextStyle, nextButtonStyle, () async {
                          // Obtener la extensión del archivo original
                          String extensionIMG = path.extension(image!.path);
                          String extensionPIC = path.extension(pictogram!.path);

                          // Sustituir los espacios
                          String name = removeSpacing(nameController.text);

                          // TOMATE
                          if (!steps.isEmpty) {
                            if (widget.task.name != nameController.text) {
                              if (await taskIsValid(name))
                                await modifyTaskName(widget.task.id, nameController.text);
                              else
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('El nombre ya está registrado.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                            }
                            
                            await modifyTaskPictogram(widget.task.id, 'assets/picto_tasks/$name$extensionPIC');
                            await modifyTaskImage(widget.task.id, 'assets/imgs_tasks/$name$extensionIMG');
                            await modifyTaskDescription(widget.task.id, descriptionController.text);

                            // Guardar las imágenes en las carpetas
                            await saveImage(image!, '$name$extensionIMG', 'assets/imgs_tasks');
                            await saveImage(pictogram!, '$name$extensionPIC', 'assets/picto_tasks');

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Tarea modificada con éxito.'),
                                backgroundColor: Colors.green,
                              ),
                            );

                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('La tarea debe tener al menos un paso.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}