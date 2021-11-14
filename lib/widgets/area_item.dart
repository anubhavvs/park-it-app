import 'package:flutter/material.dart';
import '../providers/area.dart';
import '../screens/area_slot.dart';

class AreaItem extends StatelessWidget {
  final String id;
  final String name;
  final String city;
  final int numSlots;
  final int price;
  final List<Slot> slots;

  AreaItem(
      this.id, this.name, this.city, this.numSlots, this.price, this.slots);

  int freeSlots() {
    int free = 0;
    slots.forEach((i) {
      if (!i.filled) {
        free++;
      }
    });
    return free;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color(0xffD5DFF2).withOpacity(1.0),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ]),
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          shape: RoundedRectangleBorder(
              //side: BorderSide(color: Colors.blue, width: 0.0),
              borderRadius: BorderRadius.circular(5.0)),
          /*leading: Text(
            '\n${freeSlots().toString()}',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),*/
          title: Text(
            '${name}' ' | ${city}',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.5),
          ),
          tileColor: Color(0xffD5DFF2),
          subtitle: Text('Available Spots : ${freeSlots().toString()}',
              style: TextStyle(color: Color(0xff5b3a68))),
          trailing: OutlinedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.6)),
            child: Text(
              'RESERVE',
              style: TextStyle(
                color: Colors.black,
                letterSpacing: 0.6,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => {
              Navigator.of(context)
                  .pushNamed(AreaSlotScreen.routeName, arguments: id)
            },
          ),
        ),
      ),
    );
  }
}

/* '${freeSlots().toString()}',*/
