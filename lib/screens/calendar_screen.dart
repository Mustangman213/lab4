import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/event_model.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final Map<DateTime, List<Event>> _events = {};
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exam Schedule')),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDate,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            eventLoader: (day) => _events[day] ?? [],
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: (_events[_selectedDate] ?? [])
                  .map((event) => ListTile(
                        title: Text(event.title),
                        subtitle: Text(
                          '${event.dateTime} - ${event.location}',
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newEvent = await _addEventDialog();
          if (newEvent != null) {
            setState(() {
              _events[_selectedDate] = [...?_events[_selectedDate], newEvent];
            });
          }
        },
      ),
    );
  }

  Future<Event?> _addEventDialog() async {
    String title = '';
    String location = '';
    DateTime? dateTime;

    return showDialog<Event>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (value) => title = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Location'),
              onChanged: (value) => location = value,
            ),
            ElevatedButton(
              onPressed: () async {
                dateTime = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                setState(() {});
              },
              child: const Text('Pick Date and Time'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (title.isNotEmpty && location.isNotEmpty && dateTime != null) {
                Navigator.pop(
                  context,
                  Event(title: title, dateTime: dateTime!, location: location),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
