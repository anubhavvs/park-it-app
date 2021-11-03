import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/areas.dart';

class AreaSlotScreen extends StatefulWidget {
  static const routeName = '/area-slot';

  @override
  State<AreaSlotScreen> createState() => _AreaSlotScreenState();
}

class _AreaSlotScreenState extends State<AreaSlotScreen> {
  Future<void> _refreshSlots(BuildContext context) async {
    await Provider.of<Areas>(context, listen: false).fetchAndSetAreas();
  }

  int selectedSlot = -1;
  TimeOfDay selectedTime;

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay.now();
    final newTime =
        await showTimePicker(context: context, initialTime: initialTime);
    if (newTime == null) return;
    setState(() {
      selectedTime = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    final areadId = ModalRoute.of(context).settings.arguments as String;
    final loadedArea = Provider.of<Areas>(context).findById(areadId);
    return Scaffold(
        appBar: AppBar(
          title: Text(loadedArea.name),
        ),
        body: Column(children: [
          GestureDetector(
            child: Container(
              child: Icon(Icons.access_time),
              margin: EdgeInsets.only(top: 20, bottom: 20),
            ),
            onTap: () => pickTime(context),
          ),
          Flexible(
            child: RefreshIndicator(
              onRefresh: () => _refreshSlots(context),
              child: GridView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: loadedArea.slots.length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                    value: loadedArea.slots[i],
                    child: GestureDetector(
                      onTap: loadedArea.slots[i].filled
                          ? null
                          : () {
                              setState(() {
                                if (selectedSlot == i) {
                                  selectedSlot = -1;
                                } else {
                                  selectedSlot = i;
                                }
                              });
                            },
                      child: Card(
                        color: loadedArea.slots[i].filled
                            ? Colors.red
                            : selectedSlot == i
                                ? Colors.green
                                : Colors.white54,
                        child: Container(
                          child: Center(
                              child: loadedArea.slots[i].filled
                                  ? Icon(Icons.time_to_leave_outlined)
                                  : Text(
                                      loadedArea.slots[i].name,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800),
                                    )),
                        ),
                      ),
                    )),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 5,
                    mainAxisExtent: 90,
                    mainAxisSpacing: 5),
              ),
            ),
          ),
        ]));
  }
}
