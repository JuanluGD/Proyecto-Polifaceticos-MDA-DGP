
class Student {

	String DNI;
	String name;
	String lastName1;
	String lastName2;
	String password;
	String? photo = '';
	String typePassword;
	bool interfaceIMG;
	bool interfacePIC;
	bool interfaceTXT;

	Student({
		required this.DNI,
		required this.name,
		required this.lastName1,
		required this.lastName2,
		required this.password,
		this.photo,
		required this.typePassword,
		required this.interfaceIMG,
		required this.interfacePIC,
		required this.interfaceTXT
	});

	// Método para convertir el objeto en un mapa
	Map<String, dynamic> toMap() {
		return {
			'DNI': DNI,
			'name': name,
			'lastName1': lastName1,
			'lastName2': lastName2,
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
					DNI = map['DNI'],
					name = map['name'],
					lastName1 = map['lastName1'],
					lastName2 = map['lastName2'],
					password = map['password'],
					photo = map['photo'],
					typePassword = map['typePassword'],
					interfaceIMG = map['interfaceIMG'],
					interfacePIC = map['interfacePIC'],
					interfaceTXT = map['interfaceTXT'];
}
