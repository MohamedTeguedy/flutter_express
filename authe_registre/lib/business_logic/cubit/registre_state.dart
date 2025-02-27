part of 'registre_cubit.dart';

@immutable
abstract class RegistreState {}

class RegistreInitial extends RegistreState {}

class RegistreLoading extends RegistreState {}

class RegistreSuccess extends RegistreState {
  final String message;
  RegistreSuccess(this.message);
}

class RegistreFailed extends RegistreState {
  final String message;
  RegistreFailed(this.message);
  List<Object> get props => [message];
}
