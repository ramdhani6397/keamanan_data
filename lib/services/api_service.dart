import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/post.dart';

import 'package:flutter/foundation.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  static const Duration defaultTimeout = Duration(seconds: 10);

  // GET /users
  Future<List<User>> getUsers({Duration timeout = defaultTimeout}) async {
    try {
      debugPrint('Request GET: $_baseUrl/users');

      final response = await http
          .get(Uri.parse('$_baseUrl/users'))
          .timeout(timeout);

      debugPrint('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      }

      throw HttpException('Gagal memuat data. Status: ${response.statusCode}');
    } on TimeoutException {
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      throw Exception('Format data tidak valid.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // GET /users/{id}
  Future<User> getUserById(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/users/$id'))
          .timeout(defaultTimeout);

      debugPrint('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return User.fromJson(data);
      }

      throw HttpException('Gagal memuat data. Status: ${response.statusCode}');
    } on TimeoutException {
      throw Exception('Request timeout.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Simulasi login
  Future<String> login(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (email.trim().isNotEmpty && password.isNotEmpty) {
        final token = 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';

        debugPrint('Login berhasil untuk email: $email');
        return token;
      }

      throw Exception('Email dan password tidak boleh kosong');
    } catch (e) {
      throw Exception('Login gagal: $e');
    }
  }

  // GET /posts
  Future<List<Post>> getPosts() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/posts'))
          .timeout(defaultTimeout);

      debugPrint('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      }

      throw HttpException('Gagal memuat posts. Status: ${response.statusCode}');
    } on TimeoutException {
      throw Exception('Request timeout.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    } on FormatException {
      throw Exception('Format data tidak valid.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() => message;
}
