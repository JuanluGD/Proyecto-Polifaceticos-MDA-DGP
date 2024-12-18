class Step {
  int id;
  int task_id;
  String description;
  String pictogram;
  String image;

  // Constructor de la clase Paso.
  Step({
    required this.id,
    required this.task_id,
    required this.description,
    required this.pictogram,
    required this.image
  });

  // Método que convierte un objeto de tipo Paso a un Map.
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'task_id': this.task_id,
      'description': this.description,
      'pictogram': this.pictogram,
      'image': this.image,
    };
  }

  // Método que convierte un Map a un objeto de tipo Paso.
  Step.fromMap(Map<String, dynamic> map)
      : id = map['id'], 
        task_id = map['task_id'], 
        description = map['description'], 
        image = map['image'], 
        pictogram = map['pictogram'];
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Step &&
        other.id == id &&
        other.task_id == task_id &&
        other.description == description &&
        other.pictogram == pictogram &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        task_id.hashCode ^
        description.hashCode ^
        pictogram.hashCode ^
        image.hashCode;
  }

}