import 'package:proyecto/Student.dart';
import 'package:proyecto/bd.dart';

Future<bool> loginStudent(String user, String password) async{
	
	bool correct = false;

	correct = await ColegioDatabase.instance.loginStudent(user, password);

	return correct;
}

Future<bool> registerStudent(String user, name, String surname1, String surname2,
	String password, String photo, String typePassword, int interfaceIMG,
	int interfacePIC, int interfaceTXT) async{
	
	bool correct = false;
	Student student = Student(password: password, name: name, user: user, surname1: surname1,
			surname2: surname2, photo: photo, typePassword: typePassword, interfaceIMG: interfaceIMG,
			interfacePIC: interfacePIC, interfaceTXT: interfaceTXT);

	correct = await ColegioDatabase.instance.registerStudent(student);

	return correct;
}

Future<bool> asignLoginType(String user, String typePassword) async {

	bool result = await ColegioDatabase.instance.asignLoginType(user, typePassword);

	return result;
}


Future<bool> modifyNameStudent(String user, String newName) async{

	bool result = await ColegioDatabase.instance.modifyStudent(user, "name", newName);

	return result;
}

Future<bool> modifyPasswordStudent(String user, String newPassword) async{

	bool result = await ColegioDatabase.instance.modifyStudent(user, "password", newPassword);

	return result;
}

Future<bool> modifyCompleteStudent(String user, String name, String? surname1, String? surname2,
  String password, String photo, String typePassword, int interfaceIMG, int interfacePIC, int interfaceTXT) async{

  bool result = await ColegioDatabase.instance.modifyCompleteStudent(user, name, surname1, surname2, password, photo, typePassword, interfaceIMG, interfacePIC, interfaceTXT);

  return result;
}