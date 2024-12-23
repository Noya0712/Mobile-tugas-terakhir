import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:presistensi_dara/api_service.dart';
import 'chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cryptocurrency Info",
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<dynamic> cryptocurrencies = [];
  List<dynamic> filteredCryptocurrencies = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchCryptocurrencies();
  }
  Future<void> fetchCryptocurrencies() async {
    final data = await apiService.fetchCryptocurrencies();
    data.sort((a, b) => b['current_price'].compareTo(a['current_price']));
    setState(() {
      cryptocurrencies = data;
      filteredCryptocurrencies = data;
    });
  }
  void filterSearchResults(String query) {
    setState(() {
      searchQuery = query;
      filteredCryptocurrencies = cryptocurrencies
          .where((crypto) => crypto['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
  void navigateToDetail(BuildContext context, dynamic crypto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(crypto: crypto),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Crypto Info by Holut Yudawan 2014")),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterSearchResults,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: filteredCryptocurrencies.isNotEmpty
                ? ListView.separated(
              itemCount: filteredCryptocurrencies.length,
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = filteredCryptocurrencies[index];
                final name = item['name'] ?? 'No Name';
                final currentPrice = item['current_price'] ?? 0.0;
                final imageUrl = item['image'] ?? '';

                return GestureDetector(
                  onTap: () => navigateToDetail(context, item),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: imageUrl.isNotEmpty
                          ? Image.network(imageUrl, width: 40, height: 40)
                          : Placeholder(fallbackHeight: 40, fallbackWidth: 40),
                      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Price: \$${currentPrice.toStringAsFixed(2)}'),
                    ),
                  ),
                );
              },
            )
                : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final dynamic crypto;

  DetailScreen({required this.crypto});

  @override
  Widget build(BuildContext context) {
    final name = crypto['name'] ?? 'No Name';
    final currentPrice = crypto['current_price'] ?? 0.0;
    final imageUrl = crypto['image'] ?? '';

    final List<FlSpot> priceData = [
      FlSpot(1, 100),
      FlSpot(2, 200),
      FlSpot(3, 150),
      FlSpot(4, 300),
      FlSpot(5, 250),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(imageUrl, height: 100, width: 100),
            SizedBox(height: 20),
            Text('Current Price: \$${currentPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Expanded(
              child: Chart(priceData: priceData),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:presistensi_dara/api_service.dart';
// import 'chart.dart'; // Impor file chart.dart
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Cryptocurrency Info",
//       home: HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final ApiService apiService = ApiService();
//   List<dynamic> cryptocurrencies = [];
//   List<dynamic> filteredCryptocurrencies = [];
//   String searchQuery = '';
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCryptocurrencies();
//   }
//
//   Future<void> fetchCryptocurrencies() async {
//     final data = await apiService.fetchCryptocurrencies();
//     // Mengurutkan berdasarkan harga tertinggi
//     data.sort((a, b) => b['current_price'].compareTo(a['current_price']));
//     setState(() {
//       cryptocurrencies = data;
//       filteredCryptocurrencies = data; // Inisialisasi daftar yang difilter
//     });
//   }
//
//   void filterSearchResults(String query) {
//     setState(() {
//       searchQuery = query;
//       filteredCryptocurrencies = cryptocurrencies
//           .where((crypto) => crypto['name'].toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }
//
//   void navigateToDetail(BuildContext context, dynamic crypto) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DetailScreen(crypto: crypto),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Text("Crypto Info by Holut Yudawan 2014")), // Judul di tengah
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: filterSearchResults,
//               decoration: InputDecoration(
//                 labelText: 'Search',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//           ),
//           Expanded(
//             child: filteredCryptocurrencies.isNotEmpty
//                 ? ListView.separated(
//               itemCount: filteredCryptocurrencies.length,
//               separatorBuilder: (context, index) => SizedBox(height: 10),
//               itemBuilder: (context, index) {
//                 final item = filteredCryptocurrencies[index];
//                 final name = item['name'] ?? 'No Name';
//                 final currentPrice = item['current_price'] ?? 0.0;
//                 final imageUrl = item['image'] ?? '';
//
//                 return GestureDetector(
//                   onTap: () => navigateToDetail(context, item), // Navigasi ke detail
//                   child: Container(
//                     margin: EdgeInsets.symmetric(horizontal: 5),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.grey, width: 1),
//                     ),
//                     child: ListTile(
//                       contentPadding: EdgeInsets.all(10),
//                       leading: imageUrl.isNotEmpty
//                           ? Image.network(imageUrl, width: 40, height: 40)
//                           : Placeholder(fallbackHeight: 40, fallbackWidth: 40),
//                       title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
//                       subtitle: Text('Price: \$${currentPrice.toStringAsFixed(2)}'),
//                     ),
//                   ),
//                 );
//               },
//             )
//                 : Center(child: CircularProgressIndicator()), // Menampilkan indikator loading
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class DetailScreen extends StatelessWidget {
//   final dynamic crypto;
//
//   DetailScreen({required this.crypto});
//
//   @override
//   Widget build(BuildContext context) {
//     final name = crypto['name'] ?? 'No Name';
//     final currentPrice = crypto['current_price'] ?? 0.0;
//     final imageUrl = crypto['image'] ?? '';
//
//     // Contoh data harga untuk grafik
//     final List<FlSpot> priceData = [
//       FlSpot(1, 100),
//       FlSpot(2, 200),
//       FlSpot(3, 150),
//       FlSpot(4, 300),
//       FlSpot(5, 250),
//     ];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(name),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Image.network(imageUrl, height: 100, width: 100),
//             SizedBox(height: 20),
//             Text('Current Price: \$${currentPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             Expanded(
//               child: Chart(priceData: priceData), // Menggunakan Chart dari chart.dart
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// class HomeScreen extends StatelessWidget {
//   final ApiService apiService = ApiService();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text("Api-Post")),
//         body:  FutureBuilder<List<dynamic>>(
//             future: apiService.fetchPost(),
//             builder:(context,snapshot){
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else {
//                 return ListView.builder(
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, index){
//                       return ListTile(
//                         title: Text(snapshot.data![index]['title']),
//                         subtitle: Text(snapshot.data![index]['body']),
//                       );
//                     }
//                 );
//               }
//
//             }
//         )
//     );
//   }
//
// }