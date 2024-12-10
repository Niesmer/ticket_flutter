import 'package:flutter/material.dart';
import 'package:ticket_flutter/supabase.dart';

class LoginSignup extends StatefulWidget {
  const LoginSignup({super.key});

  @override
  _LoginSignupState createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  String _pseudo = '';
  String _nom = '';
  String _prenom = '';

  void _toggleFormMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Perform login or signup logic here
      if (_isLogin) {
        return await SupaConnect().signIn(_email, _password);
      }
      return await SupaConnect().signUp(_email, _password, _pseudo, _nom, _prenom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              if (!_isLogin) ...[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Pseudo'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a pseudo';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _pseudo = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nom'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nom = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Prénom'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _prenom = value!;
                  },
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_isLogin ? 'Login' : 'Signup'),
              ),
              TextButton(
                onPressed: _toggleFormMode,
                child: Text(
                    _isLogin ? 'Create an account' : 'Have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
