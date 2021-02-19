import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../assets/constants.dart';
import '../validators/email.dart' as email;
import '../validators/password.dart' as password;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;
  var _isLogin = true;
  var _isWaiting = false;
  String _email;
  String _password;

  SnackBar _errorSnackBar(String errorMessage) {
    return SnackBar(
      content: Text(
        errorMessage,
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          radius: 1,
          colors: [secondaryColor, primaryColor],
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Align(
              child: LayoutBuilder(
                builder: (context, constraints) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue[900], width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8),
                  width: constraints.maxWidth - 50,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        TextFormField(
                          validator: (String value) {
                            if (!email.isValid(value)) {
                              return 'Please provide a valid email adress';
                            }
                            return null;
                          },
                          onSaved: (newValue) => _email = newValue,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            icon: const Icon(Icons.email),
                            labelText: 'Email',
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          validator: (String value) {
                            _password = value;
                            if (!password.isValid(value)) {
                              return 'Please provide a longer password';
                            }
                            return null;
                          },
                          onSaved: (String newValue) => _password = newValue,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            icon: const Icon(Icons.lock),
                            labelText: 'Password',
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          //curve: Curves.linear,
                          constraints: BoxConstraints(
                            minHeight: _isLogin ? 0 : 70,
                            maxHeight: _isLogin ? 0 : 80,
                          ),
                          //height: _isLogin ? 0 : 80,
                          child: AnimatedOpacity(
                            opacity: _isLogin ? 0.0 : 1,
                            duration: const Duration(milliseconds: 500),
                            child: _isLogin
                                ? null
                                : TextFormField(
                                    validator: (newValue) {
                                      if (!_isLogin && newValue != _password) return "The passwords don't match!";
                                      return null;
                                    },
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    obscureText: _obscureText,
                                    decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                        child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      icon: const Icon(Icons.lock),
                                      labelText: 'Confirm Password',
                                      filled: true,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Builder(
                          builder: (ctx) => RaisedButton(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            clipBehavior: Clip.hardEdge,
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            color: Colors.blue,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  _isWaiting = true;
                                });
                                if (_isLogin) {
                                  try {
                                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                                      email: _email,
                                      password: _password,
                                    );
                                  } catch (e) {
                                    String _message;
                                    switch (e.code as String) {
                                      case 'user-not-found':
                                      case 'wrong-password':
                                        _message = 'Unable to log you in\nPlease try again';
                                        break;
                                      case 'user-disabled':
                                        _message = 'This user has been disabled';
                                        break;
                                      default:
                                        _message = 'Unable to connect\nPlease check your internet connection';
                                    }
                                    Scaffold.of(context).hideCurrentSnackBar();
                                    Scaffold.of(ctx).showSnackBar(_errorSnackBar(_message));
                                  }
                                } else {
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(email: _email, password: _password);
                                  } catch (e) {
                                    String _message;
                                    switch (e.code as String) {
                                      case 'email-already-in-use':
                                        _message =
                                            'This email is alredy in use\nPlease try again with a different email';
                                        break;
                                      case 'invalid-email':
                                        _message = 'This email is not valid\nPlease try again with a valid email';
                                        break;
                                      case 'weak-password':
                                        _message =
                                            'This password is too weak\nPlease try again with a stronger password';
                                        break;
                                      default:
                                        _message = 'Unable to connect\nPlease check your internet connection';
                                    }
                                    Scaffold.of(context).hideCurrentSnackBar();
                                    Scaffold.of(ctx).showSnackBar(_errorSnackBar(_message));
                                  }
                                }
                                setState(() {
                                  _isWaiting = false;
                                });
                              }
                            },
                            child: !_isWaiting
                                ? Text(!_isLogin ? 'Sign Up' : 'Login')
                                : const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(
                            _isLogin ? 'Sign Up' : 'Login',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
