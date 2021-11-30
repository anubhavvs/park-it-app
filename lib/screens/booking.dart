import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bookings.dart';

class BookingScreen extends StatefulWidget {
  static const routeName = '/booking';
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  var _isInit = true;
  TimeOfDay finalTime;

  StreamController<BookingItem> _streamController = StreamController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (this.mounted) {
        Timer.periodic(Duration(seconds: 5), (timer) {
          Provider.of<Bookings>(context, listen: false)
              .fetchAndSetActiveBooking()
              .then((value) {
            _streamController.sink.add(value);
            finalTime = TimeOfDay(
                hour: int.parse(value.slotTime.split(":")[0]),
                minute: int.parse(value.slotTime.split(":")[1]));
          });
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: StreamBuilder<BookingItem>(
          stream: _streamController.stream,
          builder: (context, snapdata) {
            switch (snapdata.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                switch (snapdata.data.status) {
                  case 'REACH ON TIME':
                    return TimerWidegt(finalTime);
                    break;
                  case 'WAIT FOR SCAN':
                    return Text('Please wait while we scan your number plate.');
                    break;
                  case 'ENTRY SCAN SUCCESS':
                    return Center(
                        child: Text(
                            'Please proceed to slot ${snapdata.data.bookedSlot}. ${snapdata.data.startTime.toString()}'));
                    break;
                  case 'EXIT SCAN SUCCESS':
                    return Payment(
                        snapdata.data.price.toInt(),
                        snapdata.data.bookedSlot,
                        snapdata.data.startTime,
                        snapdata.data.endTime,
                        snapdata.data.bookedArea,
                        snapdata.data.bookedCity,
                        snapdata.data.id);
                    break;
                  default:
                    return Text('Please Wait');
                }
            }
          },
        )),
      ),
    );
  }
}

class TimerWidegt extends StatelessWidget {
  final TimeOfDay time;
  TimerWidegt(this.time);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 50, right: 50),
      child: Column(
        children: <Widget>[
          Image.asset(
            'images/reach_1.png',
            width: 372,
            height: 370,
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: RichText(
              overflow: TextOverflow.clip,
              maxLines: 4,
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'Your Booking Details:\n\n',
                  style: TextStyle(
                      fontFamily: 'Acumin Variable Concept',
                      letterSpacing: 1.3,
                      wordSpacing: 0.2,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Monday | 22/11/2021\n',
                        style: TextStyle(
                          fontFamily: 'Acumin Variable Concept',
                          letterSpacing: 1.3,
                          wordSpacing: 0.2,
                          fontSize: 16.0,
                          color: Color.fromRGBO(162, 162, 162, 1),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Slot Time : 22:00',
                              style: TextStyle(
                                fontFamily: 'Acumin Variable Concept',
                                letterSpacing: 1.3,
                                wordSpacing: 0.2,
                                fontSize: 15.0,
                                color: Colors.grey,
                              )),
                        ]),
                  ]),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 0, left: 20, right: 20),
            child: RichText(
                overflow: TextOverflow.clip,
                maxLines: 8,
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: '\n00 : 04 : 47\n\n',
                    style: TextStyle(
                        fontFamily: 'Acumin Variable Concept',
                        letterSpacing: 1.3,
                        wordSpacing: 0.2,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'PLEASE REACH YOUR PARKING SPOT ON TIME',
                          style: TextStyle(
                              fontFamily: 'Acumin Variable Concept',
                              letterSpacing: 1.3,
                              wordSpacing: 0.2,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff916DB0))),
                    ])),
          )
        ],
      ),
    );
  }
}

class ParkingStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Payment extends StatelessWidget {
  final int amount;
  final String slot_no;
  final String start_time;
  final String end_time;
  final String booked_area;
  final String booked_city;
  final String book_id;

  Payment(this.amount, this.slot_no, this.start_time, this.end_time,
      this.booked_area, this.booked_city, this.book_id);
  @override
  Widget build(BuildContext context) {
    void _onPay() {
      Provider.of<Bookings>(context, listen: false).payment();
      Navigator.pushNamedAndRemoveUntil(
          context, '/', (Route<dynamic> route) => false);
    }

    return Container(

        // color: Color(0xff7851a9),
        child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'CHECK - OUT  ',
                  style: TextStyle(
                      color: Color(0xff916DB0),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3),
                ),
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
            child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Color(0xff916DB0).withOpacity(0.3), width: 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                color: Colors.white,
                elevation: 18.0,
                shadowColor: Colors.purple.withOpacity(0.4),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      // padding: EdgeInsets.all(26.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Ticket Details",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff351A4D),
                          // fontFamily: 'Acumin Variable Concept',
                          letterSpacing: 1.5,
                          wordSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 28, 18, 0),
            child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Color(0xff916DB0).withOpacity(0.3), width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.white,
                elevation: 18.0,
                shadowColor: Colors.purple.withOpacity(0.4),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 15, 18, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "ID",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 1.5,
                              wordSpacing: 0.2,
                            ),
                          ),
                          Text(
                            "#${book_id.split(':')[0].substring(12, 24).toUpperCase()}",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 1.5,
                              wordSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1.2,
                      height: 25,
                      indent: 0,
                      endIndent: 0,
                      color: Color(0xff916DB0).withOpacity(0.3),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Area",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            "${booked_area}",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "City",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            "${booked_city}",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Slot No",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            "${slot_no}",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Entry Time",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            "${start_time.split('T')[1].substring(0, 5)}",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Exit Time",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            "${end_time.split('T')[1].substring(0, 5)}",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Date",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            "${start_time.split('T')[0]}",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Amount",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            "\u{20B9}${amount}",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Bill Amount",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 1.5,
                              wordSpacing: 0.2,
                            ),
                          ),
                          Text(
                            "\u{20B9}${amount}",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 1.5,
                              wordSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 5),
                      child: Image.asset(
                        'images/bar.png',
                        width: 200,
                        height: 90,
                      ),
                    ),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 35, 18, 0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: Color(0xff916DB0),
                  side: BorderSide(color: Color(0xff916DB0), width: 1.5),
                  minimumSize: Size(310, 48)),
              onPressed: () => _onPay(),
              child: Text(
                'PAY  \u{20B9}${amount}',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  wordSpacing: 0.2,
                ),
              ),
            ),
          )
        ])));
  }
}
