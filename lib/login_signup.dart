import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ticket_flutter/global.dart';
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
        var userLogingIn = await SupaConnect().signIn(_email, _password);
        if (userLogingIn != null) {
          currentUser = userLogingIn;
          return;
        }
      }
      return await SupaConnect()
          .signUp(_email, _password, _pseudo, _nom, _prenom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding( 
      padding : EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      child : Scaffold(
              backgroundColor: Color.fromARGB(31, 157, 192, 249),

      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        centerTitle: true,
        title: Text(_isLogin ? 'SE CONNECTER' : "S'INSCRIRE",
            
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
                color: Color.fromARGB(255, 2, 78, 218),
                fontWeight: FontWeight.w800)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Email Field with Padding
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
              ),
              // Password Field with Padding
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Mot de Passe',
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onFieldSubmitted: (value) => _submit(),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Le Mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
              ),
              // Conditional Fields for Signup
              if (!_isLogin) ...[
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Pseudo',
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer un pseudo';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _pseudo = value!;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nom',
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer un nom';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _nom = value!;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Prénom',
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer un prénom';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _prenom = value!;
                    },
                  ),
                ),
              ],
              SizedBox(height: 20),
              // Button with Padding
              Padding(
                padding: EdgeInsets.all(5.0),
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 2, 78, 218),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    minimumSize: Size(double.infinity, 50), // Button width = container width
                  ),
                  child: Text(_isLogin ? 'SE CONNECTER' : "S'INSCRIRE"),
                ),
              ),
              // Toggle Form Mode Button
              TextButton(
                onPressed: _toggleFormMode,
                child: Text(
                    _isLogin ? 'Créer un compte' : 'Déjà inscrit ? Se Connecter', style: TextStyle(color : const Color.fromARGB(255, 108, 108, 108), )),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
