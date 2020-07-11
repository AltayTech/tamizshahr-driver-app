import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tamizshahrdriver/models/request/delivery_waste_item.dart';
import 'package:tamizshahrdriver/provider/deliveries.dart';
import 'package:tamizshahrdriver/screens/send_delivery_screen.dart';
import 'package:tamizshahrdriver/widgets/buton_bottom.dart';
import 'package:tamizshahrdriver/widgets/collect_item_store_collect_screen.dart';
import 'package:tamizshahrdriver/widgets/custom_dialog_enter.dart';
import 'package:tamizshahrdriver/widgets/custom_dialog_profile.dart';

import '../models/search_detail.dart';
import '../provider/app_theme.dart';
import '../provider/auth.dart';
import '../widgets/en_to_ar_number_convertor.dart';
import '../widgets/main_drawer.dart';
import 'customer_info/login_screen.dart';

class StoreCollectListScreen extends StatefulWidget {
  static const routeName = '/StoreCollectListScreen';

  @override
  _StoreCollectListScreenState createState() => _StoreCollectListScreenState();
}

class _StoreCollectListScreenState extends State<StoreCollectListScreen>
    with SingleTickerProviderStateMixin {
  bool _isInit = true;

  ScrollController _scrollController = new ScrollController();

  var _isLoading;

  var scaffoldKey;
  int page = 1;

  SearchDetail productsDetail;

  @override
  void initState() {
    Provider.of<Deliveries>(context, listen: false).sPage = 1;

    Provider.of<Deliveries>(context, listen: false).searchBuilder();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page < productsDetail.max_page) {
          page = page + 1;
          Provider.of<Deliveries>(context, listen: false).sPage = page;

          searchItems();
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      searchItems();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  List<DeliveryWasteItem> loadedProducts = [];
  List<DeliveryWasteItem> loadedProductstolist = [];

  Future<void> _submit() async {
    loadedProducts.clear();
    loadedProducts =
        await Provider.of<Deliveries>(context, listen: false).deliveriesItems;
    loadedProductstolist.addAll(loadedProducts);
  }

  Future<void> filterItems() async {
    loadedProductstolist.clear();
    await searchItems();
  }

  Future<void> searchItems() async {
    setState(() {
      _isLoading = true;
    });

    Provider.of<Deliveries>(context, listen: false).searchBuilder();
    await Provider.of<Deliveries>(context, listen: false).searchCollectItems();
    productsDetail =
        Provider.of<Deliveries>(context, listen: false).searchDetails;
    _submit();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> changeCat(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    print(_isLoading.toString());

    Provider.of<Deliveries>(context, listen: false).sPage = 1;

    Provider.of<Deliveries>(context, listen: false).searchBuilder();

    loadedProductstolist.clear();

    await searchItems();

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
  }

  void _showLogindialog() {
    showDialog(
      context: context,
      builder: (ctx) => CustomDialogEnter(
        title: 'ورود',
        buttonText: 'صفحه ورود ',
        description: 'برای ادامه باید وارد شوید',
      ),
    );
  }

  void _showCompletedialog() {
    showDialog(
      context: context,
      builder: (ctx) => CustomDialogProfile(
        title: 'اطلاعات کاربری',
        buttonText: 'صفحه پروفایل ',
        description: 'برای ادامه باید اطلاعات کاربری تکمیل کنید',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    bool isLogin = Provider.of<Auth>(context).isAuth;
    bool isCompleted = Provider.of<Auth>(
      context,
    ).isCompleted;

    var currencyFormat = intl.NumberFormat.decimalPattern();

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: !isLogin
              ? Container(
                  height: deviceHeight * 0.55,
                  width: deviceWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('شما وارد نشده اید'),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(LoginScreen.routeName);
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'ورود به حساب کاربری',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: deviceHeight * 0.0,
                      horizontal: deviceWidth * 0.00),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: deviceHeight * 0.63,
                        width: deviceWidth,
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: AppTheme.bg,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primary.withOpacity(0.08),
                                      blurRadius: 10.10,
                                      spreadRadius: 10,
                                      offset: Offset(
                                        0, // horizontal, move right 10

                                        0, // vertical, move down 10
                                      ),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Spacer(),
                                        Consumer<Deliveries>(
                                            builder: (context, Deliveries, ch) {
                                          return Container(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: deviceHeight * 0.0,
                                                  horizontal: 3),
                                              child: Wrap(
                                                  alignment:
                                                      WrapAlignment.start,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  direction: Axis.horizontal,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 3,
                                                          vertical: 5),
                                                      child: Text(
                                                        'تعداد:',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Iransans',
                                                          fontSize:
                                                              textScaleFactor *
                                                                  12.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 4.0,
                                                              left: 6),
                                                      child: Text(
                                                        productsDetail != null
                                                            ? EnArConvertor()
                                                                .replaceArNumber(
                                                                    loadedProductstolist
                                                                        .length
                                                                        .toString())
                                                            : EnArConvertor()
                                                                .replaceArNumber(
                                                                    '0'),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Iransans',
                                                          fontSize:
                                                              textScaleFactor *
                                                                  13.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 3,
                                                          vertical: 5),
                                                      child: Text(
                                                        'از',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Iransans',
                                                          fontSize:
                                                              textScaleFactor *
                                                                  12.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 4.0,
                                                              left: 6),
                                                      child: Text(
                                                        productsDetail != null
                                                            ? EnArConvertor()
                                                                .replaceArNumber(
                                                                    productsDetail
                                                                        .total
                                                                        .toString()
                                                                        .toString())
                                                            : EnArConvertor()
                                                                .replaceArNumber(
                                                                    '0'),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Iransans',
                                                          fontSize:
                                                              textScaleFactor *
                                                                  13.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: deviceHeight * 0.450,
                                      child: ListView.builder(
                                        controller: _scrollController,
                                        scrollDirection: Axis.vertical,
                                        itemCount: loadedProductstolist.length,
                                        itemBuilder: (ctx, i) =>
                                            ChangeNotifierProvider.value(
                                          value: loadedProductstolist[i],
                                          child:
                                              CollectItemStoreCollectsScreen(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: InkWell(
                          onTap: () async {
                            SnackBar addToCartSnackBar = SnackBar(
                              content: Text(
                                'قبلا جمع آوری شده است!',
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
                            if (loadedProducts.isEmpty) {
                              Scaffold.of(context)
                                  .showSnackBar(addToCartSnackBar);
                            } else if (!isLogin) {
                              _showLogindialog();
                            } else {
                              Navigator.of(context)
                                  .pushNamed(SendDeliveryScreen.routeName);
                            }
                          },
                          child: ButtonBottom(
                            width: deviceWidth * 0.9,
                            height: deviceWidth * 0.14,
                            text: 'تحویل به انبار',
                            isActive: loadedProducts.isNotEmpty,
                          ),
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                              : Container(
                                  child: loadedProductstolist.isEmpty
                                      ? Center(
                                          child: Text(
                                            'محصولی وجود ندارد',
                                            style: TextStyle(
                                              fontFamily: 'Iransans',
                                              fontSize: textScaleFactor * 15.0,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
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
