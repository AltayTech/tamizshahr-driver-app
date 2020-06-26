import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tamizshahrdriver/models/request/collect.dart';
import 'package:tamizshahrdriver/models/request/request_waste_item.dart';
import 'package:tamizshahrdriver/widgets/collect_detail_waste_item.dart';

import '../models/request/price_weight.dart';
import '../provider/app_theme.dart';
import '../provider/auth.dart';
import '../provider/wastes.dart';
import '../widgets/buton_bottom.dart';
import '../widgets/custom_dialog_enter.dart';
import '../widgets/custom_dialog_profile.dart';
import '../widgets/en_to_ar_number_convertor.dart';
import '../widgets/main_drawer.dart';
import '../widgets/waste_cart_item.dart';
import 'address_screen.dart';

class CollectDetailScreen extends StatefulWidget {
  static const routeName = '/CollectDetailScreen';

  @override
  _CollectDetailScreenState createState() => _CollectDetailScreenState();
}

class _CollectDetailScreenState extends State<CollectDetailScreen>
    with TickerProviderStateMixin {
  List<Collect> wasteCartItems = [];
  bool _isInit = true;

  var _isLoading = true;
  int totalPrice = 0;
  int totalWeight = 0;
  int totalPricePure = 0;
  RequestWasteItem loadedCollect;

  void _showLogindialog() {
    showDialog(
      context: context,
      builder: (ctx) =>
          CustomDialogEnter(
            title: 'ورود',
            buttonText: 'صفحه ورود ',
            description: 'برای ادامه باید وارد شوید',
          ),
    );
  }

  void _showCompletedialog() {
    showDialog(
      context: context,
      builder: (ctx) =>
          CustomDialogProfile(
            title: 'اطلاعات کاربری',
            buttonText: 'صفحه پروفایل ',
            description: 'برای ادامه باید اطلاعات کاربری تکمیل کنید',
          ),
    );
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<Auth>(context, listen: false).checkCompleted();
      await searchItems();

      await getWasteItems();

      setState(() {});
    }
    _isInit = false;
    await getWasteItems();

    super.didChangeDependencies();
  }

  Future<void> searchItems() async {
    setState(() {
      _isLoading = true;
    });
    final productId = ModalRoute
        .of(context)
        .settings
        .arguments as int;
    await Provider.of<Wastes>(context, listen: false)
        .retrieveCollectItem(productId);
    loadedCollect =
        Provider
            .of<Wastes>(context, listen: false)
            .requestWasteItem;
    for (int i = 0; i < loadedCollect.collect_list.length; i++) {
      Provider.of<Wastes>(context, listen: false).addWasteCart(
          loadedCollect.collect_list[i],
          int.parse(loadedCollect.collect_list[i].estimated_weight));
    }

    setState(() {
      _isLoading = false;
    });
    print(_isLoading.toString());
  }

  Future<void> getWasteItems() async {
    setState(() {
      _isLoading = true;
    });
    totalPrice = 0;
    totalWeight = 0;
    if (wasteCartItems.length > 0) {
      for (int i = 0; i < wasteCartItems.length; i++) {
        totalPrice = totalPrice + int.parse(wasteCartItems[i].estimated_price);

        totalWeight =
            totalWeight + int.parse(wasteCartItems[i].estimated_weight);
      }
    }
    changeNumberAnimation(double.parse(totalPrice.toString()));

    setState(() {
      _isLoading = false;
    });
  }

  String getPrice(List<PriceWeight> prices, int weight) {
    String price = '0';

    for (int i = 0; i < prices.length; i++) {
      if (weight > int.parse(prices[i].weight)) {
        price = prices[i].price;
      } else {
        price = prices[i].price;
        break;
      }
    }
    return price;
  }

  AnimationController _totalPriceController;
  Animation<double> _totalPriceAnimation;

  @override
  initState() {
    _totalPriceController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _totalPriceAnimation = _totalPriceController;
    super.initState();
  }

  @override
  void dispose() {
    _totalPriceController.dispose();
    super.dispose();
  }

  void changeNumberAnimation(double newValue) {
    setState(() {
      _totalPriceAnimation = new Tween<double>(
        begin: _totalPriceAnimation.value,
        end: newValue,
      ).animate(new CurvedAnimation(
        curve: Curves.ease,
        parent: _totalPriceController,
      ));
    });
    _totalPriceController.forward(from: 0.0);
  }

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
    bool isLogin = Provider
        .of<Auth>(context, listen: false)
        .isAuth;
    bool isCompleted = Provider
        .of<Auth>(context, listen: false)
        .isCompleted;
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: Text(
          'انتخاب پسماند ',
          style: TextStyle(
            color: AppTheme.white,
            fontFamily: 'Iransans',
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),
      body: Builder(builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: deviceHeight * 0.15,
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
                                      Expanded(
                                        child: Icon(
                                          Icons.restore_from_trash,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                      ),
                                      Text(
                                        EnArConvertor()
                                            .replaceArNumber(wasteCartItems
                                            .length
                                            .toString())
                                            .toString(),
                                        style: TextStyle(
                                          color: AppTheme.h1,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 18,
                                        ),
                                      ),
                                      Text(
                                        'تعداد ',
                                        style: TextStyle(
                                          color: AppTheme.grey,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Icon(
                                          Icons.monetization_on,
                                          color: AppTheme.primary,
                                          size: 40,
                                        ),
                                      ),
                                      AnimatedBuilder(
                                        animation: _totalPriceAnimation,
                                        builder: (BuildContext context,
                                            Widget child) {
                                          return new Text(
                                            totalPrice
                                                .toString()
                                                .isNotEmpty
                                                ? EnArConvertor()
                                                .replaceArNumber(
                                                currencyFormat
                                                    .format(
                                                    double.parse(
                                                      _totalPriceAnimation
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
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Icon(
                                          Icons.av_timer,
                                          color: Colors.blue,
                                          size: 40,
                                        ),
                                      ),
                                      Text(
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
                                      Text(
                                        'کیلوگرم ',
                                        style: TextStyle(
                                          color: AppTheme.grey,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Consumer<Wastes>(
                            builder: (_, value, ch) =>
                            value
                                .wasteCartItems.length !=
                                0
                                ? Container(
                              decoration: BoxDecoration(
                                color: AppTheme.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                  const NeverScrollableScrollPhysics(),
                                  itemCount: value.wasteCartItems.length,
                                  itemBuilder: (ctx, i) =>
                                      CollectDetailWasteCartItem(
                                        wasteItem: value.wasteCartItems[i],
                                        function: getWasteItems,
                                      ),
                                ),
                              ),
                            )
                                : Container(
                              height: deviceHeight * 0.6,
                              child: Center(
                                child: Text('پسماندی اضافه نشده است'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            SnackBar addToCartSnackBar = SnackBar(
                              content: Text(
                                'پسماندی اضافه نشده است!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 14.0,
                                ),
                              ),
                              action: SnackBarAction(
                                label: 'متوجه شدم',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );
                            if (wasteCartItems.isEmpty) {
                              Scaffold.of(context)
                                  .showSnackBar(addToCartSnackBar);
                            } else if (!isLogin) {
                              _showLogindialog();
                            } else {
                              if (isCompleted) {
                                Navigator.of(context)
                                    .pushNamed(AddressScreen.routeName);
                              } else {
                                _showCompletedialog();
                              }
                            }
                          },
                          child: ButtonBottom(
                            width: deviceWidth * 0.9,
                            height: deviceWidth * 0.14,
                            text: 'ادامه',
                            isActive: true,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            SnackBar addToCartSnackBar = SnackBar(
                              content: Text(
                                'پسماندی اضافه نشده است!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 14.0,
                                ),
                              ),
                              action: SnackBarAction(
                                label: 'متوجه شدم',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );
                            if (wasteCartItems.isEmpty) {
                              Scaffold.of(context)
                                  .showSnackBar(addToCartSnackBar);
                            } else if (!isLogin) {
                              _showLogindialog();
                            } else {
                              if (isCompleted) {
                                Navigator.of(context)
                                    .pushNamed(AddressScreen.routeName);
                              } else {
                                _showCompletedialog();
                              }
                            }
                          },
                          child: Container(
                            width: deviceWidth * 0.9,
                            height: deviceWidth * 0.14,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.block),
                                  Text(
                                    'عدم دسترسی',
                                    style: TextStyle(
                                      color: AppTheme.black,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                          : Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors
              .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: MainDrawer(),
      ),
    );
  }
}
