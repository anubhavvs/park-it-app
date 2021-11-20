import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../models/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("images/sp_1.png"),
                fit: BoxFit.cover,
              ),
              /*gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(32, 191, 85, 1).withOpacity(0.5),
                  Color.fromRGBO(1, 186, 239, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),*/
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  bool ishidden = true;
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
    'plate': '',
    'number': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void clearText() {
    _passwordController.clear();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occured.'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Okay'))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'], _authData['password']);
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
            _authData['email'],
            _authData['password'],
            _authData['name'],
            _authData['number'],
            _authData['plate']);
      }
    } on HttpException catch (error) {
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    } catch (error) {
      var errorMessage = 'Not able to authenticate. Try again later!';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
        clearText();
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
        clearText();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      color: Colors.white.withOpacity(0.9),
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 555 : 339,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 555 : 339),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Center(
                    child: Container(
                        width: 455,
                        height: 100,
                        child: Image.asset('images/ava.gif')),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'E-Mail *',
                    labelStyle: TextStyle(
                      //color: Colors.black.withOpacity(0.6),
                      fontSize: 15,
                    ),
                    suffixIcon: Icon(
                      Icons.email_outlined,
                      size: 20,
                      color: Color(0xff916DB0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(
                      labelText: 'Name *',
                      labelStyle: TextStyle(
                        //color: Color(0xff000C66),
                        fontSize: 15,
                      ),
                      suffixIcon: Icon(
                        Icons.person_outlined,
                        size: 20,
                        color: Color(0xff916DB0),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Name is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['name'] = value;
                    },
                  ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(
                      labelText: 'Number *',
                      labelStyle: TextStyle(
                        //color: Colors.black.withOpacity(0.6),
                        fontSize: 15,
                      ),
                      suffixIcon: Icon(
                        Icons.phone_android_outlined,
                        size: 20,
                        color: Color(0xff916DB0),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty || value.length < 10) {
                        return 'Number is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['number'] = value;
                    },
                  ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(
                      labelText: 'Vehicle Number Plate *',
                      labelStyle: TextStyle(
                        //color: Colors.black.withOpacity(0.6),

                        fontSize: 15,
                      ),
                      suffixIcon: Icon(
                        Icons.time_to_leave_outlined,
                        color: Color(0xff916DB0),
                        size: 20,
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Vehicle Number Plate is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['plate'] = value;
                    },
                  ),
                TextFormField(
                  obscureText: ishidden,
                  decoration: InputDecoration(
                    labelText: 'Password *',
                    labelStyle: TextStyle(
                      //color: Colors.black.withOpacity(0.6),
                      fontSize: 15,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        ishidden
                            ? Icons.security_outlined
                            : Icons.remove_moderator,
                        size: 18,
                        color: Color(0xff916DB0),
                      ),
                      onPressed: () {
                        ishidden = !ishidden;
                        setState(() {});
                      },
                    ),
                  ),
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password *',
                      labelStyle: TextStyle(
                        //color: Colors.black.withOpacity(0.6),
                        fontSize: 15,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          ishidden
                              ? Icons.security_outlined
                              : Icons.remove_moderator,
                          size: 18,
                          color: Color(0xff916DB0),
                        ),
                        onPressed: () {
                          ishidden = !ishidden;
                          setState(() {});
                        },
                      ),
                    ),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }
                        : null,
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      if (_isLoading)
                        CircularProgressIndicator()
                      else
                        ElevatedButton(
                          child: Text(_authMode == AuthMode.Login
                              ? 'LOGIN'
                              : 'REGISTER'),
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                  color: Color(0xff916DB0), width: 1.0),
                              minimumSize: Size(64.5, 38)),
                        ),
                      Divider(
                        indent: 3,
                        endIndent: 3,
                      ),
                      OutlinedButton(
                        child: Text(
                            '${_authMode == AuthMode.Login ? 'REGISTER' : 'LOGIN'} !'),
                        onPressed: _switchAuthMode,
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Color(0xff916DB0), width: 1.0),
                            minimumSize: Size(22.5, 38)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
