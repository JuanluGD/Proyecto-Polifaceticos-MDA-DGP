
import 'package:proyecto/Admin.dart';
import 'package:proyecto/Student.dart';
import 'package:proyecto/bd.dart';

Future<bool> loginAdmin(String dni, String name, String lastName1,
									 String lastName2, String password, String photo) async{
	
	bool correct = false;
	Admin admin = Admin(password: password, name: name, DNI: dni, lastName1: lastName1,
			lastName2: lastName2, photo: photo);

	correct = await ColegioDatabase.instance.checkAdmin(admin);

	return correct;
}

Future<bool> loginAdmin2(String dni, String password) async{

	bool correct = false;

	correct = await ColegioDatabase.instance.checkAdmin2(dni, password);

	return correct;
}

Future<bool> loginStudent(String dni, String password) async{
	
	bool correct = false;
	Student student = Student(password: password, name: "name", DNI: dni, lastName1: "0",
			lastName2: "0", photo: "0", typePassword: "0", interfaceIMG: 0,
			interfacePIC: 0, interfaceTXT: 1);

	correct = await ColegioDatabase.instance.checkStudent(student);

	return correct;
}

Future<bool> loginStudent2(String dni, String password) async{
	
	bool correct = false;

	correct = await ColegioDatabase.instance.checkStudent2(dni, password);

	return correct;
}

Future<bool> registerStudent(String dni, name, String lastName1, String lastName2,
		String password, String photo, String typePassword, int interfaceIMG,
		int interfacePIC, int interfaceTXT) async{
	
	bool correct = false;
	Student student = Student(password: password, name: name, DNI: dni, lastName1: lastName1,
			lastName2: lastName2, photo: photo, typePassword: typePassword, interfaceIMG: interfaceIMG,
			interfacePIC: interfacePIC, interfaceTXT: interfaceTXT);

	correct = await ColegioDatabase.instance.registerStudent(student);

	return correct;
}

Future<bool> asignLoginType(String dni, String typePassword) async {

	bool result = await ColegioDatabase.instance.asignLoginType(typePassword, dni);

	return result;
}


Future<bool> modifyNameStudent(String dni, String newName) async{

	bool result = await ColegioDatabase.instance.modifyStudent(dni, "name", newName);

	return result;
}

Future<bool> modifyPasswordStudnt(String dni, String newPassword) async{

	bool result = await ColegioDatabase.instance.modifyStudent(dni, "password", newPassword);

	return result;
}
