class Orders{
  String date;
  int quantity;
  String menuName;
  String classroomName;

  // Constructor de la clase Orders.
  Orders({
    required this.date,
    required this.quantity,
    required this.menuName,
    required this.classroomName,
  });

  // Método para convertir un objeto de tipo Orders a un map.
  Map<String, dynamic> toMap() {
    return {
      'date' : date,
      'quantity' : quantity,
      'menuName' : menuName,
      'classroomName' : classroomName,
    };
  }

  // Método para convertir un map en un objeto de tipo Orders.
  Orders.fromMap(Map<String, dynamic> map)
    : date = map['date'],
      quantity = map['quantity'],
      menuName = map['menuName'],
      classroomName = map['classroomName'];
}