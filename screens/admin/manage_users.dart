import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  final ApiService _apiService = ApiService();

  void _deleteUser(int id) async {
    final response = await _apiService.deleteUser(id);
    if (response['status'] == 'success') {
      setState(() {});
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa người dùng')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý Người dùng'), backgroundColor: Colors.blue),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _apiService.getUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final u = snapshot.data![index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(u['full_name'] ?? u['username']),
                subtitle: Text(u['role'] == '1' ? 'ADMIN' : 'USER'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteUser(int.parse(u['id'])),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
