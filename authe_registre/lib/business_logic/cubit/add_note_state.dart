part of 'add_note_cubit.dart';

abstract class AddNoteState extends Equatable {
  const AddNoteState();

  @override
  List<Object> get props => [];
}

class AddNoteInitial extends AddNoteState {}

class NoteLoading extends AddNoteState {}

class NoteSuccess extends AddNoteState {
  final Map<String, dynamic> note;

  NoteSuccess(this.note);
}

class NoteFailure extends AddNoteState {
  final String error;

  NoteFailure(this.error);
}

class AddNoteLoaded extends AddNoteState {
  final List<Map<String, dynamic>> notes;

  AddNoteLoaded(this.notes);
}
