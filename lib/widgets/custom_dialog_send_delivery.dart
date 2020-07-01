import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tamizshahrdriver/models/request/pasmand.dart';
import 'package:tamizshahrdriver/provider/customer_info.dart';

import '../provider/app_theme.dart';

class CustomDialogSendDelivery extends StatefulWidget {
  final int totalWallet;
  final Function function;

  CustomDialogSendDelivery({
    @required this.totalWallet,
    @required this.function,
  });

  @override
  _CustomDialogSendDeliveryState createState() =>
      _CustomDialogSendDeliveryState();
}

class _CustomDialogSendDeliveryState extends State<CustomDialogSendDelivery> {
  var storeValue;
  List<String> storeValueList = [];
  List<Pasmand> storeList = [];
  Pasmand selectedStore;

  @override
  void didChangeDependencies() {
    storeList = Provider.of<CustomerInfo>(context).driver.stores;

    for (int i = 0; i < storeList.length; i++) {
      storeValueList.add(storeList[i].post_title);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();
    return LayoutBuilder(
      builder: (_, constraints) => Padding(
        padding: EdgeInsets.only(
          top: Consts.avatarRadius + Consts.padding,
          bottom: Consts.padding,
          left: Consts.padding,
          right: Consts.padding,
        ),
        child: Container(
          decoration: new BoxDecoration(
            color: AppTheme.bg,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    width: deviceWidth * 0.78,
                    child: Text(
                      'انتخاب انبار',
                      style: TextStyle(
                        color: AppTheme.h1,
                        fontFamily: 'Iransans',
                        fontSize: textScaleFactor * 14.0,
                      ),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: deviceWidth * 0.78,
                      height: deviceHeight * 0.05,
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppTheme.white,
                          border: Border.all(color: AppTheme.h1, width: 0.6)),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 8.0, left: 8, top: 6),
                        child: DropdownButton<String>(
                          hint: Text(
                            'انبار مورد نظر را آنتخاب کنید.',
                            style: TextStyle(
                              color: AppTheme.grey,
                              fontFamily: 'Iransans',
                              fontSize: textScaleFactor * 13.0,
                            ),
                          ),
                          value: storeValue,
                          icon: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: AppTheme.black,
                              size: 20,
                            ),
                          ),
                          dropdownColor: AppTheme.white,
                          style: TextStyle(
                            color: AppTheme.black,
                            fontFamily: 'Iransans',
                            fontSize: textScaleFactor * 13.0,
                          ),
                          isDense: true,
                          onChanged: (newValue) {
                            setState(() {
                              storeValue = newValue;
                              selectedStore = storeList[
                                  storeValueList.lastIndexOf(newValue)];
                            });
                          },
                          items: storeValueList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                  child: Text(
                                    value,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppTheme.black,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 13.0,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Builder(
                    builder: (context) => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          if (selectedStore!=null) {
                            widget.function(selectedStore.id);
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          height: constraints.maxHeight * 0.06,
                          width: constraints.maxWidth * 0.8,
                          decoration: BoxDecoration(
                            color: selectedStore!=null
                                ? AppTheme.primary
                                : Colors.grey,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'تایید',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 5.0;
  static const double avatarRadius = 3;
}
