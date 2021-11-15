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
                    return Payment(snapdata.data.price.toInt());
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
    return Text(time.toString());
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
  Payment(this.amount);
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
        SizedBox(height: 20),
        OutlinedButton(onPressed: () => _onPay(), child: Text('Pay Now'))
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    ));
  }
}
