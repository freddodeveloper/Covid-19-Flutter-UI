import 'dart:convert';

import 'package:covid_19/model/data_covid.dart';
import 'package:http/http.dart' as http;
class Consume {
  final String URL = "https://corona.lmao.ninja/v2/countries?sort=country";
  Future<List<DataCovid>> loadCountries() async {
    List<DataCovid> list = [];
    final response =
    await http.get(
        '${URL}',
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      for (var u in jsonData) {
        var aux = u["countryInfo"];
        DataCovid dc = DataCovid(country: u["country"], cases: u["cases"], deaths: u["deaths"], recovered: u["recovered"], flag: aux['flag']);
        list.add(dc);
      }
      return list;
    } else {
      throw Exception('Failed to load post');
    }
  }
}