class Orders{
  String date;
  int cuantity;
  String menuName;
  String classroomName;

  // Constructor de la clase Orders.
  Orders({
    required this.date,
    required this.cuantity,
    required this.menuName,
    required this.classroomName,
  });

  // Método para convertir un objeto de tipo Orders a un map.
  Map<String, dynamic> toMap() {
    return {
      'date' : date,
      'cuantity' : cuantity,
      'menuName' : menuName,
      'classroomName' : classroomName,
    };
  }

  // Método para convertir un map en un objeto de tipo Orders.
  Orders.fromMap(Map<String, dynamic> map)
    : date = map['date'],
      cuantity = map['cuantity'],
      menuName = map['menuName'],
      classroomName = map['classroomName'];
}