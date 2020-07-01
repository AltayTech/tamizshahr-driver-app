import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:tamizshahrdriver/screens/statistic_list_screen.dart';
import 'package:tamizshahrdriver/widgets/en_to_ar_number_convertor.dart';
import 'package:tamizshahrdriver/widgets/main_drawer.dart';

import '../provider/app_theme.dart';
import '../provider/auth.dart';
import '../widgets/custom_dialog.dart';

class StatisticsScreen extends StatefulWidget {
  static const routeName = '/StatisticsScreen';

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool _isInit = true;

  int _selectedItem = 1;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _isInit = false;

      Provider.of<Auth>(context, listen: false).getToken();

      bool _isFirstLogin =
          Provider.of<Auth>(context, listen: false).isFirstLogin;
      if (_isFirstLogin) {
        _showLoginDialog(context);
      }
      bool _isFirstLogout =
          Provider.of<Auth>(context, listen: false).isFirstLogout;
      if (_isFirstLogout) {
        _showLoginDialogExit(context);
      }

      Provider.of<Auth>(context, listen: false).isFirstLogin = false;
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  void _showLoginDialog(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (ctx) => CustomDialog(
          title: 'خوش آمدید',
          buttonText: 'تایید',
          description:
              'برای دریافت اطلاعات کاربری به قسمت پروفایل مراجعه فرمایید',
        ),
      );
    });
  }

  void _showLoginDialogExit(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (ctx) => CustomDialog(
          title: 'کاربر گرامی',
          buttonText: 'تایید',
          description: 'شما با موفقیت از اکانت کاربری خارج شدید',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    double itemPaddingF = 0.019;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: Text(
          'آمار',
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 16, left: 16, right: 16, bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.08),
                              blurRadius: 10.10,
                              spreadRadius: 10.510,
                              offset: Offset(
                                0,
                                0,
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.calendar_today,
                                color: AppTheme.iconColor1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                EnArConvertor()
                                    .replaceArNumber('${Jalali.fromDateTime(
                                  DateTime.now(),
                                ).year}/${Jalali.fromDateTime(
                                  DateTime.now(),
                                ).month}/${Jalali.fromDateTime(
                                  DateTime.now(),
                                ).day}'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppTheme.h1,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 16.0,
                                ),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.access_time,
                                color: AppTheme.iconColor1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                EnArConvertor().replaceArNumber(
                                    '${DateTime.now().hour}:${DateTime.now().minute}'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppTheme.h1,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: deviceHeight * 0.7,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return StatisticsListScreen();
                      },
                    ),
                  )
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
