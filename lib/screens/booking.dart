import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bookings.dart';

//import '../widgets/before_parking.dart';
//import '../widgets/payment_page.dart';
//import '../widgets/parking_start.dart';
import '../widgets/reach.dart';

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
                  /*case 'WAIT FOR SCAN':
                    return Before_Park(
                      snapdata.data.bookedSlot,
                      snapdata.data.bookedArea,
                      snapdata.data.slotTime,
                    );
                    break;*/
                  case 'ENTRY SCAN SUCCESS':
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 100, 5, 138),
                          child: Image.asset(
                            'images/success.png',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 40),
                          child: Text(
                            "Your Number Plate Scan is Successful",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 15,
                                letterSpacing: 0.5,
                                wordSpacing: 0.2,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 100,
                          ),
                        ),
                      ],
                    );
                    break;

                  /*case 'EXIT SCAN SUCCESS':
                    return Payment(
                        snapdata.data.price.toInt(),
                        snapdata.data.bookedSlot,
                        snapdata.data.startTime,
                        snapdata.data.endTime,
                        snapdata.data.bookedArea,
                        snapdata.data.bookedCity,
                        snapdata.data.id);
                    break;*/

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

/*class Before_Park extends StatelessWidget {
  final String slot_no;
  final String booked_area;
  final String slot_time;
  Before_Park(this.slot_no, this.booked_area, this.slot_time);

  @override
  Widget build(BuildContext context) {
    return before_park(slot_no, booked_area, slot_time);
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
    return Parking(amount, slot_no, start_time, end_time, booked_area,
        booked_city, book_id);

    /*payment(amount, slot_no, start_time, end_time, booked_area,
        booked_city, book_id);*/
  }
}*/
