import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repository.dart';

part 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  final Repository noteRepository;

  AddNoteCubit(this.noteRepository) : super(AddNoteInitial());

  void createNote(String title, String description) async {
    emit(NoteLoading());
    try {
      final newNote = await noteRepository.createNote(title, description);
      final notes = await noteRepository.getNotes();
      emit(NoteSuccess(newNote!));
    } catch (e) {
      emit(NoteFailure(e.toString()));
    }
  }
}
