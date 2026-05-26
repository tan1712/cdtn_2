import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatelessWidget {
  final User user;
  const OrderHistoryScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    String translateStatus(String status) {
      switch (status) {
        case 'pending': return 'Chờ xác nhận';
        case 'confirmed': return 'Đã xác nhận';
        case 'shipping': return 'Đang giao';
        case 'delivered': return 'Hoàn thành';
        case 'cancelled': return 'Đã hủy';
        default: return status;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng của tôi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: apiService.getOrderHistory(user.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text('Bạn chưa có đơn hàng nào'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Mã đơn hàng: #${order['id']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ngày: ${order['order_date']}'),
                      Text('Tổng tiền: ${currencyFormat.format(double.parse(order['total_amount'].toString()))}'),
                      Text('Trạng thái: ${translateStatus(order['status'])}', 
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
