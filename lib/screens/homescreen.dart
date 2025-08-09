import 'package:flutter/material.dart';
import 'package:news_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PulseDaily'),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to PulseDaily!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Text(
                  'Hello, ${authProvider.user?.displayName ?? authProvider.user?.email ?? 'User'}!',
                  style: TextStyle(fontSize: 18),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}