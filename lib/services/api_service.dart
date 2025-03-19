import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class ApiService {
  final String baseUrl = "https://jsonplaceholder.typicode.com"; // Replace with your API URL

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/posts"));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((post) => Post.fromJson(post)).toList();
      } else {
        throw Exception("Failed to load posts");
      }
    } catch (e) {
      throw Exception("Error fetching posts: $e");
    }
  }
}
