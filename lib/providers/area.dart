import 'package:flutter/foundation.dart';

class Slot with ChangeNotifier {
  final String id;
  final String name;
  final bool filled;

  Slot({@required this.id, @required this.name, @required this.filled});
}

class Area {
  final String id;
  final String name;
  final String city;
  final int numSlots;
  final int price;
  final List<Slot> slots;

  Area(
      {@required this.id,
      @required this.city,
      @required this.name,
      @required this.numSlots,
      @required this.slots,
      @required this.price});
}
