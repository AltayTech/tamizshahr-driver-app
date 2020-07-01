import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tamizshahrdriver/models/request/collect.dart';
import 'package:tamizshahrdriver/provider/app_theme.dart';

import '../models/request/wasteCart.dart';
import '../provider/wastes.dart';
import 'en_to_ar_number_convertor.dart';

class CollectDeliveryDetailItem extends StatefulWidget {
  final Collect wasteItem;
  final Function function;

  CollectDeliveryDetailItem({
    this.wasteItem,
    this.function,
  });

  @override
  _CollectDeliveryDetailItemState createState() => _CollectDeliveryDetailItemState();
}

class _CollectDeliveryDetailItemState extends State<CollectDeliveryDetailItem>with TickerProviderStateMixin  {
  bool _isInit = true;

  var _isLoading = true;

  int productWeight = 0;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = false;

      productWeight = int.parse(widget.wasteItem.exact_weight);
//      changeNumberAnimation(double.parse(
//              getPrice(widget.wasteItem.prices, widget.wasteItem.weight)) *
//          widget.wasteItem.weight);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

//  Future<void> removeItem() async {
//    setState(() {
//      _isLoading = true;
//    });
//    await Provider.of<Wastes>(context, listen: false).removeWasteCart(
//      widget.wasteItem.pasmand.id,
//    );
//
//    widget.function();
//    setState(() {
//      _isLoading = false;
//    });
//  }

//  Future<void> updateItem(String exactWeight, bool isAdded) async {
//    setState(() {
//      _isLoading = true;
//    });
//    await Provider.of<Wastes>(context, listen: false)
//        .updateWasteCart(widget.wasteItem, exactWeight, isAdded);
//
//    widget.function();
//    setState(() {
//      _isLoading = false;
//    });
//  }

//  String getPrice(List<PriceWeight> prices, int weight) {
//    String price = '0';
//
//    for (int i = 0; i < prices.length; i++) {
//      if (weight > int.parse(prices[i].weight)) {
//        price = prices[i].price;
//      } else {
//        price = prices[i].price;
//        break;
//      }
//    }
//    return price;
//  }

  AnimationController _controller;
  Animation<double> _animation;

  @override
  initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = _controller;
    changeNumberAnimation(double.parse(widget.wasteItem.estimated_price));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeNumberAnimation(double newValue) {
    setState(() {
      _animation = new Tween<double>(
        begin: _animation.value,
        end: newValue,
      ).animate(new CurvedAnimation(
        curve: Curves.ease,
        parent: _controller,
      ));
    });
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: deviceWidth * 0.25,
        width: deviceWidth,
        child: LayoutBuilder(
          builder: (_, constraints) => Container(
            decoration: AppTheme.listItemBox,
            child: Stack(
              children: <Widget>[
//                Positioned(
//                  top: 0,
//                  right: 0,
//                  width: deviceWidth * 0.046,
//                  height: deviceWidth * 0.046,
//                  child: Checkbox(
//                    value: widget.wasteItem.isAdded,
//                    onChanged: (value) {
//                      if (widget.wasteItem.isAdded) {
//                        updateItem(widget.wasteItem.exact_weight, false);
//                      } else {
//                        updateItem((widget.wasteItem.exact_weight), true);
//                      }
//                    },
//                  ),
//                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: constraints.maxWidth * 0.3,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.wasteItem.pasmand.post_title != null
                                  ? widget.wasteItem.pasmand.post_title
                                  : 'ندارد',
                              style: TextStyle(
                                color: AppTheme.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Iransans',
                                fontSize: textScaleFactor * 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Text(
                            EnArConvertor()
                                .replaceArNumber(
                                    widget.wasteItem.estimated_weight.toString())
                                .toString(),
                            style: TextStyle(
                              color: AppTheme.black,
                              fontFamily: 'Iransans',
                              fontSize: textScaleFactor * 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder:
                              (BuildContext context, Widget child) {
                            return new Text(
                              widget.wasteItem.estimated_price.length != 0
                                  ? EnArConvertor()
                                  .replaceArNumber(currencyFormat
                                  .format(double.parse(
                                _animation.value
                                    .toStringAsFixed(0),
                              ))
                                  .toString())
                                  : EnArConvertor()
                                  .replaceArNumber('0'),
                              style: TextStyle(
                                color: AppTheme.h1,
                                fontFamily: 'Iransans',
                                fontSize: textScaleFactor * 18,
                              ),
                              textAlign: TextAlign.center,

                            );
                          },
                        ),
                      ),
//                      Container(
//                        height: constraints.maxHeight * 0.8,
//                        width: constraints.maxWidth * 0.12,
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          children: <Widget>[
//                            Expanded(
//                                child: InkWell(
//                                  onTap: () async {
//                                    productWeight = productWeight + 1;
//
//                                    await Provider.of<Wastes>(context,
//                                        listen: false)
//                                        .updateWasteCart(
//                                        widget.wasteItem,
//                                        productWeight.toString(),
//                                        widget.wasteItem.isAdded);
////                                                    changeNumberAnimation(
////                                                        double.parse(getPrice(
////                                                                widget.wasteItem
////                                                                    .prices,
////                                                                widget.wasteItem
////                                                                    .weight)) *
////                                                            widget.wasteItem
////                                                                .weight);
//                                    widget.function();
//                                  },
//                                  onDoubleTap: () async {
//                                    productWeight = productWeight + 10;
//
//                                    await Provider.of<Wastes>(context,
//                                        listen: false)
//                                        .updateWasteCart(
//                                        widget.wasteItem,
//                                        productWeight.toString(),
//                                        widget.wasteItem.isAdded);
////                                                    changeNumberAnimation(
////                                                        double.parse(getPrice(
////                                                                widget.wasteItem
////                                                                    .prices,
////                                                                widget.wasteItem
////                                                                    .weight)) *
////                                                            widget.wasteItem
////                                                                .weight);
//                                    widget.function();
//                                  },
//                                  child: Container(
//                                      decoration: BoxDecoration(
//                                        shape: BoxShape.circle,
//                                        color: AppTheme.accent,
//                                      ),
//                                      child: Icon(
//                                        Icons.add,
//                                        color: AppTheme.bg,
//                                      )),
//                                )),
//                            Expanded(
//                              child: Padding(
//                                padding: const EdgeInsets.only(top: 3.0),
//                                child: Text(
//                                  EnArConvertor()
//                                      .replaceArNumber(widget
//                                      .wasteItem.exact_weight
//                                      .toString())
//                                      .toString(),
//                                  style: TextStyle(
//                                    color: AppTheme.black,
//                                    fontFamily: 'Iransans',
//                                    fontSize: textScaleFactor * 14,
//                                  ),
//                                  textAlign: TextAlign.center,
//                                ),
//                              ),
//                            ),
//                            Expanded(
//                              child: InkWell(
//                                onTap: () {
//                                  if (productWeight > 1) {
//                                    productWeight = productWeight - 1;
//                                    print('productCount' +
//                                        productWeight.toString());
//
//                                    Provider.of<Wastes>(context, listen: false)
//                                        .updateWasteCart(
//                                        widget.wasteItem,
//                                        productWeight.toString(),
//                                        widget.wasteItem.isAdded);
////                                                        changeNumberAnimation(
////                                                            double.parse(getPrice(
////                                                                    widget
////                                                                        .wasteItem
////                                                                        .prices,
////                                                                    widget
////                                                                        .wasteItem
////                                                                        .weight)) *
////                                                                widget.wasteItem
////                                                                    .weight);
//                                  }
//                                  widget.function();
//                                },
//                                onDoubleTap: () async {
//                                  if (productWeight > 10) {
//                                    productWeight = productWeight - 10;
//                                    print('productCount' +
//                                        productWeight.toString());
//
//                                    Provider.of<Wastes>(context, listen: false)
//                                        .updateWasteCart(
//                                        widget.wasteItem,
//                                        productWeight.toString(),
//                                        widget.wasteItem.isAdded);
////                                                        changeNumberAnimation(
////                                                            double.parse(getPrice(
////                                                                    widget
////                                                                        .wasteItem
////                                                                        .prices,
////                                                                    widget
////                                                                        .wasteItem
////                                                                        .weight)) *
////                                                                widget.wasteItem
////                                                                    .weight);
//                                  }
//                                  widget.function();
//                                },
//                                child: Container(
//                                  decoration: BoxDecoration(
//                                    shape: BoxShape.circle,
//                                    color: AppTheme.accent,
//                                  ),
//                                  child: Icon(
//                                    Icons.remove,
//                                    color: AppTheme.bg,
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                      Container(
//                        height: constraints.maxHeight * 0.8,
//                        width: constraints.maxWidth * 0.12,
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          children: <Widget>[
//                            Expanded(
//                                child: InkWell(
//                              onTap: () async {
//                                productWeight = productWeight + 1;
//
//                                await Provider.of<Wastes>(context,
//                                        listen: false)
//                                    .updateWasteCart(
//                                        widget.wasteItem,
//                                        productWeight.toString(),
//                                        widget.wasteItem.isAdded);
////                                                    changeNumberAnimation(
////                                                        double.parse(getPrice(
////                                                                widget.wasteItem
////                                                                    .prices,
////                                                                widget.wasteItem
////                                                                    .weight)) *
////                                                            widget.wasteItem
////                                                                .weight);
//                                widget.function();
//                              },
//                              onDoubleTap: () async {
//                                productWeight = productWeight + 10;
//
//                                await Provider.of<Wastes>(context,
//                                        listen: false)
//                                    .updateWasteCart(
//                                        widget.wasteItem,
//                                        productWeight.toString(),
//                                        widget.wasteItem.isAdded);
////                                                    changeNumberAnimation(
////                                                        double.parse(getPrice(
////                                                                widget.wasteItem
////                                                                    .prices,
////                                                                widget.wasteItem
////                                                                    .weight)) *
////                                                            widget.wasteItem
////                                                                .weight);
//                                widget.function();
//                              },
//                              child: Container(
//                                  decoration: BoxDecoration(
//                                    shape: BoxShape.circle,
//                                    color: AppTheme.accent,
//                                  ),
//                                  child: Icon(
//                                    Icons.add,
//                                    color: AppTheme.bg,
//                                  )),
//                            )),
//                            Expanded(
//                              child: Padding(
//                                padding: const EdgeInsets.only(top: 3.0),
//                                child: Text(
//                                  EnArConvertor()
//                                      .replaceArNumber(widget
//                                          .wasteItem.exact_weight
//                                          .toString())
//                                      .toString(),
//                                  style: TextStyle(
//                                    color: AppTheme.black,
//                                    fontFamily: 'Iransans',
//                                    fontSize: textScaleFactor * 14,
//                                  ),
//                                  textAlign: TextAlign.center,
//                                ),
//                              ),
//                            ),
//                            Expanded(
//                              child: InkWell(
//                                onTap: () {
//                                  if (productWeight > 1) {
//                                    productWeight = productWeight - 1;
//                                    print('productCount' +
//                                        productWeight.toString());
//
//                                    Provider.of<Wastes>(context, listen: false)
//                                        .updateWasteCart(
//                                            widget.wasteItem,
//                                            productWeight.toString(),
//                                            widget.wasteItem.isAdded);
////                                                        changeNumberAnimation(
////                                                            double.parse(getPrice(
////                                                                    widget
////                                                                        .wasteItem
////                                                                        .prices,
////                                                                    widget
////                                                                        .wasteItem
////                                                                        .weight)) *
////                                                                widget.wasteItem
////                                                                    .weight);
//                                  }
//                                  widget.function();
//                                },
//                                onDoubleTap: () async {
//                                  if (productWeight > 10) {
//                                    productWeight = productWeight - 10;
//                                    print('productCount' +
//                                        productWeight.toString());
//
//                                    Provider.of<Wastes>(context, listen: false)
//                                        .updateWasteCart(
//                                            widget.wasteItem,
//                                            productWeight.toString(),
//                                            widget.wasteItem.isAdded);
////                                                        changeNumberAnimation(
////                                                            double.parse(getPrice(
////                                                                    widget
////                                                                        .wasteItem
////                                                                        .prices,
////                                                                    widget
////                                                                        .wasteItem
////                                                                        .weight)) *
////                                                                widget.wasteItem
////                                                                    .weight);
//                                  }
//                                  widget.function();
//                                },
//                                child: Container(
//                                  decoration: BoxDecoration(
//                                    shape: BoxShape.circle,
//                                    color: AppTheme.accent,
//                                  ),
//                                  child: Icon(
//                                    Icons.remove,
//                                    color: AppTheme.bg,
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
                      SizedBox(width: constraints.maxWidth*0.05,)

                    ],
                  ),
                ),
                Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Align(
                        alignment: Alignment.center,
                        child: _isLoading
                            ? SpinKitFadingCircle(
                                itemBuilder: (BuildContext context, int index) {
                                  return DecoratedBox(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: index.isEven
                                          ? Colors.grey
                                          : Colors.grey,
                                    ),
                                  );
                                },
                              )
                            : Container()))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
