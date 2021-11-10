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
        print(finalTime);
        await Provider.of<Bookings>(context, listen: false).addBooking(
            loadedArea.id, loadedArea.slots[selectedSlot].name, finalTime);
      } catch (error) {
        print(error);
      }
      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 8,
          shadowColor: Color(0xff675AA7).withOpacity(0.5),
          //backgroundColor: Color(0xff020D26),
          backgroundColor: Colors.white,
          toolbarHeight: 100,
          title: Text(
            loadedArea.name.toUpperCase(),
            style: TextStyle(
              letterSpacing: 1.5,
              color: Color(0xff26C0D6),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          leading: Container(
            child: BackButton(
              color: Colors.black,
            ),
          ),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 45.0),
            child: Container(
              height: 46.0,
              width: 110.0,
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff675AA7).withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                    color: Color(0xffD5DFF2),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: GestureDetector(
                    child: Container(
                        child: Image.asset(
                      'images/clk.gif',
                      width: 50,
                      height: 80,
                    )),
                    onTap: () => pickTime(context),
                  ),
                ),
              ),
            ),

            // title: Text("Choose your Slot: "),
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
                        margin: EdgeInsets.only(left: 15, right: 15),
                        elevation: 0,
                        shadowColor: Color(0xff8E8E8E),
                        shape: Border(
                            top: i == 0 || i == 1
                                ? BorderSide(
                                    width: 2.0,
                                    color: Color(0xff675AA7).withOpacity(0.5),
                                  )
                                : BorderSide(width: 0.0, color: Colors.white),
                            left: i % 2 == 0
                                ? BorderSide(
                                    width: 2.0,
                                    color: Color(0xff675AA7).withOpacity(0.5),
                                  )
                                : BorderSide(width: 0.0, color: Colors.white),
                            right: i % 2 != 0
                                ? BorderSide(
                                    width: 2.0,
                                    color: Color(0xff675AA7).withOpacity(0.5),
                                  )
                                : BorderSide(width: 0.0, color: Colors.white),
                            bottom: BorderSide(
                              width: 2.0,
                              color: Color(0xff675AA7).withOpacity(0.5),
                            )),

                        //   top: BorderSide(
                        //       width: 2.0, color: Colors.lightBlue.shade600),
                        //   left: BorderSide(
                        //       width: 2.0, color: Colors.lightBlue.shade600),
                        // ),
                        color: loadedArea.slots[i].filled
                            ? Colors.white
                            : selectedSlot == i
                                ? Color(0xffD5DFF2)
                                : Colors.white,
                        child: Container(
                          child: Center(
                              child: loadedArea.slots[i].filled
                                  ? Image.asset(
                                      'images/car.png',
                                      width: 50,
                                      height: 80,
                                    )
                                  : Text(
                                      loadedArea.slots[i].name,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xff26C0D6),
                                          fontWeight: FontWeight.w800),
                                    )),
                        ),
                      ),
                    )),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 30,
                    mainAxisExtent: 70,
                    mainAxisSpacing: 0),
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
