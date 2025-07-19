import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/postmodel.dart';
import '../models/usermodel.dart';

class ApiService {
  static const _usersUrl = 'https://jsonplaceholder.typicode.com/users';
  static const _postsUrl = 'https://jsonplaceholder.typicode.com/posts';

  static Future<List<User>> fetchUsers() async {
    try {
      final res = await http.get(Uri.parse(_usersUrl));
      if (res.statusCode != 200) {
        throw Exception('Users fetch failed (${res.statusCode})');
      }

      final List<dynamic> list = jsonDecode(res.body);
      return list.map((e) => User.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching users: $e');
      throw Exception('Users fetch failed');
    }
  }

  static Future<List<Post>> fetchPostsByUser(int userId) async {
    try {
      final res = await http.get(Uri.parse('$_postsUrl?userId=$userId'));
      if (res.statusCode != 200) {
        throw Exception('Posts fetch failed (${res.statusCode})');
      }

      final List<dynamic> list = jsonDecode(res.body);
      return list.map((e) => Post.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching posts: $e');
      throw Exception('Posts fetch failed');
    }
  }
}
