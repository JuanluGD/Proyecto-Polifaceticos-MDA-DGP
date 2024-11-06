class Decrypt {
  
  String dni; 
  String path;


  Decrypt({
    required this.dni,
    required this.path,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'DNI': dni,
      'path': path,
    };
  }


  Decrypt.fromMap(Map<String, dynamic> map)
      : dni = map['DNI'],
        path = map['path'];
}
