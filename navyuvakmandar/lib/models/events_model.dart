class EventsModel{
  String desc;
  String date;
  String address;
  String imgeAssetPath;

   EventsModel({
    required this.desc,          // Marked as required
    required this.date,          // Marked as required
    required this.address,       // Marked as required
    required this.imgeAssetPath, // Marked as required
  });
}