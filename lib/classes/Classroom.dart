class Classroom {
  String name;
  String image;

  // Constructor de la clase Classroom.
  Classroom({
    required this.name,
    required this.image,
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
      : name = map['name'], image = map['image'];

}