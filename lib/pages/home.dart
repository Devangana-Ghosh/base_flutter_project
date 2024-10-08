import 'package:flutter/material.dart';
import '../services/api.dart';
import '../constants/errors.dart';
import 'Profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  Future<void> _getProducts() async {
    try {
      List<dynamic> fetchedProducts = await ApiService.getProducts();
      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      print('Error fetching products: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(AppErrors.productsFetchFailed, style: const TextStyle(fontSize: 18.0)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileSettings()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(//format ressponse
        itemCount: products.length,
        itemBuilder: (context, index) {
          dynamic product = products[index];
          return ListTile(
            title: Text(product['title']),
            subtitle: Text('\$${product['price']}'),
            leading: Image.network(
              product['image'],
              width: 50,
              height: 50,
            ),
          );
        },
      ),
    );
  }
}
