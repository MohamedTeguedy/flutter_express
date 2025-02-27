import 'package:authe_registre/presentations/screens/HomePage/home.dart';
import 'package:authe_registre/presentations/screens/Registre/registre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authe_registre/business_logic/cubit/auth_cubit.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const Home(), // Rediriger vers l'écran d'accueil
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  const SizedBox(height: 150),
                  Text(
                    "Welcome back",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Login to your account",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 60),
                  TextFormField(
                    controller: _controllerUsername,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onEditingComplete: () => _focusNodePassword.requestFocus(),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter username.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _controllerPassword,
                    focusNode: _focusNodePassword,
                    obscureText: _obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.password_outlined),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: _obscurePassword
                            ? const Icon(Icons.visibility_outlined)
                            : const Icon(Icons.visibility_off_outlined),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter password.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 60),
                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final username = _controllerUsername.text;
                            final password = _controllerPassword.text;
                            context.read<AuthCubit>().login(username, password);
                          }
                        },
                        child: const Text("Login"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              _formKey.currentState?.reset();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Signup(),
                                ),
                              );
                            },
                            child: const Text("Signup"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}































// import 'package:authe_registre/business_logic/cubit/auth_cubit.dart';
// import 'package:authe_registre/business_logic/cubit/registre_cubit.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';

// class LoginScreen extends StatelessWidget {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: BlocConsumer<AuthCubit, AuthState>(
//         listener: (context, state) {
//           if (state is AuthFailed) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is AuthSuccess) {
//             return Center(child: const Text('Login success'));
//           }
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _usernameController,
//                   decoration: InputDecoration(labelText: 'Username'),
//                 ),
//                 TextField(
//                   controller: _passwordController,
//                   decoration: InputDecoration(labelText: 'Password'),
//                   obscureText: true,
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     final username = _usernameController.text;
//                     final password = _passwordController.text;
//                     context.read<AuthCubit>().login(username, password);
//                   },
//                   child: const Text('Login'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     final username = _usernameController.text;
//                     final password = _passwordController.text;
//                     context.read<RegistreCubit>().register(username, password);
//                   },
//                   child: Text('Register'),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// login_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:authe_registre/business_logic/cubit/auth_cubit.dart';

// class LoginScreen extends StatelessWidget {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Connexion')),
//       body: BlocConsumer<AuthCubit, AuthState>(
//         listener: (context, state) {
//           if (state is AuthFailed) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is AuthLoading) {
//             return Center(child: CircularProgressIndicator());
//           }
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _usernameController,
//                   decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
//                 ),
//                 TextField(
//                   controller: _passwordController,
//                   decoration: InputDecoration(labelText: 'Mot de passe'),
//                   obscureText: true,
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     final username = _usernameController.text;
//                     final password = _passwordController.text;
//                     context.read<AuthCubit>().login(username, password);
//                   },
//                   child: Text('Se connecter'),
//                 ),
//                 if (state is AuthSuccess)
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: state.notes.length,
//                       itemBuilder: (context, index) {
//                         final note = state.notes[index];
//                         return ListTile(
//                           title: Text(note['title']),
//                           subtitle: Text(note['description']),
//                         );
//                       },
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
