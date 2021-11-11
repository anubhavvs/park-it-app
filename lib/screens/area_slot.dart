import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/areas.dart';
import '../providers/bookings.dart';

class AreaSlotScreen extends StatefulWidget {
  static const routeName = '/area-slot';

  @override
  State<AreaSlotScreen> createState() => _AreaSlotScreenState();
}

class _AreaSlotScreenState extends State<AreaSlotScreen> {
  Future<void> _refreshSlots(BuildContext context) async {
    await Provider.of<Areas>(context, listen: false).fetchAndSetAreas();
  }

  double advancedTime = 1;

  void _showErrorDialog(String message, String error) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(error),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Okay'))
              ],
            ));
  }

  int selectedSlot = -1;
  TimeOfDay selectedTime = null;
  String finalTime;
  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
  var _isLoading = false;

  Future pickTime(BuildContext context) async {
    final initialTime = selectedTime ?? TimeOfDay.now();
    final newTime =
        await showTimePicker(context: context, initialTime: initialTime);
    if (newTime == null) return;
    if (toDouble(newTime) - toDouble(initialTime) < advancedTime) {
      _showErrorDialog(
          'Prior booking takes ${advancedTime.toInt()} hour at least.',
          'Invalid Time!');
      return;
    }
    setState(() {
      selectedTime = newTime;
      finalTime =
          '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final areadId = ModalRoute.of(context).settings.arguments as String;
    final loadedArea = Provider.of<Areas>(context).findById(areadId);

    Future<void> _submit() async {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Bookings>(context, listen: false).addBooking(
            loadedArea.id, loadedArea.slots[selectedSlot].name, finalTime);
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/booking', ModalRoute.withName('/'));
      } catch (error) {
        print(error);
      }
      setState(() {
        _isLoading = false;
      });
    }

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
                        margin: EdgeInsets.only(left: 10, right: 10),
                        elevation: 0,
                        shadowColor: Colors.black,
                        shape: Border(
                            top: BorderSide(
                                width: 2.0, color: Colors.lightBlue.shade600),
                            left: i % 2 == 0
                                ? BorderSide(
                                    width: 2.0,
                                    color: Colors.lightBlue.shade600)
                                : BorderSide(width: 0.0, color: Colors.white),
                            right: i % 2 != 0
                                ? BorderSide(
                                    width: 2.0,
                                    color: Colors.lightBlue.shade600)
                                : BorderSide(width: 0.0, color: Colors.white),
                            bottom: BorderSide(
                                width: 2.0, color: Colors.lightBlue.shade600)),
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
          Center(
              child: Card(
                  margin: EdgeInsets.all(10),
                  color: Colors.blueGrey,
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(loadedArea.name),
                              if (selectedTime != null)
                                Text('${selectedTime.format(context)}'),
                              if (selectedSlot != -1)
                                Text('${loadedArea.slots[selectedSlot].name}'),
                              Text('Rs. ${loadedArea.price.toString()}/hour'),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              child: Text('BOOK NOW'),
                              onPressed: selectedSlot == -1 ||
                                      selectedTime == null ||
                                      _isLoading
                                  ? null
                                  : () => _submit(),
                            ),
                          )
                        ],
                      ))))
        ]));
  }
}
