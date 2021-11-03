import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

class BookingItem with ChangeNotifier {
  final String id;
  final String bookedCity;
  final String bookedArea;
  final String bookedSlot;
  final String slotTime;
  final DateTime startTime;
  final DateTime endTime;
  final double price;
  final bool paid;

  BookingItem({
    @required this.id,
    @required this.bookedCity,
    @required this.bookedArea,
    @required this.bookedSlot,
    @required this.slotTime,
    @required this.startTime,
    @required this.endTime,
    @required this.price,
    @required this.paid,
  });
}

class Bookings with ChangeNotifier {
  List<BookingItem> _bookings = [];
  String _authToken;
  String userId;

  List<BookingItem> get bookings {
    return [..._bookings];
  }

  Future<void> addBooking(
      String areaId, String slotName, String slotTime) async {
    var url =
        FlutterConfig.get('API_URL') + '/booking/' + areaId + '/' + slotName;
    var uri = Uri.parse(url);
    try {
      final response =
          http.post(uri, headers: {'Authorization': 'Bearer ' + _authToken});
    } catch (error) {
      print(error);
    }
  }
}
