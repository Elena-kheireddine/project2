import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'search.dart';

const String _baseURL = 'projectcsci410.000webhostapp.com';

class Product {
  int _pid;
  String _name;
  double _price;
  String _category;

  Product(this._pid, this._name, this._price, this._category);

  @override
  String toString() {
    return 'PID: $_pid Name: $_name\nPrice: \$$_price\nCategory: $_category';
  }
}

List<Product> _products = [];

void updateProducts(Function(bool success) update) async {
  try {
    final url = Uri.https(_baseURL, 'getProducts.php');
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5));
    _products.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      for (var row in jsonResponse) {
        Product p = Product(
            int.parse(row['pid']),
            row['name'],
            double.parse(row['price']),
            row['category']);
        _products.add(p);
      }
      update(true);
    }
  }
  catch(e) {
    update(false);
  }
}

void searchProducts(Function(String text) update, int pid) async {
  try {
    final url = Uri.https(_baseURL, 'searchProduct.php', {'pid':'$pid'});
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5));
    _products.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      var row = jsonResponse[0];
      Product p = Product(
          int.parse(row['pid']),
          row['name'],
          double.parse(row['price']),
          row['category']);
      _products.add(p);
      update(p.toString());
    }
  }
  catch(e) {
    update("can't load data");
  }
}

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool _load = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: !_load ? null : () {
          setState(() {
            _load = false;
          });
        }, icon: const Icon(Icons.refresh)),
        IconButton(onPressed: () {
          setState(() { 
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Search())
            );
          });
        }, icon: const Icon(Icons.search))
      ],
        title: Text('Available products'),
        centerTitle: true,
      ),body: Center(
      child: Column(
        children: [
       ListView.builder(
      itemCount: _products.length,
          itemBuilder: (context, index) {
            return Column(children: [
              const SizedBox(height: 3),
              Row(children: [
                SizedBox(width: width * 0.33),
                Container(width: width * 0.4,
                  color: index % 2 == 0? Colors.deepPurple: Colors.blue,
                  child: Text(_products[index].toString(), style: const TextStyle(fontSize: 18)),
                )
              ],)
            ],);
          }
      )
        ],
      ),
    ),
    );
  }
}
