import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/cart_item.dart';
import '../services/api_service.dart';
import 'admin/admin_dashboard.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'login_screen.dart';
import 'order_history_screen.dart';
import 'profile_screen.dart';
import 'chat_ai_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final User? user;
  const HomeScreen({super.key, this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  
  String _searchQuery = "";
  int? _selectedCategoryId;
  Timer? _timer;
  int _currentBannerPage = 0;
  final PageController _bannerController = PageController();
  int _selectedIndex = 0; // Index cho Bottom Navigation

  final List<Map<String, dynamic>> _categories = [
    {'id': null, 'name': 'Tất cả', 'icon': Icons.grid_view},
    {'id': 1, 'name': 'Điện tử', 'icon': Icons.phone_android},
    {'id': 2, 'name': 'Thời trang', 'icon': Icons.checkroom},
    {'id': 3, 'name': 'Phụ kiện', 'icon': Icons.watch},
    {'id': 4, 'name': 'Giày dép', 'icon': Icons.ice_skating},
  ];

  final List<String> _banners = [
    'https://img.freepik.com/free-vector/horizontal-sale-banner-template_23-2148897328.jpg',
    'https://img.freepik.com/free-vector/fashion-sale-social-media-post-template_23-2148102377.jpg',
    'https://img.freepik.com/free-vector/flat-design-electronics-store-facebook-cover_23-2149241193.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _startBannerTimer();
  }

  void _startBannerTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentBannerPage < _banners.length - 1) {
        _currentBannerPage++;
      } else {
        _currentBannerPage = 0;
      }
      if (_bannerController.hasClients) {
        _bannerController.animateToPage(_currentBannerPage, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  // Hàm hiển thị Menu Tài khoản khi nhấn vào Tab Tài khoản
  void _showAccountMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50, height: 5,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                ),
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.deepPurple, child: Icon(Icons.person, color: Colors.white)),
                  title: const Text('Quản lý tài khoản', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Cập nhật địa chỉ, số điện thoại...'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(user: widget.user!)));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.redAccent, child: Icon(Icons.logout, color: Colors.white)),
                  title: const Text('Đăng xuất', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Điều hướng khi nhấn Bottom Bar
  void _onItemTapped(int index) {
    if (index == 0) {
      setState(() => _selectedIndex = index);
    } else if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => OrderHistoryScreen(user: widget.user!)));
    } else if (index == 2) {
      _showAccountMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chào mừng bạn,', style: TextStyle(fontSize: 12, color: Colors.white70)),
            Text(widget.user?.fullName ?? 'Khách hàng', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          if (widget.user?.role == 1)
            IconButton(icon: const Icon(Icons.admin_panel_settings_outlined), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminDashboard()))),
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none_outlined, size: 28),
                Positioned(right: 0, top: 0, child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: const Text('2', style: TextStyle(fontSize: 8)))),
              ],
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: CustomScrollView(
          slivers: [
            // 1. Tìm kiếm (Ghim trên cùng khi cuộn nếu thích, ở đây để mặc định)
            SliverToBoxAdapter(
              child: Container(
                color: Colors.deepPurple,
                padding: const EdgeInsets.all(15),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm sản phẩm bạn yêu thích...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                ),
              ),
            ),
            
            // 2. Banner
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                height: 160,
                child: PageView.builder(
                  controller: _bannerController,
                  itemCount: _banners.length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(image: NetworkImage(_banners[index]), fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),

            // 3. Danh mục Icon
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  height: 95,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      bool isSelected = _selectedCategoryId == cat['id'];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategoryId = cat['id']),
                        child: Container(
                          width: 75,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: isSelected ? Colors.deepPurple : Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)]),
                                child: Icon(cat['icon'], color: isSelected ? Colors.white : Colors.deepPurple, size: 26),
                              ),
                              const SizedBox(height: 8),
                              Text(cat['name'], style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal), textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // 4. Tiêu đề mục "Gợi ý cho bạn"
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Sản phẩm dành cho bạn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () {}, child: const Text('Xem tất cả')),
                  ],
                ),
              ),
            ),

            // 5. Lưới sản phẩm
            FutureBuilder<List<Product>>(
              future: apiService.getProducts(categoryId: _selectedCategoryId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
                List<Product> products = snapshot.data!.where((p) => p.name.toLowerCase().contains(_searchQuery)).toList();
                
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ProductCard(product: products[index], currencyFormat: currencyFormat, user: widget.user),
                      childCount: products.length,
                    ),
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
      // Cụm nút nổi: Chat AI và Giỏ hàng
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'chat_ai',
            backgroundColor: Colors.deepPurple,
            elevation: 4,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatAIScreen())),
            child: const Icon(Icons.forum_outlined, color: Colors.white, size: 28), // Icon hội thoại chuyên nghiệp
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'cart',
            backgroundColor: Colors.orangeAccent,
            elevation: 4,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(user: widget.user))),
            child: const Icon(Icons.shopping_cart, color: Colors.white, size: 28),
          ),
        ],
      ),
      // 6. Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Đơn hàng'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Tài khoản'),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final NumberFormat currencyFormat;
  final User? user; // Thêm user vào đây
  const ProductCard({super.key, required this.product, required this.currencyFormat, this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product, user: user))),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.withOpacity(0.1))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Hero(tag: 'product-${product.id}', child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), child: Image.network(product.imageUrl, fit: BoxFit.cover, width: double.infinity))),
                  Positioned(right: 8, top: 8, child: Icon(Icons.favorite_border, color: Colors.grey[400], size: 20)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Text(currencyFormat.format(product.price), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
