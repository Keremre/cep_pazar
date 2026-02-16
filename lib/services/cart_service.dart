import '../models/cart_item.dart';
import '../models/product.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  final List<CartItem> _cartItems = [];

  CartService._internal();

  factory CartService() {
    return _instance;
  }

  List<CartItem> get cartItems => _cartItems;

  void addToCart(Product product) {
    final existingItem = _cartItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity > 0) {
      existingItem.quantity++;
    } else {
      _cartItems.add(CartItem(product: product, quantity: 1));
    }
  }

  void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
  }

  void updateQuantity(int productId, int quantity) {
    final item = _cartItems.firstWhere((item) => item.product.id == productId);
    item.quantity = quantity;
  }

  double getTotalPrice() {
    return _cartItems.fold(
      0,
      (total, item) => total + (item.product.price * item.quantity),
    );
  }

  void clearCart() {
    _cartItems.clear();
  }
}
