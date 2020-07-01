import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamizshahrdriver/models/driver.dart';
import 'package:tamizshahrdriver/models/driver_data.dart';

import '../models/city.dart';
import '../models/customer.dart';
import '../models/province.dart';
import '../models/search_detail.dart';
import '../models/shop.dart';
import '../models/status.dart';
import '../models/transaction.dart';
import '../models/transaction_main.dart';
import 'urls.dart';

class CustomerInfo with ChangeNotifier {
  String _payUrl = '';

  int _currentOrderId;

  Shop _shop;

  String get payUrl => _payUrl;
  List<File> chequeImageList = [];

  static Driver _customer_zero = Driver(
    driver_data: DriverData(
      fname: '',
      lname: '',
      email: '',
      ostan: '',
      city: '',
      postcode: '',
      phone: '',
    ),
    money: '0',
  );
  Driver _driver = _customer_zero;
  String _token;

  Driver get driver => _driver;

  Future<void> getCustomer() async {
    print('getCustomer');

    final url = Urls.rootUrl + Urls.driverEndPoint;
    print(url);

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');

    print(_token);

    Driver driver;
    try {
      final response = await get(url, headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      final extractedData = json.decode(response.body);
      print(extractedData);

      driver = Driver.fromJson(extractedData);

      _driver = driver;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> sendCustomer(Customer customer) async {
    print('sendCustomer');

    final url = Urls.rootUrl + Urls.driverEndPoint;

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');

    try {
      final response = await post(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(customer),
      );

      final extractedData = json.decode(response.body);
      print(extractedData);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> fetchShopData() async {
    print('fetchShopData');

    final url = Urls.rootUrl + Urls.shopEndPoint;
    print(url);

    try {
      final response = await get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      final extractedData = json.decode(response.body) as dynamic;
      print(extractedData);

      Shop shopData = Shop.fromJson(extractedData);

      _shop = shopData;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  int get currentOrderId => _currentOrderId;

  set driver(Driver value) {
    _driver = value;
  }

  Driver get driver_zero => _customer_zero;

  Shop get shop => _shop;

  String searchEndPoint = '';
  String searchKey = '';
  var _sPage = 1;
  var _sPerPage = 10;
  var _sOrder = 'desc';
  var _sOrderBy = 'date';

  List<Transaction> _transactionItems = [];

  SearchDetail _searchDetails;
  Transaction _transactionItem;

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

    print(searchEndPoint);
  }

  Future<void> searchTransactionItems() async {
    print('searchTransactionItems');

    final url = Urls.rootUrl + Urls.transactionsEndPoint + '$searchEndPoint';
    print(url);
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');

    try {
      final response = await get(url, headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());

        TransactionMain transactionMain =
            TransactionMain.fromJson(extractedData);
        print(transactionMain.searchDetail.max_page.toString());

        _transactionItems = transactionMain.transactions;
        _searchDetails = transactionMain.searchDetail;
      } else {
        _transactionItems = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveItem(int collectId) async {
    print('retrieveItem');

    final url = Urls.rootUrl + Urls.collectsEndPoint + "/$collectId";
    print(url);

    try {
      final response = await get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });
      final extractedData = json.decode(response.body) as dynamic;
      print(extractedData);

      Transaction transaction = Transaction.fromJson(extractedData);

      _transactionItem = transaction;
    } catch (error) {
      print(error.toString());
      throw (error);
    }
    notifyListeners();
  }

  Transaction get transactionItem => _transactionItem;

  SearchDetail get searchDetails => _searchDetails;

  List<Transaction> get transactionItems => _transactionItems;

  get sOrderBy => _sOrderBy;

  get sOrder => _sOrder;

  get sPerPage => _sPerPage;

  get sPage => _sPage;

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

  Future<void> getProvinces() async {
    print('getProvinces');

    final url = Urls.rootUrl + Urls.provincesEndPoint;
    print(url);

    try {
      final response = await get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body) as List<dynamic>;
        print(extractedData);

        List<Province> wastes =
            extractedData.map((i) => Province.fromJson(i)).toList();

        _provincesItems = wastes;
      } else {
        _provincesItems = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  List<Province> _provincesItems = [];

  List<Province> get provincesItems => _provincesItems;

  Future<void> getCities(int provinceId) async {
    print('getCities');

    final url = Urls.rootUrl + Urls.provincesEndPoint + '$provinceId';
    print(url);

    try {
      final response = await get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body) as List<dynamic>;
        print(extractedData);

        List<City> wastes = extractedData.map((i) => City.fromJson(i)).toList();

        _citiesItems = wastes;
      } else {
        _citiesItems = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  List<City> _citiesItems = [];

  List<City> get citiesItems => _citiesItems;

  Future<void> getTypes() async {
    print('getTypes');

    final url = Urls.rootUrl + Urls.typesEndPoint;
    print(url);

    try {
      final response = await get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body) as List<dynamic>;
        print(extractedData);

        List<Status> wastes =
            extractedData.map((i) => Status.fromJson(i)).toList();

        _typesItems = wastes;
      } else {
        _typesItems = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  List<Status> _typesItems = [];

  List<Status> get typesItems => _typesItems;

  Future<void> sendClearingRequest(String money,String shaba, bool isLogin) async {
    print('sendClearingRequest');
    try {
      if (isLogin) {
        final prefs = await SharedPreferences.getInstance();
        _token = prefs.getString('token');
        print('tooookkkeeennnnnn  $_token');

        final url = Urls.rootUrl + Urls.clearingEndPoint;
        print('url  $url');

        final response = await post(
          url,
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: jsonEncode(
            {
              'money': money,
              'shaba':shaba,

            },
          ),
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
}
