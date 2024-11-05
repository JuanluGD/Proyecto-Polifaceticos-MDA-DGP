import 'dart:ffi';

class Descifra {
  
  String DNI; 
  String path; 

  
  Descifra({
    required this.DNI,
    required this.path,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'DNI': DNI,
      'path': path,
    };
  }

  
  Descifra.fromMap(Map<String, dynamic> map)
      : DNI = map['DNI'],
        path = map['path'];
}
