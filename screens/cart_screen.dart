import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/user.dart';
import 'checkout_screen.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  final User? user;
  const CartScreen({super.key, this.user});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cart = Cart();
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  Widget build(BuildContext context) {
    if (widget.user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Giỏ hàng')),
        body: const Center(child: Text('Vui lòng đăng nhập để xem giỏ hàng')),
      );
    }

    final userId = widget.user!.id;
    final items = cart.getItems(userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: items.isEmpty
          ? const Center(child: Text('Giỏ hàng trống'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        leading: Image.network(item.product.imageUrl, width: 50, errorBuilder: (_,__,___) => const Icon(Icons.image)),
                        title: Text(item.product.name),
                        subtitle: Text(
                          '${currencyFormat.format(item.product.price)} x ${item.quantity}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              cart.removeItem(userId, index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tổng cộng:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            currencyFormat.format(cart.getTotalAmount(userId)),
                            style: const TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CheckoutScreen(user: widget.user!)),
                            ).then((_) => setState(() {}));
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                          child: const Text('TIẾN HÀNH THANH TOÁN'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
