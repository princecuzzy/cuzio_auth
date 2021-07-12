import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // The formkey is created here and will be eventually assigned to the form widget
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isSubmitting, _obscureText = true;
  String _password, _email;

  Widget _showTitle() {
    return Text(
      'Login',
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget _showEmail() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _email = val,
        //if the user inputs anything without @, tell the user that the email is invalid
        validator: (val) => !val.contains('@') ? 'Invalid Email' : null,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
          hintText: 'kindly enter a valid email',
          icon: Icon(
            Icons.mail,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _showPassword() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _password = val,
        //if the value that enters the password field, show invalid password
        validator: (val) => val.length < 8 ? 'Invalid Email' : null,
        obscureText: _obscureText,
        decoration: InputDecoration(
          //setting the icon on the password field for viewing and hiding password
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            // if the obscuretext is true, show the hide password icon but if its false, show the reveal password icon
            child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          ),
          border: OutlineInputBorder(),
          labelText: 'Password',
          hintText: 'kindly enter a valid password',
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _showFormActions() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          _isSubmitting == true
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).accentColor,
                ))
              : ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(8.0),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text('Login'),
                  onPressed: () => _submitForm(),
                ),
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/register'),
            child: Text('New user? Register'),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

// check if all parts of the form is valid or not
  void _submitForm() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      _registerUser();
    }
  }

  void _registerUser() async {
    setState(
      () {
        //set to true and calling setState
        _isSubmitting = true;
      },
    );

    //connect to the api to register new users
    http.Response response = await http.post(
      Uri.parse('http://10.0.2.2:1337/auth/local'),
      body: {
        'identifier': _email,
        'password': _password,
      },
    );

//decode the json data we get back
    final responseData = json.decode(response.body);

    //check if theres an error. 200 means success
    if (response.statusCode == 200) {
      setState(
        () {
          //set to false and calling setState
          _isSubmitting = false;
        },
      );
      _storeUserdata(responseData);

      //enables a success snack bar
      _showSnackBar();

      //redirects user to our products page
      _redirectUser();

      print(responseData);
    } else {
      setState(
        () {
          _isSubmitting = false;
// responseData gives us the message property
          final String errorMessage = responseData['message'];

// snack bar for showing errors
          _showErrorSnackbar(errorMessage);
        },
      );
    }
  }

  void _storeUserdata(responseData) async {
    //initialize sharedpreferences.used wetherwe want to add data or to the extractdata
    final prefs = await SharedPreferences.getInstance();

    //we get the user value and store it in a map with key value pair of type string and dynamic values associated with those keys.
    Map<String, dynamic> user = responseData['user'];

    //put a new key value pair under that map if it doesnt exist. use the putIfAbsent method. jwt is the key and the function retures the value
    user.putIfAbsent('jwt', () => responseData['jwt']);

    // sharedpeferences only accepts strings so we use jsonencode to convert our json data to a string value
    prefs.setString('user', json.encode(user));
    // prefs.setString metod puts a string value into shared preferences with a key user and value json.encode(user)
  }

  void _showSnackBar() {
    final snackBar = SnackBar(
      content: Text(
        'User logged in successfully',
        style: TextStyle(color: Colors.green),
      ),
    );

    //show the snackbar
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(snackBar);

    //reset the form
    _formKey.currentState.reset();
  }

  void _showErrorSnackbar(String errorMessage) {
    final snackBar = SnackBar(
      content: Text(
        errorMessage,
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );

    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(snackBar);

    throw Exception('Error logging in: $errorMessage');
  }

// wait for 2 seconds befor moving to the products page in order to give room for us to see the snackBar for some secs
  void _redirectUser() {
    Future.delayed(
      Duration(seconds: 2),
      () {
        Navigator.popAndPushNamed(context, '/ProductsPage');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              // the key is set to the form key here
              key: _formKey,
              child: Column(
                children: [
                  _showTitle(),
                  _showEmail(),
                  _showPassword(),
                  _showFormActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
