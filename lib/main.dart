import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: ProductListScreen(),
  ));
}

class ProductListScreen extends StatefulWidget {
  final http.Client? client;

  const ProductListScreen({Key? key, this.client}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _productList;

  @override
  void initState() {
    super.initState();
    _productList = fetchProducts(client: widget.client);
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
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(product.name),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('ID: ${product.id}'),
                                  Text('Stock: ${product.stock}'),
                                  Text('Price: ${product.productDetail.price}'),
                                  Text(
                                      'Description: ${product.productDetail.description}'),
                                  Text('Color: ${product.productDetail.color}'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
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

Future<List<Product>> fetchProducts({http.Client? client}) async {
  client ??= http.Client();

  final response =
      await client.get(Uri.parse('http://localhost:8000/api/products'));

  if (response.statusCode == 200) {
    Iterable jsonResponse = json.decode(response.body);
    return jsonResponse.map((product) => Product.fromJson(product)).toList();
  } else {
    throw Exception('Failed to load products');
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
