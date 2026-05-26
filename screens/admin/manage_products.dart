import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/api_service.dart';

class ManageProducts extends StatefulWidget {
  const ManageProducts({super.key});

  @override
  State<ManageProducts> createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  final ApiService _apiService = ApiService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _refreshProducts();
  }

  void _refreshProducts() {
    setState(() {
      _productsFuture = _apiService.getProducts();
    });
  }

  void _deleteProduct(int id) async {
    final response = await _apiService.deleteProduct(id);
    if (response['status'] == 'success') {
      _refreshProducts();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa sản phẩm')));
    }
  }

  void _showProductDialog({Product? product}) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(text: product?.price.toString() ?? '');
    final stockController = TextEditingController(text: product?.stockQuantity.toString() ?? '0'); // Thêm controller cho số lượng
    final descController = TextEditingController(text: product?.description ?? '');
    final imageController = TextEditingController(text: product?.imageUrl ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product == null ? 'Thêm Sản phẩm' : 'Sửa Sản phẩm'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Tên sản phẩm')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Giá'), keyboardType: TextInputType.number),
              TextField(controller: stockController, decoration: const InputDecoration(labelText: 'Số lượng kho'), keyboardType: TextInputType.number), // Ô nhập số lượng
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Mô tả')),
              TextField(controller: imageController, decoration: const InputDecoration(labelText: 'Link ảnh')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              Map<String, dynamic> data = {
                'name': nameController.text,
                'price': priceController.text,
                'stock_quantity': stockController.text, // Gửi số lượng lên server
                'description': descController.text,
                'image_url': imageController.text,
                'category_id': 1, // Mặc định loại 1
              };
              if (product != null) data['id'] = product.id;

              final res = await _apiService.saveProduct(data, isEdit: product != null);
              if (res['status'] == 'success') {
                _refreshProducts();
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý Sản phẩm'), backgroundColor: Colors.orange),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final p = snapshot.data![index];
              return ListTile(
                leading: Image.network(p.imageUrl, width: 50, errorBuilder: (_, __, ___) => const Icon(Icons.image)),
                title: Text(p.name),
                subtitle: Text('Giá: ${p.price} ₫ - Kho: ${p.stockQuantity}'), // Hiển thị số lượng ở đây
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showProductDialog(product: p)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteProduct(p.id)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
