import 'dart:ffi';

class Decrypt {
  
  String DNI; 
  String path;


  Decrypt({
    required this.DNI,
    required this.path,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'DNI': DNI,
      'path': path,
    };
  }


  Decrypt.fromMap(Map<String, dynamic> map)
      : DNI = map['DNI'],
        path = map['path'];
}
