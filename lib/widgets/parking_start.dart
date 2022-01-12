import 'dart:async';
import 'package:flutter/material.dart';

class Park_Start extends StatefulWidget {
  final String slotTime;
  final String booking_date;
  final String start_time;
  final String booked_area;
  final String booked_slot;
  final int price;

  const Park_Start({
    Key key,
    this.slotTime,
    this.booking_date,
    this.start_time,
    this.booked_area,
    this.booked_slot,
    this.price,
  }) : super(key: key);

  @override
  State<Park_Start> createState() => _Park_StartState();
}

class _Park_StartState extends State<Park_Start> {
  String area;
  String s_time;
  String s_slot;
  int b_price;
  Duration duration = Duration();
  Timer timer;
  bool showSuccessTick = true;

  @override
  void initState() {
    super.initState();
    area = widget.booked_area;
    s_time = widget.start_time;
    s_slot = widget.booked_slot;
    b_price = widget.price;

    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void addTime() {
    final addSeconds = 1;
    if (mounted) {
      setState(() {
        final seconds = duration.inSeconds + addSeconds;

        duration = Duration(seconds: seconds);
      });
    } else {
      dispose();
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
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
              shadowColor: Colors.purple.withOpacity(0.6),
              elevation: 30,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Color(0xff916DB0).withOpacity(0.3), width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 105),
              child: Image.asset(
                'images/g.png',
                height: 150,
                width: 150,
              ),
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
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Image.asset(
            'images/car_giff.gif',
            height: 310,
            width: 310,
          ),
        ),
        Container(
          color: Color(0xff351A4D),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "${s_slot}",
                    style: TextStyle(
                        fontFamily: 'Acumin Variable Concept',
                        letterSpacing: 1.3,
                        wordSpacing: 0.2,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff916DB0)),
                  ),
                  Text(
                    "${s_time.split(',')[1].substring(0, 5) + s_time.split(',')[1].substring(
                          8,
                        )}",
                    style: TextStyle(
                        fontFamily: 'Acumin Variable Concept',
                        letterSpacing: 1.3,
                        wordSpacing: 0.2,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff916DB0)),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
            color: Color(0xff351A4D),
            height: 169,
            child: RichText(
                overflow: TextOverflow.clip,
                maxLines: 8,
                textAlign: TextAlign.center,
                textHeightBehavior:
                    TextHeightBehavior(applyHeightToFirstAscent: false),
                text: TextSpan(
                    text:
                        '\n${duration.inHours == null ? '00' : duration.inHours.toString().padLeft(2, '0')} : ${duration.inMinutes == null ? '00' : duration.inMinutes.toString().padLeft(2, '0')} : ${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}\n',
                    style: TextStyle(
                        fontFamily: 'Acumin Variable Concept',
                        letterSpacing: 1.3,
                        wordSpacing: 0.2,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                    children: [
                      WidgetSpan(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Parking Time'.toUpperCase(),
                                  style: TextStyle(
                                    fontFamily: 'Acumin Variable Concept',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.3),
                                    letterSpacing: 2,
                                    wordSpacing: 0.5,
                                  )))),
                    ])))
      ],
    );
  }
}
