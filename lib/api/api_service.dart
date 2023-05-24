import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://to-do.softwars.com.ua';

  static Future<Map<String, dynamic>> getTasks() async {
    final url = Uri.parse('$baseUrl/tasks');

    final response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return {'success': true, 'data': responseData['data']};
    } else {
      return {'success': false, 'errorMessage': response.statusCode};
    }
  }

  static Future<Map<String, dynamic>> createTask(String taskId, String name,
      int type, String description, String finishDate, int urgent) async {
    var requestBody = [
      {
        "taskId": taskId,
        "status": 1,
        "name": name,
        "type": type,
        "description": description,
        "finishDate": finishDate,
        "urgent": urgent,
      }
    ];

    final url = Uri.parse('$baseUrl/tasks');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return {'success': true};
    } else {
      return {'success': false, 'errorMessage': response.statusCode};
    }
  }

  static Future<Map<String, dynamic>> editTask(String taskId,int status, String name,
      int type, String description, String finishDate, int urgent) async {
    var requestBody = [
      {
        "taskId": taskId,
        "status": status,
        "name": name,
        "type": type,
        "description": description,
        "finishDate": finishDate,
        "urgent": urgent,
      }
    ];

    final url = Uri.parse('$baseUrl/tasks');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return {'success': true};
    } else {
      return {'success': false, 'errorMessage': response.statusCode};
    }
  }

  static Future<Map<String, dynamic>> editStatus(
      String taskId, int statusCode) async {
    final url = Uri.parse('$baseUrl/tasks/$taskId');
    

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': statusCode}),
    );

    if (response.statusCode == 200) {
      return ({'success': true});
    } else {
      return {'success': false, 'errorMessage': response.statusCode};
    }
  }

  

  static Future<Map<String, dynamic>> deleteTask(String taskId) async {
    final url = Uri.parse('$baseUrl/tasks/$taskId');

    final response = await http.delete(
      url,
    );

    if (response.statusCode == 200) {
      return ({'success': true});
    } else {
      return {'success': false, 'errorMessage': response.statusCode};
    }
  }
}
