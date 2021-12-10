import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:intl/intl.dart';

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
  DateTime endDate;
  String dateTime;
  int endTime;
  int bufferEndTime;
  DateTime date_at;
  String area;
  String s_time;
  String s_slot;
  int b_price;

  @override
  void initState() {
    dateTime = DateFormat("yyyy-MM-dd").format(DateTime.now());
    dateTime = dateTime + ' ' + widget.slotTime + ':00';
    endDate = new DateFormat('yyyy-MM-dd hh:mm:ss').parse(dateTime);
    endTime = endDate.millisecondsSinceEpoch;
    date_at =
        new DateFormat('yyyy-MM-dd').parse(widget.booking_date.split('T')[0]);
    area = widget.booked_area;
    s_time = widget.start_time;
    s_slot = widget.booked_slot;
    b_price = widget.price;
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
                    "\u{20B9}${b_price}/hr",
                    style: TextStyle(
                        fontFamily: 'Acumin Variable Concept',
                        letterSpacing: 1.3,
                        wordSpacing: 0.2,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff916DB0)),
                  ),
                  Text(
                    "${s_time.split('T')[1].substring(0, 5)}",
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
            child: CountdownTimer(
          endTime: endTime,
          onEnd: onEnd,
          widgetBuilder: (_, CurrentRemainingTime time) {
            if (time == null) {
              return CountdownTimer(
                endTime: bufferEndTime,
                widgetBuilder: (_, CurrentRemainingTime time) {
                  if (time == null) {
                    return Column(
                      children: <Widget>[
                        RichText(
                          overflow: TextOverflow.clip,
                          maxLines: 8,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: 'Booking Expired\n',
                              style: TextStyle(
                                  fontFamily: 'Acumin Variable Concept',
                                  wordSpacing: 0.2,
                                  fontSize: 25.0,
                                  height: 1.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red),
                              children: [
                                TextSpan(
                                    text: 'Please book another slot.\n\n',
                                    style: TextStyle(
                                        fontFamily: 'Acumin Variable Concept',
                                        letterSpacing: 1.3,
                                        wordSpacing: 0.2,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red)),
                                WidgetSpan(
                                    child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Center(
                                    child: ElevatedButton(
                                      clipBehavior: Clip.antiAlias,
                                      style: OutlinedButton.styleFrom(
                                          backgroundColor: Color(0xff351A4D),
                                          shadowColor:
                                              Colors.purple.withOpacity(0.4),
                                          elevation: 10,
                                          side: BorderSide(
                                              color: Color(0xff351A4D),
                                              width: 3),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          minimumSize: Size(208, 42)),
                                      onPressed: onBufferEnd,
                                      child: Text(
                                        'HOME',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          wordSpacing: 0.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                                TextSpan(
                                    text: 'Tap the button to return to Home',
                                    style: TextStyle(
                                      fontFamily: 'Acumin Variable Concept',
                                      letterSpacing: 0.5,
                                      wordSpacing: 0.2,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black.withOpacity(0.4),
                                    )),
                              ]),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    );
                  }
                  return RichText(
                      overflow: TextOverflow.clip,
                      maxLines: 8,
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text:
                              '\n${time.hours == null ? '00' : time.hours.toString().padLeft(2, '0')} : ${time.min == null ? '00' : time.min.toString().padLeft(2, '0')} : ${time.sec.toString().padLeft(2, '0')}\n\n',
                          style: TextStyle(
                              fontFamily: 'Acumin Variable Concept',
                              letterSpacing: 1.3,
                              wordSpacing: 0.2,
                              fontSize: 35.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.red),
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.error_outline_sharp,
                                size: 25,
                              ),
                            ),
                            TextSpan(
                                text: 'Your slot time ',
                                style: TextStyle(
                                    fontFamily: 'Acumin Variable Concept',
                                    letterSpacing: 1.3,
                                    wordSpacing: 0.2,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.red)),
                          ]));
                },
              );
            }
            return Container(
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
                          '\n${time.hours == null ? '00' : time.hours.toString().padLeft(2, '0')} : ${time.min == null ? '00' : time.min.toString().padLeft(2, '0')} : ${time.sec.toString().padLeft(2, '0')}\n',
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
                      ])),
            );
          },
        ))
      ],
    );
  }
}
