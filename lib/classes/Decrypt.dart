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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Decrypt &&
        other.user == user &&
        other.path == path;
  }

  @override
  int get hashCode {
    return user.hashCode ^
        path.hashCode;
  }
  
}
