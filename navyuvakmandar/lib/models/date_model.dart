class DateModel {
  String weekDay;
  String date;
  bool isSelected;

  DateModel({
    required this.weekDay,
    required this.date,
    this.isSelected = false,
  });
}