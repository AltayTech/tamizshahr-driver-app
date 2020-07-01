import 'package:flutter/material.dart';

import 'collect.dart';
import 'collect_time.dart';
import 'request_address.dart';

class RequestWaste with ChangeNotifier {
  final CollectTime collect_date;
  final RequestAddress address_data;
  final List<Collect> collect_list;
  final bool collected;

  RequestWaste({
    this.collect_date,
    this.address_data,
    this.collect_list,
    this.collected,
  });

  factory RequestWaste.fromJson(Map<String, dynamic> parsedJson) {
    var collectList = parsedJson['collect_list'] as List;
    List<Collect> collectRaw =
        collectList.map((i) => Collect.fromJson(i)).toList();

    return RequestWaste(
      address_data: RequestAddress.fromJson(parsedJson['address_data']),
      collect_list: collectRaw,
    );
  }

  Map<String, dynamic> toJson() {
    Map address_data =
        this.address_data != null ? this.address_data.toJson() : null;
    Map collect_date =
        this.collect_date != null ? this.collect_date.toJson() : null;

    List<Map> collect_list = this.collect_list != null
        ? this.collect_list.map((i) => i.toJson()).toList()
        : null;

    return {
      'collect_date': collect_date,
      'address_data': address_data,
      'collect_list': collect_list,
      'collected': collected,
    };
  }
}
