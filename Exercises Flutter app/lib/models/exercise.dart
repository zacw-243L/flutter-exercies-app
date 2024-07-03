class Exercise {
  final String name;
  final String gifUrl;
  final String equipment;
  final List<dynamic> instructions;

  Exercise({
    required this.name,
    required this.gifUrl,
    required this.equipment,
    required this.instructions,
  });

  //TODO Implement Exercise.fromJson
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      gifUrl: json['gifUrl'],
      equipment: json['equipment'],
      instructions: json['instructions'],
    );
  }
}
