import 'package:flutter/foundation.dart';
import 'package:tamizshahrdriver/models/request/delivery_waste_item.dart';
import '../../models/request/request_waste_item.dart';

import '../search_detail.dart';

class DeliveryMain with ChangeNotifier {
  final SearchDetail searchDetail;

  final List<DeliveryWasteItem> requestWasteItem;

  DeliveryMain({this.searchDetail, this.requestWasteItem});

  factory DeliveryMain.fromJson(Map<String, dynamic> parsedJson) {
    var productsList = parsedJson['data'] as List;
    List<DeliveryWasteItem> collectRaw = new List<DeliveryWasteItem>();

    collectRaw =
        productsList.map((i) => DeliveryWasteItem.fromJson(i)).toList();

    return DeliveryMain(
      searchDetail: SearchDetail.fromJson(parsedJson['details']),
      requestWasteItem: collectRaw,
    );
  }
}
