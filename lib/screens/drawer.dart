import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/firebaseProvider.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const Text('hehe1'),
              Container(
                height: 100,
              ),
              ListTile(
                title: const Text('Sign Out'),
                onTap: ()=>context.read<FirebaseProvider>().signOut(),
              ),
              const ListTile(
                title: Text('Account'),
              ),
              const ListTile(
                title: Text('Settings'),
              ),
              const ListTile(
                title: Text('Report a bug'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
