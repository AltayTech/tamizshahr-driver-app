import 'package:flutter/foundation.dart';
import 'package:tamizshahrdriver/models/clearing.dart';

import '../models/search_detail.dart';

class ClearingMain with ChangeNotifier {
  final SearchDetail searchDetail;

  final List<Clearing> clearings;

  ClearingMain({this.searchDetail, this.clearings});

  factory ClearingMain.fromJson(Map<String, dynamic> parsedJson) {
    var clearingsList = parsedJson['data'] as List;
    List<Clearing> clearingsRaw = new List<Clearing>();

    clearingsRaw = clearingsList.map((i) => Clearing.fromJson(i)).toList();

    return ClearingMain(
      searchDetail: SearchDetail.fromJson(parsedJson['details']),
      clearings: clearingsRaw,
    );
  }
}
