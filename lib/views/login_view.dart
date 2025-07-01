import 'package:flutter/material.dart';
import 'package:project_cipher/controllers/auth_controller.dart';
import 'package:project_cipher/utils/auth_global.dart';
import 'package:project_cipher/views/components/primary_button.dart';
import 'package:project_cipher/views/components/input_text.dart';
import 'package:project_cipher/views/layouts/base_layout.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool _isLoading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    await authController.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 10.0,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/logo.svg',
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.secondary, BlendMode.srcIn),
                  height: 100,
                ),
                SizedBox(
                  height: 40,
                ),
                InputText(
                  labelText: "Correo Electrónico",
                  textEditingController: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingrese su correo";
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Correo inválido";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                InputText(
                  labelText: "Contraseña",
                  obscureText: true,
                  textEditingController: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingrese su contraseña";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                _isLoading
                    ? CircularProgressIndicator()
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PrimaryButton(
                          labelText: "Iniciar Sesión", onPressed: _login),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
