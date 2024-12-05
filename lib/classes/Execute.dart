class Execute {
  int id;
  int id_task;
  String user;
  int status;

  // Constructor de la clase Execute.
  Execute({
    required this.id,
    required this.id_task,
    required this.user,
    required this.status,
  });

  // Método que convierte un objeto de tipo Execute a un Map.
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'id_task': this.id_task,
      'user': this.user,
      'status': this.status,
    };
  }

  // Método que convierte un Map a un objeto de tipo Execute.
  Execute.fromMap(Map<String, dynamic> map)
      : id = map['id'], 
        id_task = map['id_task'], 
        user = map['user'], 
        status = map['status'];
        
}