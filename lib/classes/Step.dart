class Step {
  int id;
  int task_id;
  String description;
  String pictogram;
  String image;
  String? descriptive_text;

  // Constructor de la clase Paso.
  Step({
    required this.id,
    required this.task_id,
    required this.description,
    required this.pictogram,
    required this.image,
    this.descriptive_text,
  });

  // Método que convierte un objeto de tipo Paso a un Map.
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'task_id': this.task_id,
      'description': this.description,
      'pictogram': this.pictogram,
      'image': this.image,
      'descriptive_text': this.descriptive_text,  
    };
  }

  // Método que convierte un Map a un objeto de tipo Paso.
  Step.fromMap(Map<String, dynamic> map)
      : id = map['id'], 
        task_id = map['task_id'], 
        description = map['description'], 
        image = map['image'], 
        pictogram = map['pictogram'], 
        descriptive_text = map['descriptive_text'];

}