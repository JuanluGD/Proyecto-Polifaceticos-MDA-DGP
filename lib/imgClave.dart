class ImgClave {

  String path; 
  String imgCode;


  ImgClave({
    required this.path,
    required this.imgCode,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'imgCode': imgCode,
    };
  }

  ImgClave.fromMap(Map<String, dynamic> map)
      : path = map['path'],
        imgCode = map['imgCode'];
}