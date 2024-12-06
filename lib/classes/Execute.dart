class Execute {
  int task_id;
  int status;
  String user;
  String date;

  // Constructor de la clase Execute.
  Execute({
    required this.task_id,
    required this.user,
    required this.status,
    required this.date,
  });

  // Método que convierte un objeto de tipo Execute a un Map.
  Map<String, dynamic> toMap() {
    return {
      'task_id': this.task_id,
      'user': this.user,
      'status': this.status,
      'date': this.date,
    };
  }

  // Método que convierte un Map a un objeto de tipo Execute.
  Execute.fromMap(Map<String, dynamic> map)
      : task_id = map['task_id'], 
        user = map['user'], 
        status = map['status'],
        date = map['date'];
        
}