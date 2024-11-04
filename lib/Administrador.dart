
class Administrador {
  String user;
  String password;

  Administrador({
    required this.user,
    required this.password,
  });

  // Método para convertir el objeto en un mapa
  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'password': password,
    };
  }

  // Constructor para crear un objeto desde un mapa (opcional si necesitas leer de SQLite)
  Administrador.fromMap(Map<String, dynamic> map)
      : user = map['user'],
        password = map['password'];
}
