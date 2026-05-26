import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatefulWidget {
  final User user;
  const CheckoutScreen({super.key, required this.user});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final cart = Cart();
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isOrdering = false;
  String _paymentMethod = 'COD';

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.user.address;
    _phoneController.text = widget.user.phone;
  }

  void _confirmOrder() async {
    if (_addressController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin giao hàng')),
      );
      return;
    }

    final userId = widget.user.id;
    final items = cart.getItems(userId);

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giỏ hàng trống!')),
      );
      return;
    }

    setState(() => _isOrdering = true);

    try {
      Map<String, dynamic> orderData = {
        'user_id': userId,
        'total_amount': cart.getTotalAmount(userId),
        'shipping_address': _addressController.text,
        'phone': _phoneController.text,
        'payment_method': _paymentMethod,
        'items': items.map((item) => {
          'product_id': item.product.id,
          'quantity': item.quantity,
          'unit_price': item.product.price
        }).toList(),
      };

      final response = await ApiService().placeOrder(orderData);
      
      if (response['status'] == 'success') {
        cart.clear(userId); // Xóa giỏ hàng của user này
        if (mounted) {
          _showSuccessDialog();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đặt hàng thất bại: ${response['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi kết nối: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isOrdering = false);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: const Text('Đặt hàng thành công!\nĐơn hàng của bạn đang được xử lý.', textAlign: TextAlign.center),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('QUAY LẠI TRANG CHỦ'),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = widget.user.id;
    final items = cart.getItems(userId);

    return Scaffold(
      appBar: AppBar(title: const Text('Thanh Toán')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Thông tin giao hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Địa chỉ nhận hàng', border: OutlineInputBorder()),
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Số điện thoại', border: OutlineInputBorder()),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            const Text('Phương thức thanh toán', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              title: const Text('Thanh toán khi nhận hàng (COD)'),
              leading: Radio<String>(
                value: 'COD',
                groupValue: _paymentMethod,
                onChanged: (value) => setState(() => _paymentMethod = value!),
              ),
            ),
            ListTile(
              title: const Text('Chuyển khoản ngân hàng'),
              leading: Radio<String>(
                value: 'BANK',
                groupValue: _paymentMethod,
                onChanged: (value) => setState(() => _paymentMethod = value!),
              ),
            ),
            const Divider(height: 40),
            const Text('Tóm tắt đơn hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${item.product.name} x${item.quantity}'),
                  Text(currencyFormat.format(item.product.price * item.quantity)),
                ],
              ),
            )),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tổng thanh toán', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(currencyFormat.format(cart.getTotalAmount(userId)),
                  style: const TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isOrdering ? null : _confirmOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isOrdering 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('XÁC NHẬN ĐẶT HÀNG', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
