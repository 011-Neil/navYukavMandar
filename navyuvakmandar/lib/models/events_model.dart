class EventsModel {
  String desc;
  String date;
  String address;
  String imgeAssetPath;

  EventsModel({
    required this.desc,
    required this.date,
    required this.address,
    required this.imgeAssetPath,
  });

  // Factory constructor to create an instance from JSON
  factory EventsModel.fromJson(Map<String, dynamic> json) {
    return EventsModel(
      desc: json['description'] ?? '',  // Use the correct field from the API (description)
      date: json['eventDate'] ?? '',    // Use 'eventDate' as the date field
      address: json['organiser'] ?? '', // Use 'organiser' as the address field
      imgeAssetPath: json['imageUrl'] != null
        ? 'http://10.0.2.2:5028' + json['imageUrl'] // Prepend the base URL if imageUrl is present
        : 'assets/no_image.jpg',  // Fallback to a default image if no image is provided
    );
  }


  // Method to convert instance back to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'description': desc,
      'eventDate': date,
      'organiser': address,
      'imageUrl': imgeAssetPath,
    };
  }
}
