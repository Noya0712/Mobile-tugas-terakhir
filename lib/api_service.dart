import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<List<dynamic>> fetchCryptocurrencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cacheData = prefs.getString('cryptocurrencies');

    if (cacheData != null) {
      return json.decode(cacheData);
    } else {
      final response = await http.get(
          Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd'));
      if (response.statusCode == 200) {
        prefs.setString('cryptocurrencies', response.body);
        return json.decode(response.body);
      } else {
        throw Exception('Gagal Syncron');
      }
    }
  }
}



// class ApiService {
//   Future<List<dynamic>> fetchPhotos() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? cacheData = prefs.getString('photos');
//
//     if (cacheData != null) {
//       return json.decode(cacheData);
//     } else {
//       final response = await http.get(
//           Uri.parse('https://jsonplaceholder.typicode.com/photos'));
//       if (response.statusCode == 200) {
//         prefs.setString('photos', response.body);
//         return json.decode(response.body);
//       } else {
//         throw Exception('Gagal Syncron');
//       }
//     }
//   }
// }

