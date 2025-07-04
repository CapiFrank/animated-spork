import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_cipher/utils/auth_global.dart';
import 'package:project_cipher/utils/palette.dart';
import 'package:project_cipher/views/components/secondary_button.dart';
import 'package:project_cipher/views/layouts/base_layout.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/danger_button.dart';

class PaymentBlockedView extends StatefulWidget {
  const PaymentBlockedView({super.key});

  @override
  PaymentBlockedState createState() => PaymentBlockedState();
}

class PaymentBlockedState extends State<PaymentBlockedView> {
  bool _isLoading = false;
  String? _errorMessage;

  void _checkAuth() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await authController.checkSession();
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _launchEmail() async {
    final email = Uri.parse('mailto:jose.developer17@gmail.com');
    if (await canLaunchUrl(email)) {
      await launchUrl(email);
    } else {
      throw 'No se pudo abrir el correo.';
    }
  }

  void _launchBrowser() async {
    final email = Uri.parse('https://wa.me/50664297312');
    if (await canLaunchUrl(email)) {
      await launchUrl(email);
    } else {
      throw 'No se pudo abrir el navegador.';
    }
  }

  // Función para realizar una llamada telefónica
  void _launchPhone() async {
    final phone = Uri.parse('tel:+50664297312');
    if (await canLaunchUrl(phone)) {
      await launchUrl(phone);
    } else {
      throw 'No se pudo realizar la llamada.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      backgroundColor: Theme.of(context).colorScheme.onError,
      appBar: AppBar(
        title: Text("Cuenta Bloqueada"),
        backgroundColor: Theme.of(context).colorScheme.onError,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 100,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: 20),
            Text(
              "Tu dispositivo ha sido bloqueado por falta de pago.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Para reactivar tu cuenta y seguir disfrutando de la aplicación, por favor realiza el pago y notifica a los siguientes contactos:",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: _launchEmail,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Correo: ",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "jose.developer17@gmail.com",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            InkWell(
                onTap: _launchPhone,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Telefono: ",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "+50664297312",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                )),
            SizedBox(height: 10),
            InkWell(
                onTap: _launchBrowser,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Whatsapp: ",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "+50664297312",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                )),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(_errorMessage!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            SizedBox(height: 40),
            _isLoading
                ? CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45),
                    child: SecondaryButton(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(
                            color: Palette(context).primary,
                          ),
                        ),
                        color: Palette(context).primary,
                        labelText: "Reintentar",
                        onPressed: _checkAuth),
                  ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: DangerButton(
                  labelText: "Cerrar",
                  onPressed: () {
                    SystemNavigator.pop();
                  }),
            )
          ],
        ),
      ),
    );
  }
}
