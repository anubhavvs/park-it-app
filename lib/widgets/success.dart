import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class Tick extends StatefulWidget {
  final String slotTime;
  final String booking_date;
  final String start_time;
  final String booked_area;

  const Tick(
      {Key key,
      this.slotTime,
      this.booking_date,
      this.start_time,
      this.booked_area})
      : super(key: key);

  @override
  State<Tick> createState() => _TickState();
}

class _TickState extends State<Tick> {
  DateTime endDate;
  String dateTime;
  int endTime;
  int bufferEndTime;
  DateTime date_at;
  String area;

  @override
  void initState() {
    super.initState();
    dateTime = DateFormat("yyyy-MM-dd").format(DateTime.now());
    dateTime = dateTime + ' ' + widget.slotTime + ':00';
    endDate = new DateFormat('yyyy-MM-dd hh:mm:ss').parse(dateTime);
    endTime = endDate.millisecondsSinceEpoch;
    date_at =
        new DateFormat('dd/MM/yyyy').parse(widget.booking_date.split(',')[0]);
    area = widget.booked_area;
  }

  void onEnd() {
    bufferEndTime = endTime + 1000 * 60 * 30;
  }

  void onBufferEnd() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 175,
            child: AppBar(
              backgroundColor: Color(0xff351A4D),
              title: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  '${area}'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5),
                ),
              ),
              centerTitle: true,
              elevation: 25,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Card(
              color: Colors.white,
              child: _hori_card(),
              margin: EdgeInsets.fromLTRB(26, 0, 26, 55),
              shadowColor: Colors.purple.withOpacity(0.4),
              elevation: 25,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Color(0xff916DB0).withOpacity(0.3), width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
            ),
          )
        ],
      ),
    );
  }

  _hori_card() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Image.asset(
            'images/success.png',
            height: 150,
            width: 150,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
          child: Image.asset(
            'images/tick.gif',
            height: 200,
            width: 200,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            'Number Plate Scan\n Successful',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.4),
              letterSpacing: 1.5,
              wordSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }
}
