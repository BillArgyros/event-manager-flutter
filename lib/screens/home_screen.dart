import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schedule/screens/event_manager_screen.dart';
import 'package:schedule/services/shared_pref.dart';
import '../models/event_model.dart';
import 'package:schedule/home_widgets/pop_up_menu.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<EventModel> eventList = [];
  late EventModel currentEvent;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPref prefs = SharedPref();
  var index = 0;
  String dropDownValue = 'Month';
   Color addButtonColor = const Color.fromRGBO(144, 85, 255,1);
   Color popUpMenuColor = const Color.fromRGBO(144, 85, 255,1);
   Gradient cardColor = const LinearGradient(
       begin: Alignment.topLeft,
       end: Alignment.bottomRight,
       colors: [
         Color.fromRGBO(144, 85, 255,1),
         Color.fromRGBO(9, 226, 218,1),
       ]
   );
   Color backGroundColor = const Color.fromRGBO(246, 249, 251, 1);
   Color drawerColor = const Color.fromRGBO(246, 249, 251, 1);

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: backGroundColor,
        drawer: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(0),
          ),
          child: SizedBox(
            width: screenWidth * 0.7,
            child: Drawer(
              backgroundColor: drawerColor,
              child: drawerWidget(context, screenWidth, screenHeight, user),
            ),
          ),
        ),
        body: SizedBox(
          width: screenWidth * 1,
          height: screenHeight * 1,
          child: Stack(
            children: [
              getEventList(screenWidth, screenHeight),
              createEventButton(screenWidth, screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  void getPrefs() {
    prefs.getNamedPreference('events').then((value) {
      setState(() {
        eventList = [];
      });
      if (value.isNotEmpty) {
        value['events'].forEach((element) {
          EventModel newEvent = EventModel(
              title: element['title'],
              description: element['description'],
              time: element['time'],
              date: element['date'],
              year: element['year'],
              month: element['month'],
              day: element['day'],
              hour: element['hour'],
              minute: element['minute'],
              isFavourite: element['isFavourite']);
          setState(() {
            eventList.add(newEvent);
          });
        });
      }
    });
  }

  void savePrefs() {
    Map eventMap = ({"events": eventList});
    prefs.saveNamedPreference(eventMap, 'events');
  }

  Widget drawerWidget(BuildContext context, screenWidth, screenHeight, user) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              SizedBox(
                width: screenWidth * 1,
                height: screenHeight * 0.06,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      index = 0;
                      _scaffoldKey.currentState?.openEndDrawer();
                    });
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              height: screenHeight * 0.035,
                              child: const FittedBox(
                                child: Icon(
                                  Icons.home_outlined,
                                  color: Colors.black,
                                ),
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 5.0),
                        child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: screenWidth * 0.3,
                              height: screenHeight * 0.025,
                              child: const FittedBox(
                                child: Text(
                                  'Home',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth * 1,
                height: screenHeight * 0.06,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      index = 1;
                      _scaffoldKey.currentState?.openEndDrawer();
                    });
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                                height: screenHeight * 0.035,
                                child: const FittedBox(
                                    child: Icon(Icons.history,
                                        color: Colors.blue)))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 5.0),
                        child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: screenWidth * 0.3,
                              height: screenHeight * 0.025,
                              child: const FittedBox(
                                child: Text('Expired',
                                    style: TextStyle(color: Colors.black)),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth * 1,
                height: screenHeight * 0.06,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      index = 2;
                      _scaffoldKey.currentState?.openEndDrawer();
                    });
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                                height: screenHeight * 0.035,
                                child: const FittedBox(
                                    child: Icon(Icons.favorite,
                                        color: Colors.red)))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 5.0),
                        child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: screenWidth * 0.35,
                              height: screenHeight * 0.025,
                              child: const FittedBox(
                                child: Text('Favourites',
                                    style: TextStyle(color: Colors.black)),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget manageEvents(
      screenWidth, screenHeight, EventModel event, isEditAvailable) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: SizedBox(
            width: screenWidth * 0.9,
            height: screenHeight * 0.22,
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.25,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.transparent,
                      elevation: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: cardColor
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                        width: screenWidth * 0.6,
                                        height: screenHeight * 0.025,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            child: Text(
                                              event.title,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      width: screenWidth * 0.15,
                                      height: screenHeight * 0.018,
                                      child: FittedBox(
                                        child: Text(
                                          event.time,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    event.description,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.5)),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 2.0),
                                        child: SizedBox(
                                          height: screenHeight * 0.022,
                                          width: screenWidth * 0.6,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: SizedBox(
                                              child: FittedBox(
                                                child: Text(
                                                  event.date + " " + event.year,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: screenWidth * 0.2,
                                        height: screenHeight * 0.07,
                                        child: popUpMenu(event, isEditAvailable,
                                            screenWidth, screenHeight),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget dateRangeMenu(screenWidth, screenHeight) {
    if (index == 0) {
      return Padding(
        padding: const EdgeInsets.only(right: 30.0, top: 10),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: screenWidth * 0.3,
            height: screenHeight * 0.035,
            decoration:ShapeDecoration(
              color: popUpMenuColor,
              shape: const RoundedRectangleBorder(
                side: BorderSide(width: 1.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
            ),
            child: FittedBox(
              child: PopupMenuButton(
                elevation: 10,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: SizedBox(
                          width: screenWidth * 0.2,
                          height: screenHeight * 0.025,
                          child: FittedBox(
                              child: Text(dropDownValue,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: SizedBox(
                            width: screenWidth * 0.08,
                            child: const FittedBox(
                                child:
                                     Icon(Icons.keyboard_arrow_down))),
                      )
                    ],
                  ),
                ),
                offset: Offset(0, screenHeight * 0.06),
                itemBuilder: (context) {
                  return [
                    PopupMenuWidget(
                      height: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 10.0, top: 5),
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    dropDownValue = 'Today';
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: SizedBox(
                                    width: screenWidth * 0.2,
                                    height: screenHeight * 0.025,
                                    child: Center(
                                        child: FittedBox(
                                            child: Text(
                                      'Today',
                                      style: TextStyle(
                                        fontWeight: dropDownValue == 'Today'
                                            ? FontWeight.bold
                                            : null,
                                      ),
                                    ))))),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    dropDownValue = 'Month';
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: SizedBox(
                                  width: screenWidth * 0.2,
                                  height: screenHeight * 0.025,
                                  child: Center(
                                      child: FittedBox(
                                    child: Text('Month',
                                        style: TextStyle(
                                          fontWeight: dropDownValue == 'Month'
                                              ? FontWeight.bold
                                              : null,
                                        )),
                                  )),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    dropDownValue = 'All Events';
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: SizedBox(
                                    width: screenWidth * 0.2,
                                    height: screenHeight * 0.025,
                                    child: Center(
                                        child: FittedBox(
                                            child: Text('All Events',
                                                style: TextStyle(
                                                  fontWeight: dropDownValue ==
                                                          'All Events'
                                                      ? FontWeight.bold
                                                      : null,
                                                )))))),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ),
          ),
        ),
      );
    } else if (index == 1) {
      return const Padding(
        padding: EdgeInsets.only(left: 10.0, top: 14),
        child: Align(
            alignment: Alignment.center,
            child: Text(
              'Completed Events',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            )),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.only(left: 10.0, top: 14),
        child: Align(
            alignment: Alignment.center,
            child: Text(
              'Favourite Events',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            )),
      );
    }
  }

  Widget getEventList(screenWidth, screenHeight) {
    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  height: screenHeight * 0.07,
                  child: FittedBox(
                    child: IconButton(
                      icon:  const Icon(Icons.menu,color: Color.fromRGBO(144, 85, 255,1),),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                  ),
                ),
              ),
            ),
            dateRangeMenu(screenWidth, screenHeight),
          ],
        ),
        SizedBox(
          height: screenHeight * 0.05,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: ListView.builder(
                itemCount: eventList.length,
                itemBuilder: (context, index) => getEvents(
                    eventList[index], screenWidth, screenHeight)),
          ),
        ),
        // SizedBox(
        //   height: screenHeight * 0.1,
        // )
      ],
    );
  }

  Widget getEvents(
      EventModel event, double screenWidth, double screenHeight) {
    bool isEditAvailable;
    var date = DateTime.now();
    var lastDayOfWeek =
        date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
    if (index == 2) {
      if (event.convertToDate().isBefore(DateTime.now())) {
        isEditAvailable = false;
      } else {
        isEditAvailable = true;
      }
      return event.isFavourite
          ? manageEvents(
              screenWidth, screenHeight, event, isEditAvailable)
          : const SizedBox();
    } else {
      if (event.convertToDate().isBefore(DateTime.now())) {
        isEditAvailable = false;
        return index == 1
            ? manageEvents(
                screenWidth, screenHeight, event, isEditAvailable)
            : const SizedBox();
      } else {
        isEditAvailable = true;
        if (index == 0) {
          if (dropDownValue == 'Today') {
            if (event.day == date.day.toString() &&
                event.month == date.month.toString() &&
                event.year == date.year.toString()) {
              return manageEvents(
                  screenWidth, screenHeight, event, isEditAvailable);
            } else {
              return const SizedBox();
            }
          } else if (dropDownValue == 'Month') {
            if (event.month == date.month.toString() &&
                event.year == date.year.toString()) {
              return manageEvents(
                  screenWidth, screenHeight, event, isEditAvailable);
            } else {
              return const SizedBox();
            }
          } else {
            return manageEvents(
                screenWidth, screenHeight, event, isEditAvailable);
          }
        } else {
          return const SizedBox();
        }
      }
    }
  }

  Widget createEventButton(
      double screenWidth, double screenHeight) {
    return index == 0
        ? Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0, right: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: addButtonColor,
                  shape: const CircleBorder(),
                ),
                child: SizedBox(
                  height: screenHeight * 0.05,
                  child: const FittedBox(
                    child: Icon(
                      Icons.add,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ManageScreen(eventList: eventList)),
                  ).then((value) => getPrefs());
                },
              ),
            ),
          )
        : const SizedBox();
  }

  Widget popUpMenu(
      EventModel event, isEditAvailable, screenWidth, screenHeight) {
    return Padding(
      padding: const EdgeInsets.only(top: 23.0, left: 20),
      child: PopupMenuButton(
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(32.0),
          ),
        ),
        icon: const Icon(Icons.menu),
        offset: Offset(0, screenHeight * 0.07),
        itemBuilder: (context) {
          return [
            PopupMenuWidget(
              height: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isEditAvailable
                      ? Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ManageScreen.fromEdit(
                                          eventList: eventList,
                                          index: eventList.indexWhere(
                                              (element) => element == event),
                                        )),
                              ).then((value) => getPrefs());
                            },
                            highlightColor: Colors.transparent,
                            child: SizedBox(
                              height: screenHeight * 0.03,
                              child: const FittedBox(
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                event.isFavourite = !event.isFavourite;
                              });
                              savePrefs();
                              getPrefs();
                              Navigator.of(context).pop();
                            },
                            highlightColor: Colors.transparent,
                            child: SizedBox(
                              height: screenHeight * 0.03,
                              child: FittedBox(
                                child: Icon(
                                  event.isFavourite
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                  isEditAvailable
                      ? Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                event.isFavourite = !event.isFavourite;
                              });
                              savePrefs();
                              getPrefs();
                              Navigator.of(context).pop();
                            },
                            highlightColor: Colors.transparent,
                            child: SizedBox(
                              height: screenHeight * 0.03,
                              child: FittedBox(
                                child: Icon(
                                  event.isFavourite
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        eventList.remove(event);
                        savePrefs();
                        getPrefs();
                        Navigator.of(context).pop();
                      },
                      highlightColor: Colors.transparent,
                      child: SizedBox(
                        height: screenHeight * 0.03,
                        child: const FittedBox(
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }
}
