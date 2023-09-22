import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:login/services/user_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String? baseUrl = dotenv.get('BASE_URL', fallback: 'BASE_URL not found');
// String token = '';
final FlutterSecureStorage storage = const FlutterSecureStorage();

Future<void> storeToken(String token) async {
  // print('token in storeToken $token');
  await storage.write(key: "jwtToken", value: token);
}

Future<String?> getToken() async {
  return await storage.read(key: "jwtToken");
}

Future<void> deleteToken() async {
  await storage.delete(key: "jwtToken");
}

//-----------------LOGIN USER-----------------//

Future<Map<String, dynamic>> loginUser(
    BuildContext context, String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/mylogin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'email': email,
          'password': password,
        },
      ),
    );

    if (response.statusCode == 200) {
      String? cookieString = response.headers['set-cookie'];
      if (cookieString != null) {
        List<String> cookies = cookieString.split(';');

        String? jwtCookie;
        for (String cookie in cookies) {
          if (cookie.trim().startsWith('jwt=')) {
            jwtCookie = cookie;
            break;
          }
        }

        if (jwtCookie != null) {
          String jwtToken = jwtCookie.split('=')[1];
          jwtToken = jwtToken.trim();

          await storeToken(jwtToken);
          // print('JWT Token: $jwtToken');
          // print('token in login $token');
        } else {
          print('JWT Cookie not found');
        }
      } else {
        print('No set-cookie header in the response');
      }

      final data = jsonDecode(response.body);
      data['statusCode'] = response.statusCode;
      String token = await getToken() ?? '';
      print('data in login $data');
      Provider.of<UserData>(context, listen: false)
          .setUser(data['user'], token);

      // getUser(data['user']);
      return data;
    } else
      print('response.body>>400 ${response.body}');
    final dataerror = jsonDecode(response.body);

    final data = {
      'statusCode': response.statusCode,
      'email': dataerror['email'] ?? '',
      'password': dataerror['password'] ?? '',
    };
    print('data after adding statusCode $data');
    return data;
  } catch (e) {
    print('Failed to fetch data in Login. Status code: $e');
    return {};
  }
}

//-----------------GET ALL USERS-----------------//

Future getAllUsers() async {
  print('calling getAllUsers');
  String token = await getToken() ?? '';
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/myusers'),
      // Uri.parse('somesite'),

      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print('Getting All Users! $data');
      return data;
    } else {
      print(
          'Failed to fetch data in GetAll. Status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Failed to fetch data in GetAll. Status code: $e');
    return [];
  }
}

//-----------------CREATE USER-----------------//

Future createUser(email, password, empNum, branchId) async {
  print('calling createUser');
  Map<String, dynamic> user = {
    'email': email,
    'password': password,
    'empNum': empNum,
    'branch_id': branchId,
  };

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/mysignup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      data['statusCode'] = response.statusCode;
      return data;
    } else if (response.statusCode == 400) {
      final dataerror = jsonDecode(response.body);

      final data = {
        'statusCode': response.statusCode,
        'email': dataerror['email'] ?? '',
        'password': dataerror['password'] ?? '',
      };

      return data;
    } else if (response.statusCode == 500) {
      print('response.body>>500 ${response.body}');
      final dataerror = jsonDecode(response.body);

      final data = {
        'statusCode': response.statusCode,
        'email': dataerror['email'] ?? '',
        'password': dataerror['password'] ?? '',
      };

      return data;
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Failed to fetch data. Status code: $e');
    return [];
  }
}

//-----------------LOGOUT USER-----------------//

Future logoutUser() async {
  String token = await getToken() ?? '';

  try {
    final response = await http.get(
      Uri.parse('$baseUrl/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = response.body;
      return data;
    } else {
      print(
          'Failed to fetch data in Logout. Status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Failed to fetch data in Logout. Status code: $e');
    return [];
  }
}

//-----------------ADD PERMISSIONS-----------------//

Future addPermissions(permissions) async {
  String token = await getToken() ?? '';

  print('calling addPermissions $permissions');

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/permissions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(permissions),
    );
    if (response.statusCode == 200) {
      final data = {
        'statusCode': response.statusCode,
        'message': response.body
      };
      print('Adding Permissions! $data');
      return data;
    } else {
      return [];
    }
  } catch (e) {
    print('Failed to fetch data in addPermissions. Status code: $e');
    return [];
  }
}

Future getUserPermissions(data) async {
  print('calling getPermissionData $data');

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/getpermissions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    print('response.body getPermissions!!! ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print('Getting Permissions! $data');
      data['statusCode'] = response.statusCode;
      return data;
    } else {
      print('response.body}}}}} ${response.body}');

      final dataerror = {'email': response.body};

      final data = {
        'statusCode': response.statusCode,
        'email': dataerror['email'] ?? '',
      };

      print(
          'Failed to fetch data in getPermissionData. Status code: ${response.statusCode}');
      return data;
    }
  } catch (e) {
    return [];
  }
}

Future removebranchId(data) async {
  print('calling removebranchId $data');
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/removebranchid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    
    if (response.statusCode == 200) {
      final data = {
        'statusCode': response.statusCode,
        'message': response.body
      };
      print('Removing branchId! $data');
      return data;
    } else {
      return [];
    }
  } catch (e) {
    print('Failed to fetch data in removebranchId. Status code: $e');
    return [];
  }
}
