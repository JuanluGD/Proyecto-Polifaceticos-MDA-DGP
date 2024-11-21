class ImgCode {

  String path; 
  String code;


  ImgCode({
    required this.path,
    required this.code,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'code': code,
    };
  }

  ImgCode.fromMap(Map<String, dynamic> map)
      : path = map['path'],
        code = map['code'];

  // Para que el operador de igualdad compruebe si son iguales en contenido en lugar de si es la misma referencia
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImgCode && other.path == path;
  }
  @override
  int get hashCode => path.hashCode;
}