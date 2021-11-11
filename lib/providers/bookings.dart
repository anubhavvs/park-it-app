import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class BookingItem with ChangeNotifier {
  final String id;
  final String bookedCity;
  final String bookedArea;
  final String bookedSlot;
  final String slotTime;
  final String startTime;
  final String endTime;
  final int price;
  final bool paid;
  final String status;

  BookingItem(
      {@required this.id,
      @required this.bookedCity,
      @required this.bookedArea,
      @required this.bookedSlot,
      @required this.slotTime,
      @required this.startTime,
      @required this.endTime,
      @required this.price,
      @required this.paid,
      @required this.status});
}

class Bookings with ChangeNotifier {
  List<BookingItem> _bookings = [];
  String _authToken;
  String _bookingId;

  set authToken(String value) {
    _authToken = value;
  }

  List<BookingItem> get bookings {
    return [..._bookings];
  }

  Future<void> payment() async {
    final prefs = await SharedPreferences.getInstance();
    var url = '${FlutterConfig.get('API_URL')}/booking/${_bookingId}';
    var uri = Uri.parse(url);
    try {
      final response = await http
          .put(uri, headers: {'Authorization': 'Bearer ' + _authToken});
      if (response.statusCode == 401) {
        throw HttpException(json.decode(response.body)['message']);
      }
    } catch (error) {
      throw error;
    }
    prefs.setBool('activeBooking', false);
    prefs.setString('activeBookingId', null);
    notifyListeners();
  }

  Future<BookingItem> fetchAndSetActiveBooking() async {
    final prefs = await SharedPreferences.getInstance();
    _bookingId = prefs.getString('activeBookingId');
    var url = '${FlutterConfig.get('API_URL')}/booking/${_bookingId}';
    var uri = Uri.parse(url);
    try {
      final response = await http
          .get(uri, headers: {'Authorization': 'Bearer ' + _authToken});
      if (response.statusCode == 401) {
        throw HttpException(json.decode(response.body)['message']);
      }
      final finalRes = json.decode(response.body);
      return BookingItem(
          id: finalRes['_id'],
          bookedCity: finalRes['bookedCity'],
          bookedArea: finalRes['bookedArea'],
          bookedSlot: finalRes['bookedSlot'],
          slotTime: finalRes['slotTime'],
          startTime: finalRes['startTime'],
          endTime: finalRes['endTime'],
          price: finalRes['price'],
          paid: finalRes['paid'],
          status: finalRes['status']);
    } catch (error) {
      throw error;
    }
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
              paid: finalRes['paid'],
              status: finalRes['status']));
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('activeBooking', true);
      prefs.setString('activeBookingId', finalRes['_id']);
    } catch (error) {
      throw error;
    }
  }
}
