import 'package:flutter/material.dart';
import '../screens/area_slot.dart';

class AreaItem extends StatelessWidget {
  final String id;
  final String name;
  final String city;
  final int numSlots;

  AreaItem(this.id, this.name, this.city, this.numSlots);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(numSlots.toString()),
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
