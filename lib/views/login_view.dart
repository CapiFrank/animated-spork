import 'package:flutter/material.dart';
import 'package:project_cipher/controllers/auth_controller.dart';
import 'package:project_cipher/views/components/primary_button.dart';
import 'package:project_cipher/views/device_view.dart';
import 'package:project_cipher/views/components/input_text.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  final bgColor = Color.fromRGBO(202, 213, 226, 1);

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authController =
          Provider.of<AuthController>(context, listen: false);
      bool success = await authController.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DeviceView()),
        );
      } else {
        setState(() => _errorMessage = "Credenciales inválidas.");
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/logo.png"),
                width: 256,
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
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child:
                      Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                ),
              SizedBox(height: 40),
              _isLoading
                  ? CircularProgressIndicator()
                  : PrimaryButton(
                      labelText: "Iniciar Sesión", onPressed: _login),
            ],
          ),
        ),
      ),
    );
  }
}
