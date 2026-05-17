import 'package:api/controller.dart';
import 'package:api/ghaliah_home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => DigimonController())],
      child: MaterialApp(
        home: GhaliahHomepage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
