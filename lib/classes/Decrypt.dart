class Decrypt {
  
  String user; 
  String path;

  Decrypt({
    required this.user,
    required this.path,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'path': path,
    };
  }


  Decrypt.fromMap(Map<String, dynamic> map)
      : user = map['user'],
        path = map['path'];
}
