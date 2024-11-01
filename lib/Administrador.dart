
class Administrador {
  int? id;
  String user;
  String password;

  Administrador({
    this.id,
    required this.user,
    required this.password,
  });

  // Método para convertir el objeto en un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'password': password,
    };
  }

  // Constructor para crear un objeto desde un mapa (opcional si necesitas leer de SQLite)
  Administrador.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        user = map['user'],
        password = map['password'];
}
