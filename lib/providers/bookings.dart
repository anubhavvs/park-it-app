import 'dart:convert';

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

  set authToken(String value) {
    _authToken = value;
  }

  List<BookingItem> get bookings {
    return [..._bookings];
  }

  Future<void> addBooking(
      String areaId, String slotName, String slotTime) async {
    var url = '${FlutterConfig.get('API_URL')}/booking/${areaId}/${slotName}';
    var uri = Uri.parse(url);
    try {
      final response = await http.post(uri,
          body: json.encode({'slotTime': slotTime}),
          headers: {
            'Authorization': 'Bearer ' + _authToken,
            "Content-Type": "application/json"
          });
      var finalRes = json.decode(response.body);
      _bookings.insert(
          0,
          BookingItem(
              id: finalRes['_id'],
              bookedCity: finalRes['bookedCity'],
              bookedArea: finalRes['bookedArea'],
              bookedSlot: finalRes['bookedSlot'],
              slotTime: finalRes['slotTime'],
              startTime: finalRes['startTime'],
              endTime: finalRes['endTime'],
              price: finalRes['price'],
              paid: finalRes['paid']));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
