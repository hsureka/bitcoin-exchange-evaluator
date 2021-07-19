import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'networking.dart';

class PriceScreen extends StatefulWidget {
  final convertdata;
  PriceScreen({this.convertdata});
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  int btc = 0, ltc = 0, eth = 0;
  dynamic convertData;
  String url =
      'https://api.nomics.com/v1/currencies/ticker?key=a4af5f8432a63f8a758737cfef9e0494&ids=BTC,ETH,LTC&interval=1d,30d&convert=USD&per-page=100&page=1';

  @override
  void initState() {
    super.initState();
    convertData = widget.convertdata;
    print(convertData);
    updateValues(convertData);
  }

  void updateValues(var converteddata) {
    btc = double.parse(converteddata[0]['price']).toInt();
    eth = double.parse(converteddata[1]['price']).toInt();
    ltc = double.parse(converteddata[2]['price']).toInt();
    print(btc);
    print(eth);
    print(ltc);
  }

  Future<void> updateSelectedCurrency() async {
    await getValue(selectedCurrency);
  }

  Widget androidPicker() {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: getDropDownItems(),
      onChanged: (value) async {
        print(value);
        selectedCurrency = value;
        await updateSelectedCurrency();
        setState(() {
          //selectedCurrency = value;
          //updateSelectedCurrency();
          updateValues(convertData);
        });
      },
    );
  }

  List<DropdownMenuItem> getDropDownItems() {
    List<DropdownMenuItem<String>> menuItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      menuItems.add(newItem);
    }
    return menuItems;
  }

  Widget iosPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: getCupertinoItems(),
    );
  }

  List<Text> getCupertinoItems() {
    List<Text> menuItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      menuItems.add(newItem);
    }
    return menuItems;
  }

  Future<void> getValue(String selected) async {
    print('selected');
    url =
        'https://api.nomics.com/v1/currencies/ticker?key=a4af5f8432a63f8a758737cfef9e0494&ids=BTC,ETH,LTC&interval=1d,30d&convert=$selected&per-page=100&page=1';
    NetworkHelper networkHelper = NetworkHelper(url);
    var converterdata = await networkHelper.getData();
    convertData = converterdata;
    print(convertData[0]['price']);
    //updateValues(convertData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $btc $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  'ETH = $eth $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 LTC = $ltc $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: (Platform.isIOS) ? (iosPicker()) : (androidPicker()),
          ),
        ],
      ),
    );
  }
}
