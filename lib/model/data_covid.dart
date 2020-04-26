import 'package:flutter/cupertino.dart';

class DataCovid{
  String country;
  int cases;
  int deaths;
  int recovered;
  String flag;

  DataCovid({
    Key key,
    this.country,
    this.cases,
    this.deaths,
    this.recovered,
    this.flag
  });

  DataCovid.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    cases = json['cases'];
    deaths = json['deaths'];
    recovered = json['recovered'];
    var countryInfo = json['countryInfo'];
    flag = countryInfo['flag'];
  }

}