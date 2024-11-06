class Student {

  final String dni;
  final String name;
  final String surname1;
  final String surname2;
  final String password;
  final String photo;
  final String typePassword;
  final int interfaceIMG;
  final int interfacePIC;
  final int interfaceTXT;

  Student({
    required this.dni,
    required this.name,
    required this.surname1,
    required this.surname2,
    required this.password,
    required this.photo,
    required this.typePassword,
    required this.interfaceIMG,
    required this.interfacePIC,
    required this.interfaceTXT,
  });

	// Método para convertir el objeto en un mapa
	Map<String, dynamic> toMap() {
		return {
			'DNI': dni,
			'name': name,
			'surname1': surname1,
			'surname2': surname2,
			'password': password,
			'photo': photo,
			'typePassword': typePassword,
			'interfaceIMG': interfaceIMG,
			'interfacePIC': interfacePIC,
			'interfaceTXT': interfaceTXT
		
		};
	}

	// Constructor para crear un objeto desde un mapa
		Student.fromMap(Map<String, dynamic> map)
				:
					dni = map['DNI'],
					name = map['name'],
					surname1 = map['surname1'],
					surname2 = map['surname2'],
					password = map['password'],
					photo = map['photo'],
					typePassword = map['typePassword'],
					interfaceIMG = map['interfaceIMG'],
					interfacePIC = map['interfacePIC'],
					interfaceTXT = map['interfaceTXT'];
}
