
class Estudiante {
  String name;
  String user;
  String password;
  String? loginType = 'basico';

  Estudiante({
    required this.name,
    required this.user,
    required this.password,
	this.loginType
  });

  // Método para convertir el objeto en un mapa
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'user': user,
      'password': password,
	  'loginType': loginType
    };
  }

  // Constructor para crear un objeto desde un mapa
  Estudiante.fromMap(Map<String, dynamic> map)
	: 	name = map['name'],
        user = map['user'],
        password = map['password'],
		loginType = map['loginType'];
}
