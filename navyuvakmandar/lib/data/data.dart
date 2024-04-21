import 'package:navyuvakmandar/models/date_model.dart';
import 'package:navyuvakmandar/models/event_type_model.dart';
import 'package:navyuvakmandar/models/events_model.dart';
import 'package:intl/intl.dart';
List<DateModel> getDates() {
  final List<DateModel> dates = [];
  final currentDate = DateTime.now();

  for (int i = 0; i < 7; i++) {
    final date = currentDate.add(Duration(days: i));
    final formattedDate = DateFormat('dd-MM-yyyy').format(date);
    final formattedWeekDay = DateFormat('E').format(date);

    dates.add(DateModel(
      weekDay: formattedWeekDay,
      date: formattedDate,
      isSelected: i == 0,
    ));
  }

  return dates;
}

List<EventTypeModel> getEventTypes() {
  final List<EventTypeModel> events = [];

  // Create EventTypeModel objects with unique values and add them to the list
  events.add(EventTypeModel(
    imgAssetPath: "assets/concert.png",
    eventType: "Concert",
  ));
  events.add(EventTypeModel(
    imgAssetPath: "assets/sports.png",
    eventType: "Sports",
  ));
  events.add(EventTypeModel(
    imgAssetPath: "assets/education.png",
    eventType: "Education",
  ));

  return events;
}

List<EventsModel> getEvents() {
  final List<EventsModel> events = [];

  // Create EventsModel objects with unique values and add them to the list
  events.add(EventsModel(
    imgeAssetPath: "assets/tileimg.png",
    date: "Jan 12, 2019",
    desc: "Sports Meet in Galaxy Field",
    address: "Greenfields, Sector 42, Faridabad",
  ));

  events.add(EventsModel(
    imgeAssetPath: "assets/second.png",
    date: "Jan 12, 2019",
    desc: "Art & Meet in Street Plaza",
    address: "Galaxyfields, Sector 22, Faridabad",
  ));

  events.add(EventsModel(
    imgeAssetPath: "assets/music_event.png",
    date: "Jan 12, 2019",
    desc: "Youth Music in Gwalior",
    address: "Galaxyfields, Sector 22, Faridabad",
  ));

  return events;
}
