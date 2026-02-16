import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  final String url = "https://dummyjson.com/products";

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List list = data['products'];

      return list.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Ürünler yüklenemedi");
    }
  }
}
