import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();  // Set current date as the selected date by default
  Map<String, List<dynamic>> _aartiDetailsByDate = {}; // Map to group Aarti by date
  List<dynamic> _selectedDateAartiDetails = [];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _fetchAartiDetails(); // Fetch data when the page loads
    _filterAartiDetailsForSelectedDay(_selectedDay!);  // Load Aarti details for the current date
  }

  // Function to fetch all Aarti details from the API
  Future<void> _fetchAartiDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5028/api/aartiDetails'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        Map<String, List<dynamic>> aartiDetailsByDate = {};

        // Group Aarti details by date
        for (var aarti in data) {
          DateTime aartiDate = DateTime.parse(aarti['aartiDate']);
          String formattedDate = "${aartiDate.year}-${aartiDate.month}-${aartiDate.day}";

          if (!aartiDetailsByDate.containsKey(formattedDate)) {
            aartiDetailsByDate[formattedDate] = [];
          }

          aartiDetailsByDate[formattedDate]?.add(aarti);
        }

        setState(() {
          _aartiDetailsByDate = aartiDetailsByDate;
          _isLoading = false;
        });

        // After fetching, update the Aarti details for the current day
        _filterAartiDetailsForSelectedDay(_selectedDay!);
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load Aarti details'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to filter Aarti details based on the selected date
  void _filterAartiDetailsForSelectedDay(DateTime selectedDay) {
    String formattedDate = "${selectedDay.year}-${selectedDay.month}-${selectedDay.day}";
    setState(() {
      _selectedDateAartiDetails = _aartiDetailsByDate[formattedDate] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        backgroundColor: Color(0xff102733),
        titleTextStyle: TextStyle(color: Color.fromARGB(255, 248, 239, 201)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                // Filter and show Aarti details for the selected day
                _filterAartiDetailsForSelectedDay(selectedDay);
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // Show selected date
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              _selectedDay != null
                  ? 'Selected Date: ${_selectedDay!.day}-${_selectedDay!.month}-${_selectedDay!.year}'
                  : 'No Date Selected',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // Display loading or Aarti details for the selected day
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _selectedDateAartiDetails.isEmpty
                    ? Center(child: Text('No Aarti details for this day'))
                    : ListView.builder(
                        itemCount: _selectedDateAartiDetails.length,
                        itemBuilder: (context, index) {
                          final aarti = _selectedDateAartiDetails[index];
                          return ListTile(
                            title: Text('Aarti by: ${aarti['name']}'),
                            subtitle: Text('Username: ${aarti['username']}'),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
