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
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 42.0,
                              left: 10.0,
                              right: 10.0,
                              top: 170.0),
                          child: Image.asset(
                            'images/wait.png',
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Text(
                            'Please wait while we scan your number plate.',
                            style: TextStyle(
                              fontFamily: 'Acumin Variable Concept',
                              letterSpacing: 1.3,
                              wordSpacing: 0.2,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    );
                    break;
                  case 'ENTRY SCAN SUCCESS':
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 42.0,
                              left: 10.0,
                              right: 10.0,
                              top: 170.0),
                          child: Image.asset(
                            'images/success.png',
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Text(
                            'Please proceed to slot ${snapdata.data.bookedSlot}. ${snapdata.data.startTime.toString()}',
                            style: TextStyle(
                              fontFamily: 'Acumin Variable Concept',
                              letterSpacing: 1.3,
                              wordSpacing: 0.2,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    );
                    break;
                  case 'EXIT SCAN SUCCESS':
                    return Payment(
                        snapdata.data.price.toInt(),
                        snapdata.data.bookedSlot,
                        snapdata.data.startTime,
                        snapdata.data.endTime,
                        snapdata.data.bookedArea,
                        snapdata.data.bookedCity);
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
                      color: Color.fromRGBO(54, 35, 71, 1)),
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
                              text: '22:00 PM [IST]',
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

  Payment(this.amount, this.slot_no, this.start_time, this.end_time,
      this.booked_area, this.booked_city);
  @override
  Widget build(BuildContext context) {
    void _onPay() {
      Provider.of<Bookings>(context, listen: false).payment();
      Navigator.pushNamedAndRemoveUntil(
          context, '/', (Route<dynamic> route) => false);
    }

    return Container(
        child: Column(
      children: <Widget>[
        Text('Payment'),
        Text('Amount: ${amount}'),
        Text('EndTime:  ${end_time}'),
        Text('SlotNo:  ${slot_no}'),
        Text('Area:  ${booked_area}'),
        Text('City:  ${booked_city}'),
        Text('Starttime: ${start_time.split('T')[1].substring(0, 5)}'),
        Text('Date: ${start_time.split('T')[0]}'),
        SizedBox(height: 20),
        OutlinedButton(onPressed: () => _onPay(), child: Text('Pay Now'))
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    ));
  }
}
