class Task {
  String name;
  String description;
  String image;

  // Constructor de la clase Tarea.
  Task({
    required this.name,
    required this.description,
    required this.image,
  }); 

  // Método que convierte un objeto de tipo Tarea a un Map.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'image': image,
    };
  }

  // Método que convierte un Map a un objeto de tipo Tarea.
  Task.fromMap(Map<String, dynamic> map)
      : name = map['name'], description = map['description'], image = map['image'];
}