import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ud_ban_hang_onl/services/api_service.dart';
import 'package:ud_ban_hang_onl/models/product.dart';
import 'package:excel/excel.dart';

// Tạo Mock cho http.Client
@GenerateMocks([http.Client])
import 'api_service_test.mocks.dart';

void main() {
  late ApiService apiService;
  late MockClient mockClient;
  
  // 1. Danh sách lưu trữ kết quả để xuất Excel
  final List<Map<String, dynamic>> testResults = [];

  setUp(() {
    mockClient = MockClient();
    apiService = ApiService(client: mockClient);
  });

  // Hàm hỗ trợ ghi log kết quả
  void logTest(String name, String input, String expected, String actual, bool isPass) {
    testResults.add({
      'name': name,
      'input': input,
      'expected': expected,
      'actual': actual,
      'status': isPass ? 'PASS' : 'FAIL'
    });
  }

  // Tiện ích tạo Response UTF-8 giả lập (Tránh lỗi tiếng Việt)
  http.Response mockJsonResponse(dynamic data, [int statusCode = 200]) {
    return http.Response.bytes(
      utf8.encode(json.encode(data)),
      statusCode,
      headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
    );
  }

  group('Kiểm thử TOÀN BỘ ApiService và Tự động xuất Excel', () {
    
    test('1. getProducts - Lấy danh sách sản phẩm', () async {
      final mockData = [{"id": "1", "category_id": "1", "name": "Sản phẩm Test", "price": "100000", "description": "Mô tả", "image_url": "test.png", "stock_quantity": "10", "is_popular": "1"}];
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => mockJsonResponse(mockData));
      try {
        final products = await apiService.getProducts();
        expect(products.length, 1);
        logTest('Lấy danh sách sản phẩm', 'N/A', 'Trả về danh sách SP', 'Thành công: ${products[0].name}', true);
      } catch (e) {
        logTest('Lấy danh sách sản phẩm', 'N/A', 'Trả về danh sách SP', 'Lỗi: $e', false); rethrow;
      }
    });

    test('2. login - Đăng nhập', () async {
      final mockRes = {'status': 'success', 'user': {'id': 1, 'username': 'admin'}};
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body'), encoding: anyNamed('encoding'))).thenAnswer((_) async => mockJsonResponse(mockRes));
      try {
        final result = await apiService.login('admin', '123');
        expect(result['status'], 'success');
        logTest('Đăng nhập', 'admin / 123', 'status: success', 'Thực tế: ${result['status']}', true);
      } catch (e) {
        logTest('Đăng nhập', 'admin / 123', 'status: success', 'Lỗi: $e', false); rethrow;
      }
    });

    test('3. register - Đăng ký tài khoản', () async {
      final mockRes = {'status': 'success', 'message': 'Thành công'};
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body'), encoding: anyNamed('encoding'))).thenAnswer((_) async => mockJsonResponse(mockRes));
      try {
        final res = await apiService.register(username: 'u', password: 'p', fullName: 'f', email: 'e', phone: '0', address: 'a');
        expect(res['status'], 'success');
        logTest('Đăng ký', 'User data', 'success', 'Thành công', true);
      } catch (e) {
        logTest('Đăng ký', 'User data', 'success', 'Lỗi: $e', false); rethrow;
      }
    });

    test('4. placeOrder - Đặt hàng', () async {
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body'), encoding: anyNamed('encoding'))).thenAnswer((_) async => mockJsonResponse({'status': 'success'}));
      try {
        final res = await apiService.placeOrder({'user_id': 1, 'items': []});
        expect(res['status'], 'success');
        logTest('Đặt hàng', 'Order JSON', 'success', 'Thành công', true);
      } catch (e) {
        logTest('Đặt hàng', 'Order JSON', 'success', 'Lỗi: $e', false); rethrow;
      }
    });

    test('5. saveProduct - Thêm/Sửa SP', () async {
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body'), encoding: anyNamed('encoding'))).thenAnswer((_) async => mockJsonResponse({'status': 'success'}));
      try {
        final res = await apiService.saveProduct({'name': 'Test'});
        expect(res['status'], 'success');
        logTest('Thêm/Sửa SP', 'Product Data', 'success', 'Thành công', true);
      } catch (e) {
        logTest('Thêm/Sửa SP', 'Product Data', 'success', 'Lỗi: $e', false); rethrow;
      }
    });

    test('6. deleteProduct - Xóa SP', () async {
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body'), encoding: anyNamed('encoding'))).thenAnswer((_) async => mockJsonResponse({'status': 'success'}));
      try {
        final res = await apiService.deleteProduct(1);
        expect(res['status'], 'success');
        logTest('Xóa SP', 'ID: 1', 'success', 'Thành công', true);
      } catch (e) {
        logTest('Xóa SP', 'ID: 1', 'success', 'Lỗi: $e', false); rethrow;
      }
    });

    test('7. getUsers - Lấy danh sách User', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => mockJsonResponse([{'id': 1, 'username': 'test'}]));
      try {
        final res = await apiService.getUsers();
        expect(res.isNotEmpty, true);
        logTest('Lấy danh sách User', 'N/A', 'List User', 'Lấy được ${res.length} user', true);
      } catch (e) {
        logTest('Lấy danh sách User', 'N/A', 'List User', 'Lỗi: $e', false); rethrow;
      }
    });

    test('8. getOrders - Lấy danh sách đơn hàng', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => mockJsonResponse([{'id': 1, 'status': 'pending'}]));
      try {
        final res = await apiService.getOrders();
        expect(res.isNotEmpty, true);
        logTest('Lấy danh sách ĐH', 'N/A', 'List Order', 'Thành công', true);
      } catch (e) {
        logTest('Lấy danh sách ĐH', 'N/A', 'List Order', 'Lỗi: $e', false); rethrow;
      }
    });

    test('9. updateOrderStatus - Cập nhật trạng thái', () async {
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body'), encoding: anyNamed('encoding'))).thenAnswer((_) async => mockJsonResponse({'status': 'success'}));
      try {
        final res = await apiService.updateOrderStatus(1, 'shipped');
        expect(res['status'], 'success');
        logTest('Cập nhật trạng thái ĐH', 'ID 1: shipped', 'success', 'Thành công', true);
      } catch (e) {
        logTest('Cập nhật trạng thái ĐH', 'ID 1: shipped', 'success', 'Lỗi: $e', false); rethrow;
      }
    });

    test('10. getAdminStats - Thống kê doanh thu', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => mockJsonResponse({'total_revenue': 5000}));
      try {
        final res = await apiService.getAdminStats();
        expect(res.containsKey('total_revenue'), true);
        logTest('Thống kê doanh thu', 'N/A', 'Stats JSON', 'Revenue: ${res['total_revenue']}', true);
      } catch (e) {
        logTest('Thống kê doanh thu', 'N/A', 'Stats JSON', 'Lỗi: $e', false); rethrow;
      }
    });

    test('11. askAI - Trợ lý Gemini AI', () async {
      final mockAiRes = {'candidates': [{'content': {'parts': [{'text': 'Chào bạn'}]}}]};
      // Mock call products inside askAI
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => mockJsonResponse([]));
      // Mock call Gemini
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body'), encoding: anyNamed('encoding'))).thenAnswer((_) async => mockJsonResponse(mockAiRes));
      
      try {
        final res = await apiService.askAI('Hello');
        expect(res.isNotEmpty, true);
        logTest('Tư vấn AI', 'Prompt: Hello', 'Phản hồi từ AI', 'Thực tế: $res', true);
      } catch (e) {
        logTest('Tư vấn AI', 'Prompt: Hello', 'Phản hồi từ AI', 'Lỗi: $e', false); rethrow;
      }
    });

    // TỰ ĐỘNG XUẤT EXCEL KHI TẤT CẢ TEST XONG
    tearDownAll(() async {
      print('\n[HỆ THỐNG] Đang xuất báo cáo kiểm thử toàn diện ra Excel...');
      var excel = Excel.createExcel();
      var sheet = excel['API Full Report'];
      excel.delete('Sheet1');

      sheet.appendRow([
        TextCellValue('STT'), TextCellValue('Chức năng'), TextCellValue('Đầu vào'),
        TextCellValue('Kỳ vọng'), TextCellValue('Thực tế'), TextCellValue('Trạng thái')
      ]);

      for (var i = 0; i < testResults.length; i++) {
        var r = testResults[i];
        sheet.appendRow([
          IntCellValue(i + 1), TextCellValue(r['name']), TextCellValue(r['input']),
          TextCellValue(r['expected']), TextCellValue(r['actual']), TextCellValue(r['status'])
        ]);
      }

      var fileBytes = excel.encode();
      if (fileBytes != null) {
        final file = File('API_Comprehensive_Report.xlsx');
        file.writeAsBytesSync(fileBytes);
        print('--------------------------------------------------');
        print('BÁO CÁO TỔNG HỢP: ${file.absolute.path}');
        print('--------------------------------------------------');
      }
    });
  });
}
