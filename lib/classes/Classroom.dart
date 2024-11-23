class Classroom {
  String name;
  String image;
  bool task_completed;

  // Constructor de la clase Classroom.
  Classroom({
    required this.name,
    required this.image,
    this.task_completed = false,
  });

  // Método que convierte un objeto de tipo Classroom a un Map.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }

  // Método que convierte un Map a un objeto de tipo Classroom.
  Classroom.fromMap(Map<String, dynamic> map)
      : name = map['name'], image = map['image'], task_completed = false;

}