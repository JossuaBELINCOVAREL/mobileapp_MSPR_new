import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';
// import 'main.dart'; // Import your main.dart file or the file containing the Product, ProductDetail classes and fetchProducts function
import 'package:mspr/main.dart'; // Import your main.dart file or the file containing the Product, ProductDetail classes and fetchProducts function

void main() {
  group('Product and ProductDetail', () {
    test('fromJson() creates a Product object from a JSON object', () {
      final productJson = {
        'id': 1,
        'name': 'Sample Product',
        'stock': 10,
        'product_detail': {
          'id': 1,
          'price': 100,
          'description': 'Sample description',
          'color': 'Sample color',
        },
      };

      final product = Product.fromJson(productJson);

      expect(product.id, 1);
      expect(product.name, 'Sample Product');
      expect(product.stock, 10);
      expect(product.productDetail.id, 1);
      expect(product.productDetail.price, 100);
      expect(product.productDetail.description, 'Sample description');
      expect(product.productDetail.color, 'Sample color');
    });

    test('fromJson() creates a ProductDetail object from a JSON object', () {
      final productDetailJson = {
        'id': 1,
        'price': 100,
        'description': 'Sample description',
        'color': 'Sample color',
      };

      final productDetail = ProductDetail.fromJson(productDetailJson);

      expect(productDetail.id, 1);
      expect(productDetail.price, 100);
      expect(productDetail.description, 'Sample description');
      expect(productDetail.color, 'Sample color');
    });
  });

  group('fetchProducts', () {
    test('returns a list of products when the API call is successful', () async {
      final jsonResponse = [
        {
          'id': 1,
          'name': 'Sample Product 1',
          'stock': 10,
          'product_detail': {
            'id': 1,
            'price': 100,
            'description': 'Sample description 1',
            'color': 'Sample color 1',
          },
        },
        {
          'id': 2,
          'name': 'Sample Product 2',
          'stock': 20,
          'product_detail': {
            'id': 2,
            'price': 200,
            'description': 'Sample description 2',
            'color': 'Sample color 2',
          },
        },
      ];

      // Mock the http.get call
      http.Client client = MockClient((request) async {
        return http.Response(json.encode(jsonResponse), 200);
      });

      final products = await fetchProducts(client: client);
      expect(products.length, 2);

      // Verify the first product
      expect(products[0].id, 1);
      expect(products[0].name, 'Sample Product 1');
      expect(products[0].stock, 10);
      expect(products[0].productDetail.price, 100);

      // Verify the second product
      expect(products[1].id, 2);
      expect(products[1].name, 'Sample Product 2');
      expect(products[1].stock, 20);
      expect(products[1].productDetail.price, 200);
    });

    test('throws an exception when the API call fails', () async {
      // Mock the http.get call to return an error
      http.Client client = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      expect(fetchProducts(client: client), throwsA(isA<Exception>()));
    });
  });
}
