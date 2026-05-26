import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ud_ban_hang_onl/services/api_service.dart';

// Manual Mock for simplicity in this script
class MockClient extends Mock implements http.Client {
  @override
  Future<http.Response> get(Uri? url, {Map<String, String>? headers}) =>
      super.noSuchMethod(Invocation.method(#get, [url], {#headers: headers}),
          returnValue: Future.value(http.Response('', 200)));
  @override
  Future<http.Response> post(Uri? url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      super.noSuchMethod(Invocation.method(#post, [url], {#headers: headers, #body: body, #encoding: encoding}),
          returnValue: Future.value(http.Response('', 200)));
}

void main() async {
  print('Đang bắt đầu quá trình kiểm thử và xuất Excel...');
  
  final excel = Excel.createExcel();
  final Sheet sheet = excel['Kết quả kiểm thử API'];
  excel.delete('Sheet1'); // Xóa sheet mặc định

  // Tiêu đề cột
  sheet.appendRow([
    TextCellValue('STT'),
    TextCellValue('Tên chức năng'),
    TextCellValue('Dữ liệu đầu vào'),
    TextCellValue('Kết quả mong đợi'),
    TextCellValue('Kết quả thực tế'),
    TextCellValue('Trạng thái'),
  ]);

  final mockClient = MockClient();
  final apiService = ApiService(client: mockClient);

  List<Map<String, dynamic>> results = [];

  // --- TEST CASE 1: Lấy sản phẩm ---
  try {
    final mockData = [
      {"id": "1", "category_id": "1", "name": "Laptop Dell", "price": "15000000", "description": "Làm việc", "image_url": "dell.jpg", "stock_quantity": "5", "is_popular": "1"}
    ];
    when(mockClient.get(any)).thenAnswer((_) async => http.Response(json.encode(mockData), 200));
    
    final products = await apiService.getProducts();
    bool isPass = products.isNotEmpty && products[0].name == 'Laptop Dell';
    results.add({
      'name': 'Lấy danh sách sản phẩm',
      'input': 'Không có',
      'expected': 'Trả về danh sách có "Laptop Dell"',
      'actual': isPass ? 'Thành công: Lấy được ${products.length} SP' : 'Thất bại',
      'status': isPass ? 'PASS' : 'FAIL'
    });
  } catch (e) {
    results.add({'name': 'Lấy danh sách sản phẩm', 'input': 'N/A', 'expected': 'Success', 'actual': 'Lỗi: $e', 'status': 'FAIL'});
  }

  // --- TEST CASE 2: Đăng nhập ---
  try {
    final loginResponse = {'status': 'success', 'message': 'Đăng nhập thành công'};
    when(mockClient.post(any, body: anyNamed('body'))).thenAnswer((_) async => http.Response(json.encode(loginResponse), 200));

    final res = await apiService.login('admin', '123456');
    bool isPass = res['status'] == 'success';
    results.add({
      'name': 'Đăng nhập hệ thống',
      'input': 'user: admin, pass: 123456',
      'expected': 'status: success',
      'actual': 'status: ${res['status']}',
      'status': isPass ? 'PASS' : 'FAIL'
    });
  } catch (e) {
    results.add({'name': 'Đăng nhập', 'input': 'admin/123456', 'expected': 'Success', 'actual': 'Lỗi: $e', 'status': 'FAIL'});
  }

  // Ghi dữ liệu vào Excel
  for (var i = 0; i < results.length; i++) {
    final r = results[i];
    sheet.appendRow([
      IntCellValue(i + 1),
      TextCellValue(r['name']),
      TextCellValue(r['input']),
      TextCellValue(r['expected']),
      TextCellValue(r['actual']),
      TextCellValue(r['status']),
    ]);
  }

  // Lưu file
  final fileBytes = excel.encode();
  if (fileBytes != null) {
    File('API_Test_Report.xlsx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);
    print('-----------------------------------------');
    print('XUẤT FILE THÀNH CÔNG: API_Test_Report.xlsx');
    print('Vị trí: ${Directory.current.path}\\API_Test_Report.xlsx');
    print('-----------------------------------------');
  }
}
