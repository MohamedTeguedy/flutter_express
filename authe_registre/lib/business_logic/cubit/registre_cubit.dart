import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:authe_registre/data/repository.dart';

part 'registre_state.dart';

class RegistreCubit extends Cubit<RegistreState> {
  final Repository repository;

  RegistreCubit(
    this.repository,
  ) : super(RegistreInitial());

  void register(String username, String password) async {
    emit(RegistreLoading());
    final response = await repository.register(username, password);
    if (response.statusCode == 201) {
      emit(RegistreSuccess('registre réussie'));
    } else {
      print("registreeeeeee");
      print(response.body);
      emit(RegistreFailed('registre failed'));
    }
  }

  void resetState() {
    emit(RegistreInitial());
  }
}
