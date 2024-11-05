
class Administrador {
	
	String user;
	String password;
	String name;
	int DNI;
	String last_name1;
	String last_name2;
	String? photo = '';


	Administrador({
	required this.user,
	required this.password,
	required this.name,
	required this.DNI,
	required this.last_name1,
	required this.last_name2,
	this.photo
	});

	// Método para convertir el objeto en un mapa
	Map<String, dynamic> toMap() {
	return {
		'user': user,
		'password': password,
		'name': name,
		'DNI': DNI,
		'last_name1': last_name1,
		'last_name2': last_name2,
		'photo': photo
	};
	}

	// Constructor para crear un objeto desde un mapa (opcional si necesitas leer de SQLite)
	Administrador.fromMap(Map<String, dynamic> map)
		: user = map['user'],
		password = map['password'],
		name = map['name'],
		DNI = map['DNI'],
		last_name1 = map['last_name1'],
		last_name2 = map['last_name2'],
		photo = map['photo'];
  }
