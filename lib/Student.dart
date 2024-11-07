class Student {

  final String user;
  String name;
  String? surname1;
  String? surname2;
  String password;
  String photo;
  String typePassword;
  int interfaceIMG;
  int interfacePIC;
  int interfaceTXT;

  Student({
    required this.user,
    required this.name,
    this.surname1,
    this.surname2,
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
			'user': user,
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
					user = map['user'],
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
