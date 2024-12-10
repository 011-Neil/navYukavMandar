import 'package:navyuvakmandar/models/date_model.dart';
import 'package:navyuvakmandar/models/event_type_model.dart';
import 'package:navyuvakmandar/models/events_model.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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


Future<List<EventsModel>> getEvents() async {
   print("inside getEvents");
  final response = await http.get(Uri.parse('http://10.0.2.2:5028/api/eventDetails'));


  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);

    final currentDate = DateTime.now();

    List<EventsModel> upcomingEvents = [];
    List<EventsModel> ongoingEvents = [];

    // Parsing the API response and filtering events
    jsonData.forEach((event) {
      DateTime eventStartDate = DateTime.parse(event['eventDate']);
      DateTime eventEndDate = DateTime.parse(event['eventEndDate']);

      if (eventStartDate.isAfter(currentDate)) {
        // Upcoming events
        upcomingEvents.add(EventsModel.fromJson(event));
        print(upcomingEvents);
      } else if (eventStartDate.isBefore(currentDate) && eventEndDate.isAfter(currentDate)) {
        // Ongoing events
        ongoingEvents.add(EventsModel.fromJson(event));
        print(ongoingEvents);
      }
    });

    // Combine both upcoming and ongoing events
    return [...ongoingEvents, ...upcomingEvents];
  } else {
    throw Exception('Failed to load events');
  }
}
