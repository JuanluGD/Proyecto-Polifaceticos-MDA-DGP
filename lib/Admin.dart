String user = 'admin';
String password = 'admin';

bool loginAdmin(String user, String password){
	if(user == 'admin' && password == 'admin'){
		return true;
	}
	return false;
}
