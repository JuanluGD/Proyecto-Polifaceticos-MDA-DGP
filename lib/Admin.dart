
class Admin {

	String DNI;
	String name;
	String lastName1;
	String lastName2;
	String password;
	String? photo = '';


	Admin({
		required this.DNI,
		required this.name,
		required this.lastName1,
		required this.lastName2,
		required this.password,
		this.photo
	});

	// Método para convertir el objeto en un mapa
	Map<String, dynamic> toMap() {
		return {
			'DNI': DNI,
			'name': name,
			'last_name1': lastName1,
			'last_name2': lastName2,
			'password': password,
			'photo': photo
		};
	}

	// Constructor para crear un objeto desde un mapa (opcional si necesitas leer de SQLite)
	Admin.fromMap(Map<String, dynamic> map)
			:
				DNI = map['DNI'],
				name = map['name'],
				lastName1 = map['lastName1'],
				lastName2 = map['lastName2'],
				password = map['password'],
				photo = map['photo'];
}
