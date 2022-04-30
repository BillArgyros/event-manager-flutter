import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:schedule/models/event_model.dart';
import 'package:schedule/services/shared_pref.dart';
import 'package:table_calendar/table_calendar.dart';

class ManageScreen extends StatefulWidget {
  List<EventModel> eventList = [];
  late EventModel currentEvent;
  int index = -1;

  ManageScreen({Key? key, required this.eventList}) : super(key: key);

  ManageScreen.fromEdit(
      {Key? key, required this.index, required this.eventList})
      : super(key: key);

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  var _selectedDay = DateTime.now();
  var _focusedDay = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  String title = 'New Event';
  String description = '';
  SharedPref savePref = SharedPref();
  Color primaryColor = const Color.fromRGBO(144, 85, 255,1);

  @override
  void initState() {
    if (widget.index > -1) {
      title = widget.eventList[widget.index].title;
      description = widget.eventList[widget.index].description;
      _selectedDay = DateTime(
          int.parse(widget.eventList[widget.index].year),
          int.parse(widget.eventList[widget.index].month),
          int.parse(widget.eventList[widget.index].day),
          0,
          0,
          0,
          0);
      _focusedDay = DateTime(
          int.parse(widget.eventList[widget.index].year),
          int.parse(widget.eventList[widget.index].month),
          int.parse(widget.eventList[widget.index].day),
          0,
          0,
          0,
          0);
      time = TimeOfDay(
          hour: int.parse(widget.eventList[widget.index].hour),
          minute: int.parse(widget.eventList[widget.index].minute));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SizedBox(
          width: screenWidth * 1,
          height: screenHeight * 1,
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.1,
                child: customAppBar(screenWidth, screenHeight),
              ),
              Expanded(
                child: eventFields(screenWidth, screenHeight),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      builder: (context, child) {
        var screenWidth = MediaQuery.of(context).size.width;
        var screenHeight = MediaQuery.of(context).size.height;
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
              // Using 24-Hour format
              alwaysUse24HourFormat: true),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 1,
                width: screenWidth * 1,
                child: child,
              )
            ],
          ),
        );
      },
      context: context,
      initialTime: time,
    );
    if (newTime != null) {
      setState(() {
        time = newTime;
      });
    }
  }

  Widget calendar(screenWidth,screenHeight) {
    return Padding(
      padding: const EdgeInsets.only(left:0.0,right: 0),
      child: Card(
        elevation: 5.0,
        shape:  const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          side: BorderSide( color: Colors.black, width: 1.0),
        ),
        child: TableCalendar(
          daysOfWeekHeight: 40,
          headerStyle:  HeaderStyle(
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
              ),
              titleCentered: true,
              formatButtonVisible: false),
          calendarStyle:  CalendarStyle(
            selectedDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor
            ),
            // tableBorder: TableBorder(
            //   borderRadius: BorderRadius.circular(32),
            //   bottom: const BorderSide(width: 1, color: Colors.black),
            //   right: const BorderSide(width: 1, color: Colors.black),
            //   left: const BorderSide(width: 1, color: Colors.black),
            // ),
            isTodayHighlighted: false,
          ),
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
        ),
      ),
    );
  }

  Widget timePicker(screenWidth,screenHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0,top: 10,bottom: 10),
          child: SizedBox(
            width: screenWidth * 0.3,
            height: screenHeight * 0.05,
            child: ElevatedButton(
              style: ButtonStyle(
                  elevation:MaterialStateProperty.all(5),
                  backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ))),
              onPressed: _selectTime,
              child: SizedBox(
                  height: screenHeight*0.025,
                  child: const FittedBox(child: Text('Select time',style: TextStyle(color: Colors.black),))),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: SizedBox(
            height: screenHeight*0.03,
            child: FittedBox(
              child: Text(
                time.format(context),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget addTitle(screenWidth,screenHeight) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: screenHeight*0.07,
          width: screenWidth*1,
          child: TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(30),
            ],
            onChanged: (text) => title = text,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 5,
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              labelText: 'Event title',
            ),
            textInputAction: TextInputAction.done,
            initialValue: widget.index > -1 ? title : null,
          ),
        ),
      ),
    );
  }

  Widget addComment(screenWidth,screenHeight) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: screenHeight*0.07,
          width: screenWidth*1,
          child: TextFormField(
            onChanged: (text) => description = text,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 5,
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              labelText: 'Event description...',
            ),
            textInputAction: TextInputAction.done,
            initialValue: widget.index > -1
                ? description != 'No description given'
                    ? description
                    : null
                : null,
          ),
        ),
      ),
    );
  }

  void clearChatTextWhiteSpace() {
    title = title.trimLeft();
    title = title.trimRight();
    description = description.trimLeft();
    description = description.trimRight();
  }

  Widget customAppBar(double screenWidth, double screenHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: SizedBox(
            width: screenWidth*0.15,
            height: screenHeight*0.15,
            child: FittedBox(
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: SizedBox(
            width: screenWidth * 0.3,
            height: screenHeight * 0.05,
            child: ElevatedButton(
                style: ButtonStyle(
                  elevation:MaterialStateProperty.all(5),
                    backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                         RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ))),
                onPressed: () async {
                  if (title.isEmpty) {
                    title = 'New Event';
                  }
                  if (description.isEmpty) {
                    description = 'No description given';
                  }
                  clearChatTextWhiteSpace();
                  if (widget.index == -1) {
                    widget.eventList.add(EventModel(
                        title: title,
                        description: description,
                        time: time.format(context).toString(),
                        date: DateFormat.d().format(_selectedDay) +
                            ' ' +
                            DateFormat.LLLL().format(_selectedDay),
                        year: DateFormat.y().format(_selectedDay),
                        month: DateFormat.M().format(_selectedDay),
                        day: DateFormat.d().format(_selectedDay),
                        hour: time.hour.toString(),
                        minute: time.minute.toString(),
                        isFavourite: false));
                  } else {
                    widget.eventList[widget.index] = EventModel(
                        title: title,
                        description: description,
                        time: time.format(context).toString(),
                        date: DateFormat.d().format(_selectedDay) +
                            ' ' +
                            DateFormat.LLLL().format(_selectedDay),
                        year: DateFormat.y().format(_selectedDay),
                        month: DateFormat.M().format(_selectedDay),
                        day: DateFormat.d().format(_selectedDay),
                        hour: time.hour.toString(),
                        minute: time.minute.toString(),
                        isFavourite:
                            widget.eventList[widget.index].isFavourite);
                  }
                  widget.eventList.sort((a, b) =>
                      a.convertToDate().compareTo(b.convertToDate()));
                  Map eventMap = ({"events": widget.eventList});
                  await savePref.saveNamedPreference(eventMap, 'events');

                  Navigator.pop(context);
                },
                child: SizedBox(
                  height: screenHeight*0.025,
                  child: FittedBox(
                    child: Text(
                      widget.index > -1 ? 'Update event' : 'Create event',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                )),
          ),
        ),
      ],
    );
  }

  Widget eventFields(double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: calendar(screenHeight,screenHeight),
          ),
          timePicker(screenWidth,screenHeight),
           Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left:12,top: 10,bottom: 5),
              child: SizedBox(
                height: screenHeight*0.03,
                child: const FittedBox(
                  child: Text(
                    'Title',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
          addTitle(screenWidth,screenHeight),
           Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left:12,top: 10,bottom: 5),
              child: SizedBox(
                height: screenHeight*0.03,
                child: const FittedBox(
                  child: Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
          addComment(screenWidth,screenHeight),
        ],
      ),
    );
  }
}
