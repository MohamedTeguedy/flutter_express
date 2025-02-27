import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authe_registre/business_logic/cubit/registre_cubit.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfirmPassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: BlocListener<RegistreCubit, RegistreState>(
        listener: (context, state) {
          if (state is RegistreSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Inscription réussie !"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is RegistreFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 100),
                Text(
                  "Register",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  "Create your account",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 35),
                _buildTextField("Username", Icons.person_outline,
                    _controllerUsername, TextInputType.name),
                const SizedBox(height: 10),
                _buildPasswordField("Password", _controllerPassword),
                const SizedBox(height: 10),
                _buildPasswordField(
                    "Confirm Password", _controllerConfirmPassword),
                const SizedBox(height: 50),
                BlocBuilder<RegistreCubit, RegistreState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: state is RegistreLoading
                          ? null
                          : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                context.read<RegistreCubit>().register(
                                      _controllerUsername.text,
                                      _controllerPassword.text,
                                    );
                              }
                            },
                      child: state is RegistreLoading
                          ? const CircularProgressIndicator()
                          : const Text("Register"),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Login"),
                    ),
                    const SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () {
                        context.read<RegistreCubit>().resetState();
                      },
                      child: const Text('Réinitialiser'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon,
      TextEditingController controller, TextInputType inputType) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Please enter $label.";
        return null;
      },
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          icon: Icon(_obscurePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Please enter password.";
        if (label == "Confirm Password" && value != _controllerPassword.text) {
          return "Passwords do not match.";
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _focusNodeConfirmPassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    _controllerConfirmPassword.dispose();
    super.dispose();
  }
}
