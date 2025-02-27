import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.107:3000/api/auth';
  static String? _token; // Variable pour stocker le token en mémoire
  static final FlutterSecureStorage _storage =
      FlutterSecureStorage(); // Instance de FlutterSecureStorage

  // Méthode pour stocker le token dans FlutterSecureStorage
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
    _token = token; // Mettre à jour le token en mémoire
  }

  // Méthode pour récupérer le token depuis FlutterSecureStorage
  static Future<void> loadToken() async {
    _token =
        await _storage.read(key: 'auth_token'); // Charger le token en mémoire
  }

  // Méthode pour supprimer le token (déconnexion)
  static Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token'); // Supprimer le token
    _token = null; // Effacer le token en mémoire
  }

  // Fonction pour l'inscription
  Future<http.Response> register(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 201) {
        // return json.decode(response.body);
        return response;
      } else {
        throw Exception('Failed to registre: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during loregistre: $e');
      return http.Response('Error during registration: $e', 400);
    }
  }

  // Fonction pour la connexion
  Future<http.Response> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        // Succès
        final responseDtat = json.decode(response.body);
        final token = responseDtat['token'];
        await saveToken(token);
        print('token sauvegardé:$token'); // Sauvegarder le token
        return response;
      } else {
        // Gérer les erreurs spécifiques (401, 500, etc.)
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Failed to login: $e');
    }
  }

  // Fonction pour les requêtes authentifiées
  Future<Map<String, dynamic>> getProtectedData() async {
    await loadToken(); // Charger le token depuis FlutterSecureStorage

    if (_token == null) {
      throw Exception('No token available');
    }

    final response = await http.get(
      Uri.parse(
          'http://192.168.1.107:3000/api/notes'), // Exemple d'endpoint protégé
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token', // Ajouter le token dans les en-têtes
      },
    );
    print("response status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load protected data');
    }
  }

//Fonction pour créer une note

  Future<Map<String, dynamic>> createNote(
      String title, String description) async {
    await loadToken(); // Assure-toi que le token est chargé

    if (_token == null) {
      throw Exception(
          'Aucun token disponible. L\'utilisateur est peut-être déconnecté.');
    }

    print("Token récupéré: $_token");

    final url = Uri.parse('http://192.168.1.107:3000/api/notes');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token', // Utilisation du token chargé
      },
      body: jsonEncode({
        'title': title,
        'description': description,
      }),
    );
    print("Réponse status code: ${response.statusCode}");
    print("Réponse body: ${response.body}");

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Échec de la création de la note: ${response.statusCode} - ${response.body}');
    }
  }

// //Logout
  Future<void> logout() async {
    await clearToken();
  }

// //Fonction pour récupérer les notes
  Future<http.Response> getNotes() async {
    final token = await _storage.read(key: 'auth_token');

    if (token == null) {
      print("❌ Aucun token trouvé. L'utilisateur doit se reconnecter.");
      throw Exception("Aucun token disponible.");
    }

    final url = Uri.parse('http://192.168.1.107:3000/api/notes');

    print("📡 Envoi de la requête GET à $url avec le token: $token");

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print("🔍 Réponse du serveur:");
    print("➡️ Statut HTTP: ${response.statusCode}");
    print("➡️ Corps: ${response.body}");

    return response;
  }

// //Fonction pour supprimer une note
  Future<void> deleteNotes(String id) async {
    final token = await _storage.read(key: 'auth_token');

    if (token == null) {
      print("❌ Aucun token trouvé. L'utilisateur doit se reconnecter.");
      throw Exception("Aucun token disponible.");
    }
    final url = Uri.parse('http://192.168.1.107:3000/api/notes/$id');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print("🔍 Réponse du serveur:");
    print("➡️ Statut HTTP: ${response.statusCode}");
  }

  // //Mettre à jour une note
  Future<Map<String, dynamic>> updateNote(
      String noteId, String title, String description) async {
    final token = await _storage.read(key: 'auth_token');
    final response = await http.put(
      Uri.parse('http://192.168.1.107:3000/api/notes/$noteId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Retourne la note mise à jour
    } else {
      throw Exception('Échec de la mise à jour de la note');
    }
  }
}
