import 'dart:async';
import 'package:flutter/material.dart';
import 'package:park_it/widgets/parking_start.dart';
import 'package:provider/provider.dart';

import '../providers/bookings.dart';

import '../widgets/wait.dart';
import '../widgets/payment_page.dart';
import '../widgets/parking_start.dart';
import '../widgets/reach.dart';

class BookingScreen extends StatefulWidget {
  static const routeName = '/booking';
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  var _isInit = true;

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
                    return TimerWidegt(
                      slotTime: snapdata.data.slotTime,
                      booking_date: snapdata.data.created_at,
                      start_time: snapdata.data.startTime,
                      booked_area: snapdata.data.bookedArea,
                    );

                    break;
                  case 'WAIT FOR SCAN':
                    return For_Scan(
                      slotTime: snapdata.data.slotTime,
                      booking_date: snapdata.data.created_at,
                      booked_area: snapdata.data.bookedArea,
                    );
                    break;
                  case 'ENTRY SCAN SUCCESS':
                    return Park_Start(
                      slotTime: snapdata.data.slotTime,
                      booking_date: snapdata.data.created_at,
                      start_time: snapdata.data.startTime,
                      booked_area: snapdata.data.bookedArea,
                      booked_slot: snapdata.data.bookedSlot,
                      price: snapdata.data.price,
                    );
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
                    return Text('Please clear app storage and relaunch.');
                }
            }
          },
        )),
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
