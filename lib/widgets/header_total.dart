import 'package:flutter/material.dart';
import 'package:tamizshahrdriver/provider/app_theme.dart';

import 'en_to_ar_number_convertor.dart';
import 'package:intl/intl.dart' as intl;

class HeaderTotal extends StatelessWidget {
  HeaderTotal({
    Key key,
    @required this.totalWeight,
    @required this.totalPrice,
    @required this.totalNumber,
    @required this.totalPriceController,
    @required this.totalPriceAnimation,

  }) : super(key: key);

  final double totalWeight;
  final double totalPrice;
  final int totalNumber;
  AnimationController totalPriceController;
  Animation<double> totalPriceAnimation;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    var textScaleFactor = MediaQuery
        .of(context)
        .textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    return LayoutBuilder(
        builder: (_, constraint) =>
            Container(
              height: deviceWidth * 0.35,
              decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(5),
                  border:
                  Border.all(color: Colors.grey, width: 0.2)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Spacer(),
                          Image.asset(
                            'assets/images/main_page_request_ic.png',
                            height: deviceWidth * 0.09,
                            width: deviceWidth * 0.09,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 4, bottom: 4),
                            child: Text(
                              EnArConvertor()
                                  .replaceArNumber(totalNumber
                                  .toString())
                                  .toString(),
                              style: TextStyle(
                                color: AppTheme.h1,
                                fontFamily: 'Iransans',
                                fontSize: textScaleFactor * 18,
                              ),
                            ),
                          ),
                          Text(
                            'تعداد',
                            style: TextStyle(
                              color: AppTheme.grey,
                              fontFamily: 'Iransans',
                              fontSize: textScaleFactor * 12,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Spacer(),
                          Image.asset(
                            'assets/images/waste_cart_price_ic.png',
                            height: deviceWidth * 0.09,
                            width: deviceWidth * 0.09,
                            color: Colors.yellow[600],
                          ),
                          AnimatedBuilder(
                            animation: totalPriceAnimation,
                            builder: (BuildContext context,
                                Widget child) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, bottom: 4),
                                child: Text(
                                  totalPrice
                                      .toString()
                                      .isNotEmpty
                                      ? EnArConvertor()
                                      .replaceArNumber(
                                      currencyFormat
                                          .format(
                                          double.parse(
                                            totalPriceAnimation
                                                .value
                                                .toStringAsFixed(
                                                0),
                                          ))
                                          .toString())
                                      : EnArConvertor()
                                      .replaceArNumber('0'),
                                  style: TextStyle(
                                    color: AppTheme.h1,
                                    fontFamily: 'Iransans',
                                    fontSize: textScaleFactor * 18,
                                  ),
                                ),
                              );
                            },
                          ),
                          Text(
                            'تومان ',
                            style: TextStyle(
                              color: AppTheme.grey,
                              fontFamily: 'Iransans',
                              fontSize: textScaleFactor * 12,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Spacer(),
                          Image.asset(
                            'assets/images/waste_cart_weight_ic.png',
                            height: deviceWidth * 0.09,
                            width: deviceWidth * 0.09,
                          ),
//                                      Icon(
//                                        Icons.av_timer,
//                                        color: Colors.blue,
//                                        size: 40,
//                                      ),
                          FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 4, bottom: 4),
                              child: Text(
                                EnArConvertor()
                                    .replaceArNumber(
                                    totalWeight.toString())
                                    .toString(),
                                style: TextStyle(
                                  color: AppTheme.h1,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 18,
                                ),
                              ),
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              'کیلوگرم ',
                              style: TextStyle(
                                color: AppTheme.grey,
                                fontFamily: 'Iransans',
                                fontSize: textScaleFactor * 12,
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
