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
}