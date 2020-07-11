import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tamizshahrdriver/models/request/delivery_waste_item.dart';

import '../provider/app_theme.dart';
import 'en_to_ar_number_convertor.dart';

class CollectItemStoreCollectsScreen extends StatelessWidget {
  Widget getStatusIcon(String statusSlug) {
    Widget icon = Icon(
      Icons.access_time,
      color: AppTheme.accent,
//      size: 35,
    );

    if (statusSlug == 'delivery_request') {
      icon = Icon(
        Icons.access_time,
        color: AppTheme.accent,
//        size: 25,
      );
    } else if (statusSlug == 'delivery_done') {
      icon = Icon(
        Icons.check_circle,
        color: AppTheme.primary,
//        size: 35,
      );
    } else {
      icon = Icon(
        Icons.access_time,
        color: AppTheme.accent,
//        size: 35,
      );
    }

    return icon;
  }

  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final collect = Provider.of<DeliveryWasteItem>(context, listen: false);
    var currencyFormat = intl.NumberFormat.decimalPattern();

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: widthDevice * 0.25,
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            return InkWell(
              onTap: () {
//                Navigator.of(context).pushNamed(
//                  DeliveryDetailScreen.routeName,
//                  arguments: collect.id,
//                );
              },
              child: Container(
                decoration: AppTheme.listItemBox.copyWith(
                    color: AppTheme.white,
                    border: Border.all(color: AppTheme.white)),
                height: constraints.maxHeight,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, bottom: 4),
                                  child: Icon(
                                    Icons.date_range,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                Text(
                                  collect.delivery_date,
                                  maxLines: 1,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: AppTheme.black,
                                    fontFamily: 'Iransans',
                                    fontSize: textScaleFactor * 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                                child: getStatusIcon(collect.status.slug)),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 30, left: 4),
                                    child: Text(
                                      EnArConvertor().replaceArNumber(collect
                                          .total_collects_weight.estimated),
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppTheme.black,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 15.0,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'کیلوگرم',
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppTheme.grey,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 10.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    EnArConvertor().replaceArNumber(
                                        currencyFormat
                                            .format(double.parse(collect
                                                .total_collects_price
                                                .estimated))
                                            .toString()),
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: AppTheme.black,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 15.0,
                                    ),
                                  ),
                                  Text(
                                    ' تومان',
                                    maxLines: 1,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: AppTheme.grey,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 11.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                collect.status.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppTheme.black,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 12.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
