import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'package:park_it/models/http_exception.dart';
import 'dart:convert';

import 'area.dart';

class Areas with ChangeNotifier {
  List<Area> _areas = [];
  String _authToken;

  set authToken(String value) {
    _authToken = value;
  }

  List<Area> get areas {
    return [..._areas];
  }

  Area findById(String id) {
    return _areas.firstWhere((area) => area.id == id);
  }

  Future<void> fetchAndSetAreas() async {
    var url = FlutterConfig.get('API_URL') + '/areas/';
    var uri = Uri.parse(url);
    try {
      final response = await http
          .get(uri, headers: {'Authorization': 'Bearer ' + _authToken});
      final extractedData = json.decode(response.body) as List<dynamic>;
      final List<Area> loadedProducts = [];
      List<Slot> loadedSlots = [];
      extractedData.forEach((value) => {
            loadedProducts.add(Area(
                id: value['_id'],
                name: value['name'],
                city: value['city'],
                numSlots: value['numSlots'],
                slots: loadedSlots)),
            value['slots'].forEach((slot) => loadedSlots.add(Slot(
                id: slot['_id'], name: slot['name'], filled: slot['filled']))),
            loadedSlots = []
          });
      if (response.statusCode == 401) {
        throw HttpException(json.decode(response.body)['message']);
      }
      _areas = loadedProducts;
    } catch (error) {
      throw (error);
    }
  }
}
