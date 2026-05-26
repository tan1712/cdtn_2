import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.103/api_ban_hang';
  
  // Thêm client để hỗ trợ Mocking khi Test
  final http.Client client;
  ApiService({http.Client? client}) : client = client ?? http.Client();

  // 1. Lấy danh sách sản phẩm
  Future<List<Product>> getProducts({int? categoryId}) async {
    try {
      String url = '$baseUrl/get_products.php';
      if (categoryId != null) url += '?category_id=$categoryId';
      final response = await client.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Product.fromJson(data)).toList();
      } else {
        throw Exception('Server lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi nạp sản phẩm: $e');
    }
  }

  // 2. Đăng nhập
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await client.post(Uri.parse('$baseUrl/login.php'), body: {'username': username, 'password': password});
    return json.decode(response.body);
  }

  // 3. Đăng ký
  Future<Map<String, dynamic>> register({required String username, required String password, required String fullName, required String email, required String phone, required String address}) async {
    final response = await client.post(Uri.parse('$baseUrl/register.php'), body: {'username': username, 'password': password, 'full_name': fullName, 'email': email, 'phone': phone, 'address': address});
    return json.decode(response.body);
  }

  // 4. Đặt hàng
  Future<Map<String, dynamic>> placeOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/place_order.php'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(orderData),
      ).timeout(const Duration(seconds: 15));

      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': 'Lỗi kết nối Server: $e'};
    }
  }

  // 5. Thêm/Sửa sản phẩm
  Future<Map<String, dynamic>> saveProduct(Map<String, dynamic> productData, {bool isEdit = false}) async {
    String url = isEdit ? '$baseUrl/update_product.php' : '$baseUrl/add_product.php';
    final response = await client.post(Uri.parse(url), body: productData.map((key, value) => MapEntry(key, value.toString())));
    return json.decode(response.body);
  }

  // 6. Xóa sản phẩm
  Future<Map<String, dynamic>> deleteProduct(int id) async {
    final response = await client.post(Uri.parse('$baseUrl/delete_product.php'), body: {'id': id.toString()});
    return json.decode(response.body);
  }

  // 7. Lấy danh sách người dùng
  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await client.get(Uri.parse('$baseUrl/get_users.php'));
    if (response.statusCode == 200) return List<Map<String, dynamic>>.from(json.decode(response.body));
    throw Exception('Lỗi nạp người dùng');
  }

  // 8. Xóa người dùng
  Future<Map<String, dynamic>> deleteUser(int id) async {
    final response = await client.post(Uri.parse('$baseUrl/delete_user.php'), body: {'id': id.toString()});
    return json.decode(response.body);
  }

  // 9. Lấy danh sách đơn hàng
  Future<List<Map<String, dynamic>>> getOrders() async {
    final response = await client.get(Uri.parse('$baseUrl/get_orders.php'));
    if (response.statusCode == 200) return List<Map<String, dynamic>>.from(json.decode(response.body));
    throw Exception('Lỗi nạp đơn hàng');
  }

  // 10. Cập nhật trạng thái đơn hàng
  Future<Map<String, dynamic>> updateOrderStatus(int orderId, String status) async {
    final response = await client.post(Uri.parse('$baseUrl/update_order_status.php'), body: {'id': orderId.toString(), 'status': status});
    return json.decode(response.body);
  }

  // 11. Lấy thống kê
  Future<Map<String, dynamic>> getAdminStats() async {
    final response = await client.get(Uri.parse('$baseUrl/get_stats.php'));
    if (response.statusCode == 200) return json.decode(response.body);
    throw Exception('Lỗi thống kê');
  }

  // 12. Lịch sử đơn hàng
  Future<List<Map<String, dynamic>>> getOrderHistory(int userId) async {
    final response = await client.get(Uri.parse('$baseUrl/get_order_history.php?user_id=$userId'));
    if (response.statusCode == 200) return List<Map<String, dynamic>>.from(json.decode(response.body));
    throw Exception('Không thể tải lịch sử');
  }

  // 13. Cập nhật Profile
  Future<Map<String, dynamic>> updateProfile({required int userId, required String fullName, required String phone, required String address}) async {
    final response = await client.post(Uri.parse('$baseUrl/update_profile.php'), body: {'id': userId.toString(), 'full_name': fullName, 'phone': phone, 'address': address});
    return json.decode(response.body);
  }

  // 14. Gọi AI tư vấn
  Future<String> askAI(String userPrompt) async {
    const String apiKey = "AIzaSyD94QV-tmfs-JV2QbP9UQ2fLc6jgRwFGG0";
    const String aiUrl = "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$apiKey";

    try {
      String productList = "Hiện không có dữ liệu sản phẩm.";
      try {
        List<Product> products = await getProducts();
        productList = products.map((p) => "- ${p.name}: ${p.price}₫").join("\n");
      } catch (e) {}

      final response = await client.post(
        Uri.parse(aiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "contents": [{"parts": [{"text": "Bạn là trợ lý ảo thông minh của UD SHOP. Trả lời câu hỏi: $userPrompt. Dữ liệu shop: $productList"}]}]
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return "Lỗi hệ thống (${response.statusCode})";
      }
    } catch (e) {
      return "Lỗi kết nối AI";
    }
  }
}
