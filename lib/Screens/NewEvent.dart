import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/clean_calendar_event.dart';


import '../Helper.dart';

class AddNewEventScreen extends StatefulWidget {
  @override
  _AddNewEventScreenState createState() => _AddNewEventScreenState();
}

class _AddNewEventScreenState extends State<AddNewEventScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String _eventName = '';
  Color _eventColor = Colors.green;
  String eventType = 'Social';
  String priority = 'High';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Add New Event'),
       ),
       body: Padding(
                  padding: const EdgeInsets.all(16.0),
         child: Form(
                         key: _formKey,
                 child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                     TextFormField(
                decoration: InputDecoration(
                    labelText: 'Event Name',
                  border: OutlineInputBorder(),
         ),
    validator: (value) {
              if (value!.isEmpty) {
              return 'Please enter the event name';
                  }
              return null;
                },
                 onSaved: (value) {
                   setState(() {
                     _eventName = value!;
                   });
                  },
         ),
             SizedBox(height: 16.0),
                 Text('Event Type'),
                 DropdownButton<String>(
                   value: eventType,
                   onChanged: (String? newValue) {
                     setState(() {
                       eventType = newValue!;
                     });
                   },
                   items: <String>['Social', 'Deadline', 'Study', 'Miscellaneous']
                       .map<DropdownMenuItem<String>>((String value) {
                     return DropdownMenuItem<String>(
                       value: value,
                       child: Text(value),
                     );
                   }).toList(),
                 ),
                 if (eventType == 'Deadline') ...[
                   SizedBox(height: 16),
                   Text('Priority'),
                   DropdownButton<String>(
                     value: priority,
                     onChanged: (String? newValue) {
                       setState(() {
                         priority = newValue!;
                       });
                     },
                     items: <String>[
                       'High',
                       'High Extreme',
                       'Low',
                       'Low Extreme'
                     ].map<DropdownMenuItem<String>>((String value) {
                       return DropdownMenuItem<String>(
                         value: value,
                         child: Text(value),
                       );
                     }).toList(),
                   ),
                 ],

                  SizedBox(height: 16.0),
                  Text('Start Date'),
                  SizedBox(height: 8.0),
                  GestureDetector(
                   onTap: () async {
                     final selectedDate = await showDatePicker(
                       context: context,
                       initialDate: DateTime.now(),
                       firstDate: DateTime(2021),
                       lastDate: DateTime(2024),
                     );

                     if (selectedDate != null) {
                       setState(() {
                         _startDate = selectedDate;
                       });
                     }
                   },
                   child: Container(
                     decoration: BoxDecoration(
                       border: Border.all(color: Colors.grey),
                       borderRadius: BorderRadius.circular(4.0),
                     ),
                     padding: EdgeInsets.all(8.0),
                     child: Text(
                       _startDate.toString(),
                     ),
                   ),
                 ),
                  SizedBox(height: 16.0),
                  Text('End Date'),
                  SizedBox(height: 8.0),
                  GestureDetector(
                   onTap: () async {
                     final selectedDate = await showDatePicker(
                       context: context,
                       initialDate: DateTime.now(),
                       firstDate: DateTime(2021),
                       lastDate: DateTime(2024),
                     );

                     if (selectedDate != null) {
                       setState(() {
                         _endDate = selectedDate;
                       });
                     }
                   },
                   child: Container(
                     decoration: BoxDecoration(
                       border: Border.all(color: Colors.grey),
                       borderRadius: BorderRadius.circular(4.0),
                     ),
                     padding: EdgeInsets.all(8.0),
                     child: Text(
                       _endDate.toString(),
                     ),
                   ),
                 ),
                  SizedBox(height: 32.0),
                 ElevatedButton(
                   onPressed: () async {
                     if (_formKey.currentState!.validate()) {
                       _formKey.currentState!.save();
                       // Save the data to the database
                       Map<String, dynamic> row = {
                         DatabaseHelper.columnEventName: _eventName,
                         DatabaseHelper.columnEventType: eventType,
                         DatabaseHelper.columnPriority: priority,
                         DatabaseHelper.columnStartDate: _startDate.toIso8601String(),
                         DatabaseHelper.columnEndDate: _endDate.toIso8601String(),
                       };
                       int id = await DatabaseHelper.instance.insertEvent(row);
                       print('Inserted row $id');
                     }
                   },
                   child: Text('Submit'),
                 ),

               ]
    ),


    ),
    ),

    );
  }
}
