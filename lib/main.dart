import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news_app/providers/auth_provider.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/homescreen.dart';
import 'package:news_app/screens/loginscreen.dart';
import 'package:news_app/screens/signupscreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => NewsProvider()),
        ChangeNotifierProvider(create: (context)=> BookmarkProvider())
        ],
      child: MaterialApp(
        title: "PulseDaily",
        theme: ThemeData(primarySwatch: Colors.blue),
        home: AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        print("=== AuthWrapper Debug ===");
        print("isloading: ${authProvider.isloading}");
        print("isAuthenticated: ${authProvider.isAuthenticated}");
        print("user: ${authProvider.user}");
        print("user uid: ${authProvider.user?.uid}");
        print("========================");

        if (authProvider.isloading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (authProvider.isAuthenticated) {
          print("User is authenticated, showing Homescreen");
          return Homescreen();
        } else {
          print("User not authenticated, showing Loginscreen");
          return Loginscreen();
        }
      },
    );
  }
}
