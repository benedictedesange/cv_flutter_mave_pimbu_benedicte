import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/family_member.dart';

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static String get baseUrl {
    const configuredUrl = String.fromEnvironment('API_BASE_URL');
    if (configuredUrl.isNotEmpty) return configuredUrl;
    if (kIsWeb) return 'http://localhost:8080/api-test/public';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8080/api-test/public';
      default:
        return 'http://localhost:8080/api-test/public';
    }
  }

  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/login'),
        headers: _jsonHeaders,
        body: jsonEncode({'email': email, 'password': password}),
      );
      return _decode(response);
    } on http.ClientException catch (_) {
      throw const ApiException(
        'API inaccessible. Vérifiez que XAMPP tourne, que le port 8080 est ouvert '
        'et que l’API autorise les requêtes Web (CORS).',
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('Connexion à l’API impossible.');
    }
  }

  Future<List<FamilyMember>> getFamilyMembers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/famille-membres'),
      headers: const {'Accept': 'application/json'},
    );
    final decoded = _decode(response);
    final data = decoded['data'];
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((item) => FamilyMember.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<FamilyMember> createFamilyMember({
    required FamilyMember member,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/famille-membres'),
      headers: _jsonHeaders,
      body: jsonEncode(member.toJson()),
    );
    final decoded = _decode(response);
    return FamilyMember.fromJson(
      Map<String, dynamic>.from(decoded['data'] as Map),
    );
  }

  Future<FamilyMember> createFamilyMemberWithImage({
    required FamilyMember member,
    required Uint8List bytes,
    required String fileName,
  }) async {
    final response = await _sendMultipart(
      method: 'POST',
      url: '$baseUrl/famille-membres',
      member: member,
      bytes: bytes,
      fileName: fileName,
    );
    final decoded = _decode(response);
    return FamilyMember.fromJson(
      Map<String, dynamic>.from(decoded['data'] as Map),
    );
  }

  Future<FamilyMember> updateFamilyMember(FamilyMember member) async {
    final response = await http.put(
      Uri.parse('$baseUrl/famille-membres/${member.id}'),
      headers: _jsonHeaders,
      body: jsonEncode(member.toJson()),
    );
    final decoded = _decode(response);
    return FamilyMember.fromJson(
      Map<String, dynamic>.from(decoded['data'] as Map),
    );
  }

  Future<FamilyMember> updateFamilyMemberWithImage({
    required FamilyMember member,
    required Uint8List bytes,
    required String fileName,
  }) async {
    final response = await _sendMultipart(
      method: 'POST',
      url: '$baseUrl/famille-membres/${member.id}',
      member: member,
      bytes: bytes,
      fileName: fileName,
    );
    final decoded = _decode(response);
    return FamilyMember.fromJson(
      Map<String, dynamic>.from(decoded['data'] as Map),
    );
  }

  Future<void> deleteFamilyMember(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/famille-membres/$id'),
      headers: const {'Accept': 'application/json'},
    );
    _decode(response);
  }

  Future<http.Response> _sendMultipart({
    required String method,
    required String url,
    required FamilyMember member,
    required Uint8List bytes,
    required String fileName,
  }) async {
    final request = http.MultipartRequest(method, Uri.parse(url));
    member.toJson().forEach((key, value) {
      request.fields[key] = value.toString();
    });
    request.files.add(
      http.MultipartFile.fromBytes('image', bytes, filename: fileName),
    );
    final streamed = await request.send();
    return http.Response.fromStream(streamed);
  }

  Map<String, dynamic> _decode(http.Response response) {
    Map<String, dynamic> body;
    try {
      body = Map<String, dynamic>.from(jsonDecode(response.body) as Map);
    } catch (_) {
      throw ApiException(
        'Impossible de joindre l’API (code ${response.statusCode}).',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = body['message']?.toString();
      final errors = body['errors'];
      if (errors is Map && errors.isNotEmpty) {
        throw ApiException(errors.values.first.toString());
      }
      throw ApiException(message ?? 'Erreur API (${response.statusCode}).');
    }
    return body;
  }
}
