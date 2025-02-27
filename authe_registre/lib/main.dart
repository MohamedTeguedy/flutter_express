import 'package:authe_registre/business_logic/cubit/add_note_cubit.dart';
import 'package:authe_registre/data/api_service.dart';
import 'package:authe_registre/data/repository.dart';
import 'package:authe_registre/presentations/screens/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business_logic/cubit/auth_cubit.dart';
import 'business_logic/cubit/registre_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ApiService apiService =
        ApiService(); // Assuming ApiService is defined somewhere
    final Repository repository = Repository(apiService: apiService);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(repository),
        ),
        BlocProvider(
          create: (context) => RegistreCubit(repository),
        ),
        BlocProvider(
          create: (context) => AddNoteCubit(repository),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(32, 63, 129, 1.0),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const Login(),
      ),
    );
  }
}
