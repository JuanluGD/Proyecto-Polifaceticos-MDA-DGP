class Admin {

	String dni;
	String name;
	String surname1;
	String surname2;
	String password;
	String? photo = '';


	Admin({
		required this.dni,
		required this.name,
		required this.surname1,
		required this.surname2,
		required this.password,
		this.photo
	});

	// Método para convertir el objeto en un mapa
	Map<String, dynamic> toMap() {
		return {
			'DNI': dni,
			'name': name,
			'surname1': surname1,
			'surname2': surname2,
			'password': password,
			'photo': photo
		};
	}

	// Constructor para crear un objeto desde un mapa (opcional si necesitas leer de SQLite)
	Admin.fromMap(Map<String, dynamic> map)
			:
				dni = map['DNI'],
				name = map['name'],
				surname1 = map['surname1'],
				surname2 = map['surname2'],
				password = map['password'],
				photo = map['photo'];
}
