import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/di/service_locator.dart';
import 'package:flutter_template/user/user_manager.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Text('Home Page'),
              ElevatedButton(
                child: Text('Log out'),
                onPressed: () => _onLogoutPressed(context),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.black,
                  primary: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onLogoutPressed(BuildContext context) {
    serviceLocator.get<UserManager>().logout();
  }
}
