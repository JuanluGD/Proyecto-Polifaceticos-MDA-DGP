class Step {
  int id;
  int id_task;
  String name;
  String description;
  String pictogram;
  String image;
  String? descriptive_text;

  // Constructor de la clase Paso.
  Step({
    required this.id,
    required this.id_task,
    required this.name,
    required this.description,
    required this.pictogram,
    required this.image,
    this.descriptive_text,
  });

  // Método que convierte un objeto de tipo Paso a un Map.
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'id_task': this.id_task,
      'name': this.name,
      'description': this.description,
      'pictogram': this.pictogram,
      'image': this.image,
      'descriptive_text': this.descriptive_text,  
    };
  }

  // Método que convierte un Map a un objeto de tipo Paso.
  Step.fromMap(Map<String, dynamic> map)
      : id = map['id'], 
        id_task = map['id_task'], 
        name = map['name'], 
        description = map['description'], 
        image = map['image'], 
        pictogram = map['pictogram'], 
        descriptive_text = map['descriptive_text'];

}