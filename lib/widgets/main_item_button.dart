import 'package:flutter/material.dart';
import 'package:tamizshahrdriver/provider/app_theme.dart';

class MainItemButton extends StatelessWidget {
  const MainItemButton({
    Key key,
    @required this.title,
    @required this.itemPaddingF,
    this.imageSizeFactor = 0.35,
    this.isMonoColor = true,
    this.selectedItem,
    this.icon,
  }) : super(key: key);

  final String title;
  final double itemPaddingF;
  final double imageSizeFactor;
  final bool isMonoColor;
  final int selectedItem;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return LayoutBuilder(
      builder: (_, constraint) => Padding(
        padding: EdgeInsets.all(deviceWidth * itemPaddingF),
        child: Container(
          decoration: BoxDecoration(
              color: selectedItem == 1
                  ? AppTheme.primary
                  : AppTheme.white,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  bottom: 10,
                  top: 16,
                ),
                child: Container(
                  height: constraint.maxHeight * 0.25,
                  child: icon,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 8, top: 10),
                child: FittedBox(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selectedItem == 1
                          ? AppTheme.white
                          : Colors.black45,
                      fontFamily: 'Iransans',
                      fontWeight: FontWeight.w600,
                      fontSize: textScaleFactor * 12.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
