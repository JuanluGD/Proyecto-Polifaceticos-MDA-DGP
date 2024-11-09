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
  int diningRoomTask;

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
    this.diningRoomTask = 0,
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
			'interfaceTXT': interfaceTXT,
      'diningRoomTask': diningRoomTask
		
		};
	}

	// Constructor para crear un objeto desde un mapa
		Student.fromMap(Map<String, dynamic> map)
				:
					user = map['user'],
					name = map['name'],
					surname = map['surname'],
					password = map['password'],
					image = map['image'],
					typePassword = map['typePassword'],
					interfaceIMG = map['interfaceIMG'],
					interfacePIC = map['interfacePIC'],
					interfaceTXT = map['interfaceTXT'],
          diningRoomTask = map['diningRoomTask'];
}
