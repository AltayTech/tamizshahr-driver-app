import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamizshahrdriver/models/clearing.dart';
import 'package:tamizshahrdriver/models/clearing_main.dart';
import 'package:tamizshahrdriver/models/request/collect.dart';
import 'package:tamizshahrdriver/models/request/delivery_main.dart';
import 'package:tamizshahrdriver/models/request/delivery_waste_item.dart';

import '../models/request/collect_main.dart';
import '../models/request/request_waste.dart';
import '../models/request/request_waste_item.dart';
import '../models/request/wasteCart.dart';
import '../models/search_detail.dart';
import 'urls.dart';

class Clearings with ChangeNotifier {
  List<WasteCart> _wasteCartItems = [];

  String _token;

  List<Clearing> _deliveriesItems = [];

  SearchDetail _searchDetails;

  DeliveryWasteItem _requestWasteItem;

  List<Collect> _toDeliveryCollectItems=[];

  Future<void> addWasteCart(WasteCart wasteCart, bool isAdded) async {
    print('addWasteCart');
    try {
      _wasteCartItems
          .firstWhere((prod) => prod.pasmand.id == wasteCart.pasmand.id)
          .isAdded = isAdded;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> addInitialWasteCart(
      List<Collect> wastesCart, bool isAdded) async {
    print('addInitialWasteCart');
    try {
      _wasteCartItems.clear();
      for (int i = 0; i < wastesCart.length; i++) {
        _wasteCartItems.add(
          WasteCart(
            pasmand: wastesCart[i].pasmand,
            estimated_weight: wastesCart[i].estimated_weight,
            estimated_price: wastesCart[i].estimated_price,
            exact_price: wastesCart[i].estimated_price,
            exact_weight: wastesCart[i].estimated_weight,
            isAdded: isAdded,
          ),
        );
      }

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> updateWasteCart(
      WasteCart waste, String exactWeight, bool isAdded) async {
    print('updateShopCart');
    try {
      _wasteCartItems
          .firstWhere((prod) => prod.pasmand.id == waste.pasmand.id)
          .exact_weight = exactWeight.toString();
      _wasteCartItems
          .firstWhere((prod) => prod.pasmand.id == waste.pasmand.id)
          .isAdded = isAdded;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> removeWasteCart(int wasteId) async {
    print('removeShopCart');

    _wasteCartItems.remove(
        _wasteCartItems.firstWhere((prod) => prod.pasmand.id == wasteId));

    notifyListeners();
  }

  String get token => _token;

  List<WasteCart> get wasteCartItems => _wasteCartItems;

  set wasteCartItems(List<WasteCart> value) {
    _wasteCartItems = value;
  }

  Future<void> sendRequest(int storeId, bool isLogin,) async {
    print('sendRequest');
    try {
      if (isLogin) {
        final prefs = await SharedPreferences.getInstance();
        _token = prefs.getString('token');
        print('tooookkkeeennnnnn  $_token');

        final url = Urls.rootUrl + Urls.deliveriesEndPoint + '?store_id=$storeId';
        print('url  $url');

        final response = await post(url,
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json',
              'Accept': 'application/json'
            },
           );

        final extractedData = json.decode(response.body);
        print(extractedData.toString());
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

//  Future<void> searchWastesItem() async {
//    print('searchItem');
//
//    final url = Urls.rootUrl + Urls.pasmandsEndPoint;
//    print(url);
//
//    try {
//      final response = await get(url, headers: {
//        'Content-Type': 'application/json',
//        'Accept': 'application/json'
//      });
//      print(response.statusCode);
//      if (response.statusCode == 200) {
//        final extractedData = json.decode(response.body) as List<dynamic>;
//        print(extractedData);
//
//        List<Waste> wastes =
//            extractedData.map((i) => Waste.fromJson(i)).toList();
//
//        _wasteItems = wastes;
//      } else {
//        _wasteItems = [];
//      }
//      notifyListeners();
//    } catch (error) {
//      print(error.toString());
//      throw (error);
//    }
//  }

  String _selectedHours;
  Jalali _selectedDay;

  String get selectedHours => _selectedHours;

  set selectedHours(String value) {
    _selectedHours = value;
  }

  Jalali get selectedDay => _selectedDay;

  set selectedDay(Jalali value) {
    _selectedDay = value;
  }

  String searchEndPoint = '';
  String searchKey = '';
  var _sPage = 1;
  var _sPerPage = 10;
  var _sOrder = 'desc';
  var _sOrderBy = 'date';
  var _sCategory;

  void searchBuilder() {
    if (!(searchKey == '')) {
      searchEndPoint = '';

      searchEndPoint = searchEndPoint + '?search=$searchKey';
      searchEndPoint = searchEndPoint + '&page=$_sPage&per_page=$_sPerPage';
    } else {
      searchEndPoint = '';

      searchEndPoint = searchEndPoint + '?page=$_sPage&per_page=$_sPerPage';
    }
    if (!(_sOrder == '')) {
      searchEndPoint = searchEndPoint + '&order=$_sOrder';
    }
    if (!(_sOrderBy == '')) {
      searchEndPoint = searchEndPoint + '&orderby=$_sOrderBy';
    }

    if (!(_sCategory == '' || _sCategory == null)) {
      searchEndPoint = searchEndPoint + '&category=$_sCategory';
    }
    print(searchEndPoint);
  }

  Future<void> searchCleaingsItems() async {
    print('searchCleaingsItems');

    final url = Urls.rootUrl + Urls.clearingEndPoint + '$searchEndPoint';
    print(url);

    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      print('tooookkkeeennnnnn  $_token');

      final response = await get(url, headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());

        ClearingMain deliveryMain = ClearingMain.fromJson(extractedData);
        print(deliveryMain.searchDetail.max_page.toString());

        _deliveriesItems = deliveryMain.clearings;
        _searchDetails = deliveryMain.searchDetail;
      } else {
        _deliveriesItems = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveCollectItem(int collectId) async {
    print('retrieveCollectItem');

    final url = Urls.rootUrl + Urls.deliveriesEndPoint + "/$collectId";
    print(url);

    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      print('tooookkkeeennnnnn  $_token');

      final response = await get(url, headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });
      final extractedData = json.decode(response.body) as dynamic;
      print(extractedData);

      DeliveryWasteItem deliveryWasteItem =
      DeliveryWasteItem.fromJson(extractedData);
      print(deliveryWasteItem.id.toString());

      _requestWasteItem = deliveryWasteItem;
    } catch (error) {
      print(error.toString());
      throw (error);
    }
    notifyListeners();
  }

  get sCategory => _sCategory;

  get sOrderBy => _sOrderBy;

  get sOrder => _sOrder;

  get sPerPage => _sPerPage;

  get sPage => _sPage;

  DeliveryWasteItem get deliveriesWasteItem => _requestWasteItem;

  SearchDetail get searchDetails => _searchDetails;

  List<Clearing> get deliveriesItems => _deliveriesItems;

  set sCategory(value) {
    _sCategory = value;
  }

  set sOrderBy(value) {
    _sOrderBy = value;
  }

  set sOrder(value) {
    _sOrder = value;
  }

  set sPerPage(value) {
    _sPerPage = value;
  }

  set sPage(value) {
    _sPage = value;
  }



  Future<void> getCollectedItemsToDeliver() async {
    print('getCollectedItemsToDeliver');

    final url = Urls.rootUrl + Urls.deliveriesEndPoint +'/stat';
    print(url);

    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      print('tooookkkeeennnnnn  $_token');

      final response = await get(url, headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body) as List;
        print(extractedData.toString());

        List<Collect> collects =   extractedData.map((i) => Collect.fromJson(i)).toList();
        _toDeliveryCollectItems.clear();
        _toDeliveryCollectItems = collects;
        print('number of itme: ${_toDeliveryCollectItems.length}');
      } else {
        _toDeliveryCollectItems = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  List<Collect> get toDeliveryCollectItems => _toDeliveryCollectItems;
}
