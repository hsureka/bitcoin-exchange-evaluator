import 'networking.dart';
import 'package:flutter/material.dart';
import 'price_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getValues();
  }

  void getValues() async {
    String selected = 'USD';
    print('selected');
    String url =
        'https://api.nomics.com/v1/currencies/ticker?key=a4af5f8432a63f8a758737cfef9e0494&ids=BTC,ETH,LTC&interval=1d,30d&convert=$selected&per-page=100&page=1';
    NetworkHelper networkHelper = NetworkHelper(url);
    var converterdata = await networkHelper.getData();
    dynamic convertData = converterdata;
    print(convertData[0]['price']);
    //updateValues(convertData);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PriceScreen(convertdata: convertData)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
