import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_template/feature/auth/login/bloc/login_cubit.dart';
import 'package:flutter_template/feature/auth/router/auth_router_delegate.dart';
import 'package:flutter_template/resources/localization/l10n.dart';
import 'package:flutter_template/resources/localization/localization_notifier.dart';
import 'package:flutter_template/resources/theme/theme_change_notifier.dart';
import 'package:provider/provider.dart';

class UsernameView extends StatelessWidget {
  final bool sessionExpiredRedirect;
  final TextEditingController _userNameController = TextEditingController();

  UsernameView({Key? key, this.sessionExpiredRedirect = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('English'),
                      value: 'en',
                    ),
                    PopupMenuItem(
                      child: Text('Macedonian'),
                      value: 'mk',
                    ),
                    PopupMenuItem(
                      child: Text('Toggle Theme'),
                      value: 'theme',
                    ),
                  ])
        ],
      ),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (listenerContext, state) {
          if (state is AwaitPasswordInput) {
            context.read<AuthRouterDelegate>().setLoginPasswordNavState();
          }
        },
        builder: (context, state) {
          if (state is LoginInProgress || state is LoginSuccess) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.helloWorld,
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 24,
                      ),
                    ),
                    Text('Login Page'),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _userNameController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        hintText: "Username",
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      child: Text('Next'),
                      onPressed: () => _onNextPressed(context),
                    ),
                    ElevatedButton(
                      child: Text('Sign up'),
                      onPressed: () => _onSignUpPressed(context),
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.black,
                        primary: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _onNextPressed(BuildContext context) {
    BlocProvider.of<LoginCubit>(context)
        .onUsernameEntered(_userNameController.text);
  }

  void _onSignUpPressed(BuildContext context) {
    context.read<AuthRouterDelegate>().setSignupNavState();
  }

  onSelected(BuildContext context, String item) {
    if (item == 'theme') {
      final themeNotifier =
          Provider.of<ThemeChangeNotifier>(context, listen: false);
      themeNotifier.toggleTheme();
    } else {
      final localizationNotifier =
          Provider.of<LocalizationNotifier>(context, listen: false);
      localizationNotifier.setLocale(L10n.getLocale(item));
    }
  }
}
