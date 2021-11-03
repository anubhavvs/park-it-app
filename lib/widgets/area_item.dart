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
    return ListTile(
      leading: Text(freeSlots().toString()),
      title: Text(name),
      subtitle: Text(city),
      trailing: OutlinedButton(
        child: Text('Reserve'),
        onPressed: () => {
          Navigator.of(context)
              .pushNamed(AreaSlotScreen.routeName, arguments: id)
        },
      ),
    );
  }
}
