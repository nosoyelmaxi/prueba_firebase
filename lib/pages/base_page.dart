import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:prueba_firebase/pages/admin_page.dart';
import 'package:prueba_firebase/pages/eventos_page.dart';

class BasePage extends StatelessWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<User?>(context);

    return usuario != null ? HomePage() : AdminPage();
  }
}
