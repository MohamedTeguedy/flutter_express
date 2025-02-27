// part of 'auth_cubit.dart';

// // @immutable
// // abstract class AuthState {}

// // class AuthInitial extends AuthState {}

// // class AuthLoading extends AuthState {}

// // class AuthSuccess extends AuthState {
// //   final String message;
// //   AuthSuccess(this.message);
// // }

// // class AuthFailed extends AuthState {
// //   final String message;
// //   AuthFailed(this.message);
// // }
// // auth_state.dart

// abstract class AuthState extends Equatable {
//   const AuthState();

//   @override
//   List<Object> get props => [];
// }

// class AuthInitial extends AuthState {}

// class AuthLoading extends AuthState {}

// class AuthSuccess extends AuthState {
//   final String message;
//   final List<dynamic> notes;

//   const AuthSuccess(this.message, {this.notes = const []});

//   @override
//   List<Object> get props => [message, notes];
// }

// class AuthFailed extends AuthState {
//   final String message;

//   const AuthFailed(this.message);

//   @override
//   List<Object> get props => [message];
// }
part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  final List<dynamic> notes;

  const AuthSuccess(this.message, {required this.notes});

  @override
  List<Object> get props => [message, notes];
}

class AuthFailed extends AuthState {
  final String message;

  const AuthFailed(this.message);

  @override
  List<Object> get props => [message];
}
