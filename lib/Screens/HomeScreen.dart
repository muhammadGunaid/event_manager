import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:flutter_clean_calendar/clean_calendar_event.dart';


import '../Helper.dart';
import 'NewEvent.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  Map<DateTime, List<CleanCalendarEvent>> _events = {};

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final events = await DatabaseHelper.instance.getEvents();
    setState(() {
      _events.clear();
      for (final event in events) {
        final date = event['columnStartDate'] != null
            ? DateTime.parse(event['columnStartDate'])
            : null;
        final startTime = date != null
            ? date.add(Duration(
          hours: int.parse(event['start_time'].split(':')[0]),
          minutes: int.parse(event['start_time'].split(':')[1]),
        ))
            : null;
        final endTime = date != null
            ? date.add(Duration(
          hours: int.parse(event['end_time'].split(':')[0]),
          minutes: int.parse(event['end_time'].split(':')[1]),
        ))
            : null;
        final cleanCalendarEvent = CleanCalendarEvent(
          event['columnEventName'] ?? '',
          startTime: startTime ?? DateTime.now(),
          endTime: endTime ?? DateTime.now().add(Duration(minutes: 30)),
          description: event['columnEventType'] ?? '',
          color: Colors.blue,
        );
        if (date != null) {
          if (_events.containsKey(date)) {
            _events[date]!.add(cleanCalendarEvent);
          } else {
            _events[date] = [cleanCalendarEvent];
          }
        }
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Calendar(
          startOnMonday: true,
          weekDays: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'],
          events: _events,
          isExpandable: true,
          eventDoneColor: Colors.green,
          selectedColor: Colors.pink,
          todayColor: Colors.blue,
          eventColor: Colors.grey,
          locale: 'en_US',
        todayButtonText: 'Today',
          isExpanded: true,
          expandableDateFormat: 'EEEE, dd. MMMM yyyy',
          dayOfWeekStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewEventScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
