class Order {
  String date;
  int quantity;
  String menuName;
  String classroomName;

  // Constructor de la clase Order.
  Order ({
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
  Order.fromMap(Map<String, dynamic> map)
    : date = map['date'],
      quantity = map['quantity'],
      menuName = map['menuName'],
      classroomName = map['classroomName'];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order &&
        other.date == date &&
        other.quantity == quantity &&
        other.menuName == menuName &&
        other.classroomName == classroomName;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        quantity.hashCode ^
        menuName.hashCode ^
        classroomName.hashCode;
  }
}