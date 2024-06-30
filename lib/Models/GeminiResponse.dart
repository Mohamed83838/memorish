import 'dart:convert';

class Response {
  String title;
  String description;

  Response({required this.title, required this.description});

  // Method to convert the model to JSON
  String toJson() {
    final Map<String, dynamic> data = {
      'title': this.title,
      'description': this.description,
    };
    return json.encode(data);
  }

  // Method to create the model from JSON
  factory Response.fromJson(String jsonString) {
    final Map<String, dynamic> data = json.decode(jsonString);
    return Response(
      title: data['title'],
      description: data['description'],
    );
  }

  @override
  String toString() {
    return 'Response(title: $title, description: $description)';
  }
}
