import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

// Lớp quản lý giỏ hàng theo từng tài khoản
class Cart {
  static final Cart _instance = Cart._internal();
  factory Cart() => _instance;
  Cart._internal();

  // Lưu trữ giỏ hàng dưới dạng: { userId: [List of CartItem] }
  final Map<int, List<CartItem>> _userCarts = {};

  // Lấy danh sách hàng của một user cụ thể
  List<CartItem> getItems(int userId) {
    return _userCarts[userId] ?? [];
  }

  // Thêm vào giỏ hàng của user cụ thể
  void addToCart(int userId, Product product) {
    if (!_userCarts.containsKey(userId)) {
      _userCarts[userId] = [];
    }

    var items = _userCarts[userId]!;
    for (var item in items) {
      if (item.product.id == product.id) {
        item.quantity++;
        return;
      }
    }
    items.add(CartItem(product: product));
  }

  // Tính tổng tiền của user cụ thể
  double getTotalAmount(int userId) {
    var items = getItems(userId);
    return items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  // Xóa giỏ hàng của user sau khi đặt hàng
  void clear(int userId) {
    _userCarts[userId] = [];
  }
  
  // Xóa 1 sản phẩm khỏi giỏ của user
  void removeItem(int userId, int index) {
    if (_userCarts.containsKey(userId)) {
      _userCarts[userId]!.removeAt(index);
    }
  }
}
