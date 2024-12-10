import 'package:flutter/material.dart';
import 'package:navyuvakmandar/data/data.dart';
import 'models/date_model.dart';
import 'models/event_type_model.dart';
import 'models/events_model.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'models/side_menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DateModel> dates = [];
  List<EventTypeModel> eventsType = [];
  List<EventsModel> events = [];
  Set<String> selectedDates = Set<String>();
  DateTime _selectedDay = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String formattedCurrentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<EventsModel> ongoingEvents = [];
  List<EventsModel> upcomingEvents = [];
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    dates = getDates();
    eventsType = getEventTypes();
    fetchEvents();
    _selectedDay = DateTime.now();
    formattedDate = DateFormat('dd-MM-yyyy').format(_selectedDay);
  }

  Future<void> fetchEvents() async {
    try {
      List<EventsModel> fetchedEvents = await getEvents();
      setState(() {
        events = fetchedEvents;
        print("Events fetched: $events");
      });
    } catch (e) {
      print("Error fetching events: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff102733),
        title: Row(
          children: <Widget>[
            Image.asset("assets/logo.png", height: 28),
            SizedBox(width: 8),
            Text(
              "NavYuk",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800),
            ),
            Text(
              "Mandal",
              style: TextStyle(
                  color: Color(0xffFCCD00),
                  fontSize: 22,
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Image.asset("assets/notify.png", height: 22),
            onPressed: () {
              // Add your notification button functionality here
            },
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Color(0xff102733)),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 60, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Hello, Neil!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 21),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Let's explore what’s happening nearby",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15),
                            )
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    /// Dates
                    Container(
                      height: 60,
                      child: ListView.builder(
                        itemCount: dates.length + 1, // Add 1 for the "More" option
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if (index == dates.length) {
                            // Last item, show the "More" option
                            return GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CalendarBottomSheet(
                                      selectedDay: _selectedDay,
                                      focusedDay: _focusedDay,
                                      onDaySelected: (selectedDay, focusedDay) {
                                        setState(() {
                                          _selectedDay = selectedDay;
                                          formattedDate = DateFormat('dd-MM-yyyy')
                                              .format(selectedDay);
                                          _focusedDay = focusedDay;
                                        });
                                        Navigator.pop(context); // Close the calendar after selection
                                      },
                                    );
                                  },
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "More",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            // Regular date items
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  formattedDate = dates[index].date;
                                });
                              },
                              child: DateTile(
                                weekDay: dates[index].weekDay,
                                date: dates[index].date,
                                isSelected: formattedDate == dates[index].date ||
                                    (formattedDate == '' &&
                                        dates[index].date == formattedCurrentDate),
                                currentDate: formattedCurrentDate,
                              ),
                            );
                          }
                        },
                      ),
                    ),

                    Container(
                      child: ListView.builder(
                        itemCount: events.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (selectedDates.contains(events[index].date)) {
                            return PopularEventTile(
                              desc: events[index].desc,
                              imgeAssetPath: events[index].imgeAssetPath,
                              date: events[index].date,
                              address: events[index].address,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),

                    /// Events
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "All Events",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                     Container(
                      child: ListView.builder(
                        itemCount: events.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index){
                          return PopularEventTile(
                            desc: events[index].desc,
                            imgeAssetPath: events[index].imgeAssetPath,
                            date: events[index].date,
                            address: events[index].address,
                          );

                          }),
                    ),

                    /// Popular Events
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Popular Events",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Container(
                      child: ListView.builder(
                        itemCount: events.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return PopularEventTile(
                            desc: events[index].desc,
                            imgeAssetPath: events[index].imgeAssetPath,
                            date: events[index].date,
                            address: events[index].address,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateTile extends StatelessWidget {
  final String weekDay;
  final String date;
  final bool isSelected;
  final String currentDate;

  DateTile({
    required this.weekDay,
    required this.date,
    required this.isSelected,
    required this.currentDate,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xffFCCD00) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        // Add border for unselected dates
        border: isSelected ? null : Border.all(color: Colors.white),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            date,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            weekDay,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarBottomSheet extends StatelessWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final Function(DateTime, DateTime) onDaySelected;

  CalendarBottomSheet({
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: EdgeInsets.all(16),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(selectedDay, day);
        },
        onDaySelected: onDaySelected,
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}



class PopularEventTile extends StatelessWidget {
  final String desc;
  final String imgeAssetPath; // This should now be treated as an image URL
  final String date;
  final String address;

  PopularEventTile({
    required this.desc,
    required this.imgeAssetPath, // This will hold the network image URL
    required this.date,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xff29404E),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              width: MediaQuery.of(context).size.width - 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(desc, style: TextStyle(
                      color: Colors.white,
                    fontSize: 18
                  ),),
                  SizedBox(height: 8,),
                  Row(
                    children: <Widget>[
                      Image.asset("assets/calender.png", height: 12,),
                      SizedBox(width: 8,),
                      Text(date, style: TextStyle(
                          color: Colors.white,
                          fontSize: 10
                      ),)
                    ],
                  ),
                  SizedBox(height: 4,),
                  Row(
                    children: <Widget>[
                      Image.asset("assets/location.png", height: 12,),
                      SizedBox(width: 8,),
                      Text(address, style: TextStyle(
                        color: Colors.white,
                        fontSize: 10
                      ),)
                    ],
                  ),
                ],
              ),
            ),
          ),
         ClipRRect(
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(8),
    bottomRight: Radius.circular(8),
  ),
  child: Image.network(
    imgeAssetPath, // This should be the URL for the network image
    height: 100,
    width: 120,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Image.asset(
        'assets/no_image.jpg', // Fallback image if the network fails
        height: 100,
        width: 120,
        fit: BoxFit.cover,
      );
    },
  ),
),

        ],
      ),
    );
  }
}
class EventTile extends StatelessWidget {
  final String imgAssetPath;
  final String eventType;

  EventTile({
    required this.imgAssetPath,
    required this.eventType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Image.asset(imgAssetPath, height: 60, width: 60),
          SizedBox(height: 8),
          Text(eventType),
        ],
      ),
    );
  }
}
