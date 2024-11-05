
import 'dart:ffi';

class Estudiante {

   	String user;
	String password;
	String name;
	int DNI;
	String last_name1;
	String last_name2;
	String? photo = '';
	String tipoPasswd;
	bool interfazIMG;
	bool interfazPIC;
	bool interfazTXT;

	Estudiante({
		required this.user,
		required this.password,
		required this.name,
		required this.DNI,
		required this.last_name1,
		required this.last_name2,
		this.photo,
		required this.tipoPasswd,
		required this.interfazIMG,
		required this.interfazPIC,
		required this.interfazTXT
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
		'photo': photo,
		'tipoPasswd': tipoPasswd,
		'interfazIMG': interfazIMG,
		'interfazPIC': interfazPIC,
		'interfazTXT': interfazTXT
		
		};
	}

	// Constructor para crear un objeto desde un mapa
	Estudiante.fromMap(Map<String, dynamic> map)
		: 	name = map['name'],
			user = map['user'],
			password = map['password'],
			DNI = map['DNI'],
			last_name1 = map['last_name1'],
			last_name2 = map['last_name2'],
			photo = map['photo'],
			tipoPasswd = map['tipoPasswd'],
			interfazIMG = map['interfazIMG'],
			interfazPIC = map['interfazPIC'],
			interfazTXT = map['interfazTXT'];
}
