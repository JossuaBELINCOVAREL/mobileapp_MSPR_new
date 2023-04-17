import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    home: ProductListScreen(),
  ));
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _productList;

  @override
  void initState() {
    super.initState();
    _productList = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final response =
    await http.get(Uri.parse('http://localhost:8000/api/products'));

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: Center(
        child: FutureBuilder<List<Product>>(
          future: _productList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Product product = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text('Price: ${product.productDetail.price}'),
                      trailing: Text('Stock: ${product.stock}'),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class Product {
  final int id;
  final String name;
  final int stock;
  final ProductDetail productDetail;

  Product({
    required this.id,
    required this.name,
    required this.stock,
    required this.productDetail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      stock: json['stock'],
      productDetail: ProductDetail.fromJson(json['product_detail']),
    );
  }
}

class ProductDetail {
  final int id;
  final int price;
  final String description;
  final String color;

  ProductDetail({
    required this.id,
    required this.price,
    required this.description,
    required this.color,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id'],
      price: json['price'],
      description: json['description'],
      color: json['color'],
    );
  }
}
