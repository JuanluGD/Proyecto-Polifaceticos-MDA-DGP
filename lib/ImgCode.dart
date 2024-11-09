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
}