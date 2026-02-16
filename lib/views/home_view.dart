import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ApiService apiService = ApiService();

  late Future<List<Product>> _products;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _products = apiService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(centerTitle: true, title: const Text("Cep Pazar")),

      body: SafeArea(
        child: Column(
          children: [
            // ===== TOP AREA =====
            Column(
              children: [
                // Discover + Cart
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Discover",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart_outlined),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),

                  child: Row(
                    children: const [
                      Expanded(
                        child: Text(
                          "You can find everything you want",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Search
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),

                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search products",
                      prefixIcon: const Icon(Icons.search),

                      filled: true,
                      fillColor: Colors.grey.shade100,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),

                  width: double.infinity,
                  height: 80,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),

                    image: const DecorationImage(
                      image: NetworkImage(
                        "https://www.wantapi.com/assets/banner.png",
                      ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ],
            ),

            // ===== PRODUCT LIST =====
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _products,
                builder: (context, snapshot) {
                  // Loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Error
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Veriler yüklenirken hata oluştu"),
                    );
                  }

                  // Empty
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Ürün bulunamadı"));
                  }

                  final allItems = snapshot.data!;
                  final filteredItems = allItems
                      .where(
                        (product) =>
                            product.title.toLowerCase().contains(searchQuery),
                      )
                      .toList();

                  if (filteredItems.isEmpty) {
                    return const Center(child: Text("Arama sonucu bulunamadı"));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),

                    itemCount: filteredItems.length,

                    itemBuilder: (context, index) {
                      final product = filteredItems[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 3,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),

                                  child: Image.network(
                                    product.thumbnail,
                                    width: double.infinity,
                                    fit: BoxFit.cover,

                                    errorBuilder: (c, e, s) {
                                      return const Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          size: 40,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              // Info
                              Padding(
                                padding: const EdgeInsets.all(8),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,

                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      "${product.price} ₺",

                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
