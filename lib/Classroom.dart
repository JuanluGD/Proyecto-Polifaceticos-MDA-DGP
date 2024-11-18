class Classroom {
  String name;

  // Constructor de la clase Classroom.
  Classroom({
    required this.name,
  });

  // Método que convierte un objeto de tipo Classroom a un Map.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  // Método que convierte un Map a un objeto de tipo Classroom.
  Classroom.fromMap(Map<String, dynamic> map)
      : name = map['name'];

}