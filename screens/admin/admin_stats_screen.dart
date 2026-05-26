import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'package:intl/intl.dart';

class AdminStatsScreen extends StatefulWidget {
  const AdminStatsScreen({super.key});

  @override
  State<AdminStatsScreen> createState() => _AdminStatsScreenState();
}

class _AdminStatsScreenState extends State<AdminStatsScreen> {
  final ApiService _apiService = ApiService();
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê hệ thống'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _apiService.getAdminStats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            }

            final data = snapshot.data!;
            final overview = data['overview'] ?? {};
            final Map<String, dynamic> statusCounts = Map<String, dynamic>.from(data['status_counts'] ?? {});
            final totalUsers = data['total_users'] ?? 0;
            final List topProducts = List.from(data['top_products'] ?? []);

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Doanh thu (Chỉ tính Delivered)
                  _buildRevenueCard(overview['total_revenue']),
                  const SizedBox(height: 20),

                  // 2. Trạng thái đơn hàng
                  const Text('Trạng thái đơn hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      _buildStatusItem('Chờ duyệt', statusCounts['pending'] ?? 0, Colors.orange),
                      _buildStatusItem('Đã xác nhận', statusCounts['confirmed'] ?? 0, Colors.blue),
                      _buildStatusItem('Đang giao', statusCounts['shipping'] ?? 0, Colors.purple),
                      _buildStatusItem('Thành công', statusCounts['delivered'] ?? 0, Colors.green),
                      _buildStatusItem('Đã hủy', statusCounts['cancelled'] ?? 0, Colors.red),
                      _buildStatusItem('Tổng đơn', overview['total_orders'] ?? 0, Colors.black54),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // 3. Khách hàng
                  _buildSimpleStatTile('Tổng số khách hàng', totalUsers.toString(), Icons.people, Colors.teal),
                  const SizedBox(height: 30),
                  
                  // 4. Top sản phẩm bán chạy
                  const Text('Top 5 sản phẩm bán chạy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: topProducts.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final p = topProducts[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.purple.shade100,
                            child: Text('${index + 1}', style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                          ),
                          title: Text(p['name'], style: const TextStyle(fontWeight: FontWeight.w500)),
                          trailing: Text('${p['sold_count']} sản phẩm', style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRevenueCard(dynamic amount) {
    double value = double.tryParse(amount?.toString() ?? '0') ?? 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.purple.shade700, Colors.purple.shade400]),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          const Text('TỔNG DOANH THU THỰC TẾ', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(currencyFormat.format(value), style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const Text('(Chỉ tính đơn hàng đã hoàn thành)', style: TextStyle(color: Colors.white60, fontSize: 12, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, dynamic count, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 4, height: 25, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
                Text(count.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStatTile(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), 
        side: BorderSide(color: color.withOpacity(0.2))
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ),
    );
  }
}
