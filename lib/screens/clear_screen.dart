import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tamizshahrdriver/models/clearing.dart';
import 'package:tamizshahrdriver/provider/clearings.dart';
import 'package:tamizshahrdriver/widgets/clearing_item_clear_screen.dart';

import '../models/customer.dart';
import '../models/search_detail.dart';
import '../provider/app_theme.dart';
import '../provider/auth.dart';
import '../provider/customer_info.dart';
import '../widgets/buton_bottom.dart';
import '../widgets/currency_input_formatter.dart';
import '../widgets/custom_dialog_send_request.dart';
import '../widgets/en_to_ar_number_convertor.dart';
import '../widgets/main_drawer.dart';
import 'customer_info/login_screen.dart';
import 'navigation_bottom_screen.dart';

class ClearScreen extends StatefulWidget {
  static const routeName = '/ClearScreen';

  @override
  _ClearScreenState createState() => _ClearScreenState();
}

class _ClearScreenState extends State<ClearScreen>
    with SingleTickerProviderStateMixin {
  bool _isInit = true;
  var _isLoading = false;
  int page = 1;
  SearchDetail productsDetail;
  ScrollController _scrollController = new ScrollController();

  Customer customer;

  final shabaController = TextEditingController();
  final donationController = TextEditingController();

  @override
  void initState() {
    Provider.of<Clearings>(context, listen: false).sPage = 1;

    Provider.of<Clearings>(context, listen: false).searchBuilder();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page < productsDetail.max_page) {
          page = page + 1;
          Provider.of<Clearings>(context, listen: false).sPage = page;

          searchItems();
        }
      }
    });

    shabaController.text = 'IR';
    donationController.text = '0';
    super.initState();
  }

  @override
  void dispose() {
    shabaController.dispose();
    donationController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      getCustomerInfo();
      searchItems();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> getCustomerInfo() async {
    bool isLogin = Provider.of<Auth>(context, listen: false).isAuth;
    if (isLogin) {
      await Provider.of<CustomerInfo>(context, listen: false).getCustomer();
    }
  }

  void _showSenddialog() {
    showDialog(
      context: context,
      builder: (ctx) => CustomDialogSendRequest(
        title: '',
        buttonText: 'خب',
        description: 'درخواست شما با موفقیت ثبت شد',
      ),
    );
  }

  List<Clearing> loadedProducts = [];
  List<Clearing> loadedProductstolist = [];

  Future<void> searchItems() async {
    setState(() {
      _isLoading = true;
    });

    Provider.of<Clearings>(context, listen: false).searchBuilder();
    await Provider.of<Clearings>(context, listen: false).searchCleaingsItems();
    productsDetail =
        Provider.of<Clearings>(context, listen: false).searchDetails;

    loadedProducts.clear();
    loadedProducts =
        await Provider.of<Clearings>(context, listen: false).deliveriesItems;
    loadedProductstolist.addAll(loadedProducts);

    setState(() {
      _isLoading = false;
    });
  }

  String removeSemicolon(String rawString) {
//    for (int i = 0; i <= rawString.length; i++) {
    print(rawString);

    String newvalue = rawString.replaceAll(',', '');
    print(rawString);

//    }
    return newvalue;
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    bool isLogin = Provider.of<Auth>(context).isAuth;

    var currencyFormat = intl.NumberFormat.decimalPattern();

    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'درخواست تسویه',
          style: TextStyle(
            fontFamily: 'Iransans',
          ),
        ),
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: Builder(
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: deviceHeight * 0.0,
                    horizontal: deviceWidth * 0.03),
                child: !isLogin
                    ? Container(
                        height: deviceHeight * 0.8,
                        child: Center(
                          child: Wrap(
                            direction: Axis.vertical,
                            crossAxisAlignment: WrapCrossAlignment.center,
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
                        ),
                      )
                    : Directionality(
                        textDirection: TextDirection.rtl,
                        child: Container(
                          color: AppTheme.bg,
                          height: deviceHeight * 0.9,
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTheme.primary
                                                    .withOpacity(0.08),
                                                blurRadius: 10.10,
                                                spreadRadius: 10.510,
                                                offset: Offset(
                                                  0,
                                                  0,
                                                ),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'امتیاز',
                                                style: TextStyle(
                                                  color: AppTheme.grey,
                                                  fontFamily: 'Iransans',
                                                  fontSize:
                                                      textScaleFactor * 13.0,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Consumer<CustomerInfo>(
                                                  builder: (_, data, ch) =>
                                                      Text(
                                                    data.driver != null
                                                        ? EnArConvertor().replaceArNumber(
                                                            currencyFormat
                                                                .format(double.parse(data
                                                                        .driver
                                                                        .money)
                                                                    .roundToDouble())
                                                                .toString())
                                                        : EnArConvertor()
                                                            .replaceArNumber(
                                                                currencyFormat
                                                                    .format(double
                                                                        .parse(
                                                                            '0'))),
                                                    style: TextStyle(
                                                      color: AppTheme.black,
                                                      fontFamily: 'Iransans',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize:
                                                          textScaleFactor *
                                                              18.0,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'تومان',
                                                style: TextStyle(
                                                  color: AppTheme.grey,
                                                  fontFamily: 'Iransans',
                                                  fontSize:
                                                      textScaleFactor * 13.0,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16.0, bottom: 4),
                                      child: Text(
                                        'شماره شبا',
                                        textDirection: TextDirection.ltr,
                                        style: TextStyle(
                                          color: AppTheme.h1,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 14.0,
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: AppTheme.h1,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 16.0,
                                      ),
                                      textDirection: TextDirection.ltr,
                                      textAlignVertical:
                                          TextAlignVertical.bottom,
                                      textInputAction: TextInputAction.go,
                                      keyboardType: TextInputType.number,
                                      controller: shabaController,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 20.0,
                                            right: 20,
                                            top: 10,
                                            bottom: 10),
                                        border: OutlineInputBorder(
                                          gapPadding: 10,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide(
                                            width: 0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        labelStyle: TextStyle(
                                          color: Colors.blue,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 10.0,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16.0, bottom: 4),
                                      child: Text(
                                        'مقدار درخواستی(تومان)',
                                        style: TextStyle(
                                          color: AppTheme.h1,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 14.0,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: TextFormField(
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: AppTheme.h1,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 16.0,
                                        ),
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        textInputAction: TextInputAction.go,
                                        controller: donationController,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.only(
                                              left: 20.0,
                                              right: 20,
                                              top: 0,
                                              bottom: 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                              width: 0,
                                              color: Colors.white,
                                            ),
                                          ),
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
                                            fontFamily: 'Iransans',
                                            fontSize: textScaleFactor * 10.0,
                                          ),
                                        ),
                                        inputFormatters: [
                                          WhitelistingTextInputFormatter
                                              .digitsOnly,
                                          new CurrencyInputFormatter(),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: AppTheme.bg,
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, right: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    'لیست درخواست ها',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: AppTheme.black
                                                          .withOpacity(0.5),
                                                      fontFamily: 'Iransans',
                                                      fontSize:
                                                          textScaleFactor *
                                                              14.0,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Consumer<CustomerInfo>(
                                                      builder: (_, Wastes, ch) {
                                                    return Container(
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical:
                                                                    deviceHeight *
                                                                        0.0,
                                                                horizontal: 3),
                                                        child: Wrap(
                                                          alignment:
                                                              WrapAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              WrapCrossAlignment
                                                                  .center,
                                                          direction:
                                                              Axis.horizontal,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 3,
                                                                  vertical: 5),
                                                              child: Text(
                                                                'تعداد:',
                                                                style:
                                                                    TextStyle(
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
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          4.0,
                                                                      left: 6),
                                                              child: Text(
                                                                productsDetail !=
                                                                        null
                                                                    ? EnArConvertor().replaceArNumber(
                                                                        loadedProductstolist
                                                                            .length
                                                                            .toString())
                                                                    : EnArConvertor()
                                                                        .replaceArNumber(
                                                                            '0'),
                                                                style:
                                                                    TextStyle(
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
                                                                style:
                                                                    TextStyle(
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
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          4.0,
                                                                      left: 6),
                                                              child: Text(
                                                                productsDetail !=
                                                                        null
                                                                    ? EnArConvertor().replaceArNumber(
                                                                        productsDetail
                                                                            .total
                                                                            .toString())
                                                                    : EnArConvertor()
                                                                        .replaceArNumber(
                                                                            '0'),
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Iransans',
                                                                  fontSize:
                                                                      textScaleFactor *
                                                                          13.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: deviceWidth * 0.08,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Text(
                                                        'وضعیت',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: AppTheme.grey,
                                                          fontFamily:
                                                              'Iransans',
                                                          fontSize:
                                                              textScaleFactor *
                                                                  12.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Text(
                                                        'مبلغ(تومان)',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: AppTheme.grey,
                                                          fontFamily:
                                                              'Iransans',
                                                          fontSize:
                                                              textScaleFactor *
                                                                  12.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              height: 1,
                                            ),
                                            Container(
                                              width: double.infinity,
                                              height: deviceHeight * 0.42,
                                              child: ListView.builder(
                                                controller: _scrollController,
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    loadedProductstolist.length,
                                                itemBuilder: (ctx, i) =>
                                                    ChangeNotifierProvider
                                                        .value(
                                                  value:
                                                      loadedProductstolist[i],
                                                  child:
                                                      ClearingItemClearScreen(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 15,
                                right: 15,
                                child: InkWell(
                                  onTap: () {
                                    SnackBar addToCartSnackBar = SnackBar(
                                      content: Text(
                                        'شماره شبا را وارد نمایید',
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
                                    if (shabaController.text == null ||
                                        shabaController.text == 'IR') {
                                      Scaffold.of(context)
                                          .showSnackBar(addToCartSnackBar);
                                    } else {
                                      Provider.of<CustomerInfo>(context,
                                              listen: false)
                                          .sendClearingRequest(
                                              removeSemicolon(
                                                  donationController.text),
                                              shabaController.text,
                                              isLogin)
                                          .then((value) {
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                NavigationBottomScreen
                                                    .routeName,
                                                (Route<dynamic> route) =>
                                                    false);
                                        _showSenddialog();
                                      });
                                    }
                                  },
                                  child: ButtonBottom(
                                    width: deviceWidth * 0.9,
                                    height: deviceWidth * 0.14,
                                    text: 'ثبت درخواست',
                                    isActive: true,
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
                                                  (BuildContext context,
                                                      int index) {
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
            ),
          );
        },
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
