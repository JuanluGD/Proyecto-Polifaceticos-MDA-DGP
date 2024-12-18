class Menu{
  String name;
  String pictogram;
  String image;

  // Constructor de la clase Menu
  Menu({
    required this.name,
    required this.pictogram,
    required this.image,
  });

  // Método para convertir un objeto de la clase Menu a un Map.
  Map<String, dynamic> toMap() {
    return {
      'name' : name,
      'pictogram' : pictogram,
      'image' : image,
    };
  }

  // Método para convertir un Map a un objeto de la clase Menu.
  Menu.fromMap(Map<String, dynamic> map) 
    : name = map['name'],
      pictogram = map['pictogram'],
      image = map['image'];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Menu &&
        other.name == name &&
        other.pictogram == pictogram &&
        other.image == image;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        pictogram.hashCode ^
        image.hashCode;
  }
}