class Student {

  final String user;
  String name;
  String? surname;
  String password;
  String image;
  String typePassword;
  int interfaceIMG;
  int interfacePIC;
  int interfaceTXT;

  Student({
    required this.user,
    required this.name,
    this.surname,
    required this.password,
    required this.image,
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
			'surname': surname,
			'password': password,
			'image': image,
			'typePassword': typePassword,
			'interfaceIMG': interfaceIMG,
			'interfacePIC': interfacePIC,
			'interfaceTXT': interfaceTXT
		
		};
	}

	// Constructor para crear un objeto desde un mapa
		Student.fromMap(Map<String, dynamic> map)
				: user = map['user'],
					name = map['name'],
					surname = map['surname'],
					password = map['password'],
					image = map['image'],
					typePassword = map['typePassword'],
					interfaceIMG = map['interfaceIMG'],
					interfacePIC = map['interfacePIC'],
					interfaceTXT = map['interfaceTXT'];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Student &&
        other.user == user &&
        other.name == name &&
        other.surname == surname &&
        other.password == password &&
        other.image == image &&
        other.typePassword == typePassword &&
        other.interfaceIMG == interfaceIMG &&
        other.interfacePIC == interfacePIC &&
        other.interfaceTXT == interfaceTXT;
  }

  @override
  int get hashCode {
    return user.hashCode ^
        name.hashCode ^
        surname.hashCode ^
        password.hashCode ^
        image.hashCode ^
        typePassword.hashCode ^
        interfaceIMG.hashCode ^
        interfacePIC.hashCode ^
        interfaceTXT.hashCode;
  }
}
