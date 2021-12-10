import 'package:flutter/material.dart';
import 'package:park_it/providers/bookings.dart';
import 'package:provider/provider.dart';

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
