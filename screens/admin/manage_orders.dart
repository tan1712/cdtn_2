import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'package:intl/intl.dart';

class ManageOrders extends StatefulWidget {
  const ManageOrders({super.key});

  @override
  State<ManageOrders> createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  final ApiService _apiService = ApiService();
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  // Map từ giá trị Database (Enum) sang tiếng Việt để hiển thị
  String _translateStatus(String status) {
    switch (status) {
      case 'pending': return 'Chờ xác nhận';
      case 'confirmed': return 'Đã xác nhận';
      case 'shipping': return 'Đang giao hàng';
      case 'delivered': return 'Đã giao hàng';
      case 'cancelled': return 'Đã hủy';
      default: return status;
    }
  }

  Future<void> _updateStatus(int orderId, String currentStatus) async {
    String? newStatus = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cập nhật trạng thái'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _statusOption(context, 'pending', 'Chờ xác nhận', Colors.orange),
            _statusOption(context, 'confirmed', 'Xác nhận đơn', Colors.blue),
            _statusOption(context, 'shipping', 'Bắt đầu giao', Colors.indigo),
            _statusOption(context, 'delivered', 'Đã hoàn thành', Colors.green),
            _statusOption(context, 'cancelled', 'Hủy đơn', Colors.red),
          ],
        ),
      ),
    );

    if (newStatus != null && newStatus != currentStatus) {
      try {
        final response = await _apiService.updateOrderStatus(orderId, newStatus);
        if (response['status'] == 'success') {
          setState(() {});
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cập nhật thành công')));
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  Widget _statusOption(BuildContext context, String value, String label, Color color) {
    return ListTile(
      title: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      onTap: () => Navigator.pop(context, value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý đơn hàng'), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _apiService.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Lỗi: ${snapshot.error}'));
          
          final orders = snapshot.data ?? [];
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final status = order['status'] ?? 'pending';
              
              return Card(
                margin: const EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text('Đơn hàng #${order['id']} - ${order['full_name']}'),
                  subtitle: Text('Tổng: ${currencyFormat.format(double.tryParse(order['total_amount'].toString()) ?? 0)}'),
                  trailing: Text(_translateStatus(status), style: TextStyle(color: _getStatusColor(status), fontWeight: FontWeight.bold)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ngày đặt: ${order['order_date'] ?? 'N/A'}'), // Đổi sang order_date theo hình
                          Text('SĐT: ${order['phone']}'),
                          Text('Địa chỉ: ${order['shipping_address']}'),
                          Text('Thanh toán: ${order['payment_method']}'),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _updateStatus(int.parse(order['id'].toString()), status),
                              child: const Text('THAY ĐỔI TRẠNG THÁI'),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'confirmed': return Colors.blue;
      case 'shipping': return Colors.indigo;
      case 'delivered': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }
}
