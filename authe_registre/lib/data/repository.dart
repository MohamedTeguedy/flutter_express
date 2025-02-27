import 'dart:convert';

import 'package:authe_registre/data/api_service.dart';

class Repository {
  final ApiService? apiService;
  Repository({
    required this.apiService,
  });

  //Login
  Future<dynamic> login(String username, String password) async {
    final login = await apiService!.login(username, password);
    return login;
  }

  //Register
  Future<dynamic> register(String username, String password) async {
    final response = await apiService!.register(username, password);
    return response;
  }

  Future<Map<String, dynamic>?> createNote(
      String title, String description) async {
    try {
      final response = await apiService?.createNote(title, description);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateNote(
      String noteId, String title, String description) async {
    try {
      final response = await apiService?.updateNote(noteId, title, description);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Future<Map<String, dynamic>?> getNotes() async {
  //   try {
  //     final response = await apiService?.getProtectedData();
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  // Future<List<Map<String, dynamic>>> getNotes() async {
  //   final response = await apiService?.getProtectedData();
  //   return List<Map<String, dynamic>>.from(response as List);
  // }

  // Future<List<dynamic>> getNotes() async {
  //   final response = await apiService!.getNotes();
  //   if (response.statusCode == 200) {
  //     final responseData = json.decode(response.body);
  //     print(responseData);
  //     return List<dynamic>.from(responseData);
  //   } else {
  //     throw Exception('Failed to load notes');
  //   }
  // }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final response = await apiService!.getNotes();
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Si les notes sont encapsulées dans un objet JSON avec une clé "notes"
      if (data is Map<String, dynamic> && data.containsKey('notes')) {
        return List<Map<String, dynamic>>.from(data['notes']);
      }
      // Si les notes sont directement une liste
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Échec du chargement des notes');
    }
  }

  Future<void> clearToken() async {
    await apiService!.logout();
  }

  Future<void> deleteNote(String noteId) async {
    await apiService?.deleteNotes(noteId);
  }
}
