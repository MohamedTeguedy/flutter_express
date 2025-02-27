import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:authe_registre/data/repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final Repository repository;

  AuthCubit(this.repository) : super(AuthInitial());

  void login(String username, String password) async {
    emit(AuthLoading());
    try {
      final response = await repository.login(username, password);
      if (response.statusCode == 200) {
        final responseData =
            json.decode(response.body); // Décoder la réponse JSON
        final notes = responseData['notes'] as List;

        emit(AuthSuccess('Connexion réussie',
            notes: notes.cast<Map<String, dynamic>>()));
        // Mettre à jour l'état avec les notes
      } else {
        emit(const AuthFailed('Échec de la connexion'));
      }
    } catch (e) {
      emit(AuthFailed('Erreur: $e'));
    }
  }

//Logout
  void logout() async {
    await repository.clearToken();
    emit(AuthInitial());
  }

//loadNotes
  void loadNotes() async {
    emit(AuthLoading()); // État de chargement
    try {
      final notes = await repository
          .getNotes(); // Récupérer les notes depuis le repository
      emit(AuthSuccess('Notes chargées',
          notes: notes)); // Mettre à jour l'état avec les nouvelles notes
    } catch (e) {
      emit(AuthFailed('Erreur lors du chargement des notes: $e'));
    }
  }

  //deleteNote
  void deleteNote(String id) async {
    emit(AuthLoading()); // État de chargement
    try {
      await repository.deleteNote(id); // Supprimer la note
      // Récupérer les notes
      loadNotes(); // Recharger les notes
    } catch (e) {
      emit(AuthFailed('Erreur lors de la suppression de la note: $e'));
    }
  }

  //updateNote
  void updateNote(String id, String title, String description) async {
    emit(AuthLoading()); // État de chargement
    try {
      await repository.updateNote(
          id, title, description); // Mettre à jour la note
      // Récupérer les notes
      loadNotes();
    } catch (e) {
      emit(AuthFailed('Erreur lors de la mise à jour de la note: $e'));
    }
  }
}
