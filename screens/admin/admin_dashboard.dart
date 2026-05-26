import 'package:flutter/material.dart';
import 'manage_products.dart';
import 'manage_users.dart';
import 'manage_orders.dart';
import 'admin_stats_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QUẢN TRỊ VIÊN'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            _buildAdminCard(context, 'Sản phẩm', Icons.inventory, Colors.orange, const ManageProducts()),
            _buildAdminCard(context, 'Người dùng', Icons.people, Colors.blue, const ManageUsers()),
            _buildAdminCard(context, 'Đơn hàng', Icons.receipt_long, Colors.green, const ManageOrders()),
            _buildAdminCard(context, 'Thống kê', Icons.bar_chart, Colors.purple, const AdminStatsScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, String title, IconData icon, Color color, Widget? screen) {
    return InkWell(
      onTap: () {
        if (screen != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
        }
      },
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
