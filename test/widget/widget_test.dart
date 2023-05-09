import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mspr/main.dart'; // Replace 'your_app' with your actual app name

void main() {
  testWidgets('ProductListScreen displays a list of products',
      (WidgetTester tester) async {
    // Mock the API response
    final mockClient = MockClient((request) async {
      return http.Response('''
        [
          {
            "id": 1,
            "name": "Product 1",
            "stock": 10,
            "product_detail": {
              "id": 1,
              "price": 100,
              "description": "Product 1 description",
              "color": "red"
            }
          },
          {
            "id": 2,
            "name": "Product 2",
            "stock": 20,
            "product_detail": {
              "id": 2,
              "price": 200,
              "description": "Product 2 description",
              "color": "blue"
            }
          }
        ]
      ''', 200);
    });

    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: ProductListScreen(client: mockClient),
    ));

    // Wait for the FutureBuilder to complete
    await tester.pumpAndSettle();

    // Check if the products are displayed
    expect(find.text('Product 1'), findsOneWidget);
    expect(find.text('Price: 100'), findsOneWidget);
    expect(find.text('Stock: 10'), findsOneWidget);

    expect(find.text('Product 2'), findsOneWidget);
    expect(find.text('Price: 200'), findsOneWidget);
    expect(find.text('Stock: 20'), findsOneWidget);
  });
}
