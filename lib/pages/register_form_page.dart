// ignore_for_file: avoid_print, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/model/user.dart';
import 'package:my_app/pages/user_info_page.dart';

class RegisterFormPage extends StatefulWidget {
  const RegisterFormPage({super.key});

  @override
  State<RegisterFormPage> createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage> {
  bool _hidePass = true;
  bool _hidePassOnConfirm = true;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  User newUser = User();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  final List<String> _countries = [
    'Ukraine',
    'USA',
    'United Kingdom',
    'Poland'
  ];
  String? _selectedCountry;

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Register Form'),
            centerTitle: false,
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                TextFormField(
                  focusNode: _nameFocus,
                  autofocus: true,
                  onFieldSubmitted: (_) {
                    _fieldFocusChange(context, _nameFocus, _phoneFocus);
                  },
                  validator: _validateName,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name *',
                    hintText: 'What do people call you?',
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _nameController.clear();
                      },
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.black, width: 0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  onSaved: (value) => newUser.name = value,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  maxLength: 13,
                  onSaved: (value) => newUser.phone = value,
                  focusNode: _phoneFocus,
                  autofocus: true,
                  onFieldSubmitted: (_) {
                    _fieldFocusChange(context, _phoneFocus, _passwordFocus);
                  },
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp(r'^[()\d -+]{1,15}$'),
                        allow: true),
                  ],
                  validator: (value) => _validatePhoneNumber(value!)
                      ? null
                      : 'Phone number format required +38XXXXXX-XXXX ',
                  decoration: InputDecoration(
                    labelText: 'Phone number *',
                    hintText: 'Where can we reach you?',
                    helperText: '38(XXX)XXX-XX-XX',
                    prefixIcon: const Icon(Icons.call),
                    suffixIcon: GestureDetector(
                      onLongPress: () {
                        _phoneController.clear();
                      },
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.black, width: 0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  onSaved: (value) => newUser.email = value.toString(),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  // validator: _validateEmail,
                  decoration: const InputDecoration(
                    labelText: 'Email adress *',
                    hintText: 'Enter your email',
                    icon: Icon(Icons.mail),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.black, width: 0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.map),
                      labelText: 'Select country.'),
                  items: _countries.map((country) {
                    return DropdownMenuItem(
                      child: Text(country),
                      value: country,
                    );
                  }).toList(),
                  onChanged: (country) {
                    print(country);

                    setState(
                      () {
                        _selectedCountry = country ?? '';
                        newUser.country = country.toString();
                      },
                    );
                  },
                  // validator: ((value) =>
                  //     value == null ? 'Select country' : null),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  // validator: (value) => _validateBio(value),
                  onSaved: (value) => newUser.bio = value.toString(),
                  controller: _bioController,
                  decoration: const InputDecoration(
                      labelText: 'Bio *',
                      hintText: 'Tell us about you',
                      helperText: 'Keep it short, it`s just a demo',
                      border: OutlineInputBorder()),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(100),
                  ],
                  maxLines: 3,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  focusNode: _passwordFocus,
                  controller: _passwordController,
                  obscureText: _hidePass,
                  maxLength: 8,
                  // validator: _validatePassword,
                  decoration: InputDecoration(
                    labelText: 'Password *',
                    hintText: 'Enter password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _hidePass = !_hidePass;
                        });
                      },
                      icon: Icon(
                          _hidePass ? Icons.visibility : Icons.visibility_off),
                    ),
                    icon: const Icon(Icons.security),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _hidePassOnConfirm,
                  maxLength: 8,
                  // validator: _validatePassword,
                  decoration: InputDecoration(
                      labelText: 'Confirm password *',
                      hintText: 'Confirm your password',
                      prefixIcon: const Icon(Icons.border_color),
                      suffixIcon: IconButton(
                          onPressed: (() {
                            setState(() {
                              _hidePassOnConfirm = !_hidePassOnConfirm;
                            });
                          }),
                          icon: Icon(_hidePassOnConfirm
                              ? Icons.visibility
                              : Icons.visibility_off))),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green),
                  ),
                  child: const Text(
                    'Submit form',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      _showDialog(_nameController.text);
      print('Name: ${_nameController.text}');
      print('Phone: ${_phoneController.text}');
      print('Email: ${_emailController.text}');
      print('Country: $_selectedCountry');
      print('Bio: ${_bioController.text}');
    } else {
      _showMessage(message: 'Form is not valid.');
    }
  }

  String? _validateName(String? value) {
    final nameExp = RegExp(r'^[a-zA-Z ]*$');
    if (value!.isEmpty) {
      return 'Name is required';
    } else if (!nameExp.hasMatch(value)) {
      return 'Please, enter your name';
    } else if (value.trim().isEmpty) {
      return 'Name is required';
    } else {
      return null;
    }
  }

  bool _validatePhoneNumber(String input) {
    final phoneExp = RegExp(r'^\+\d\d\d\d\d\d\d\d\d\d\d\d$');
    return phoneExp.hasMatch(input);
  }

  String? _validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!_emailController.text.contains('@')) {
      return 'Invalid email adress';
    } else {
      return null;
    }
  }

  String? _validateBio(String? value) {
    if (value!.isEmpty) {
      return 'Tell us something about you';
    } else {
      null;
    }
  }

  String? _validatePassword(String? value) {
    if (_passwordController.text.length != 8) {
      return 'Password is too short';
    } else if (_confirmPasswordController.text != _passwordController.text) {
      return 'Passwords don\'t match';
    } else {
      return null;
    }
  }

  void _showMessage({required String message}) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _showDialog(String name) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Registration successful',
              style: TextStyle(color: Colors.green),
            ),
            content: Text(
              '$name is now a verified user',
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserInfoPage(
                        userInfo: newUser,
                      ),
                    ),
                  );
                },
                child: const Text('Vefiried',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18.0,
                    )),
              )
            ],
          );
        });
  }
}
