class Task {
  int id;
  String name;
  String description;
  String pictogram;
  String image;


  // Constructor de la clase Tarea.
  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.pictogram,
    required this.image
  }); 

  // Método que convierte un objeto de tipo Tarea a un Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictogram': pictogram,
      'image': image,
    };
  }

  // Método que convierte un Map a un objeto de tipo Tarea.
  Task.fromMap(Map<String, dynamic> map)
      : id = map['id'], 
        name = map['name'], 
        description = map['description'], 
        image = map['image'], 
        pictogram = map['pictogram'];
}