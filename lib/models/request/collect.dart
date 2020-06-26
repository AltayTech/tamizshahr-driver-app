import 'package:flutter/material.dart';

import 'pasmand.dart';

class Collect with ChangeNotifier {
  final Pasmand pasmand;
  final String estimated_weight;
  final String exact_weight;
  final String estimated_price;
  final String exact_price;

  Collect({
    this.pasmand,
    this.estimated_weight,
    this.exact_weight,
    this.estimated_price,
    this.exact_price,
  });

  factory Collect.fromJson(Map<String, dynamic> parsedJson) {
    return Collect(
      estimated_weight: parsedJson['estimated_weight'],
      exact_weight: parsedJson['exact_weight'],
      estimated_price: parsedJson['estimated_price'],
      exact_price: parsedJson['exact_price'],
      pasmand: Pasmand.fromJson(parsedJson['pasmand']),
    );
  }

  Map<String, dynamic> toJson() {
    Map pasmand = this.pasmand != null ? this.pasmand.toJson() : null;

    return {
      'pasmand': pasmand,
      'estimated_weight': estimated_weight,
      'exact_weight': exact_weight,
      'estimated_price': estimated_price,
      'exact_price': exact_price,
    };
  }
}
