import 'package:flutter/material.dart';

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
