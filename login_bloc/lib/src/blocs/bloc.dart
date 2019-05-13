import 'dart:async';
import 'validators.dart';
import 'package:rxdart/rxdart.dart';

class Bloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

//  Add data to stream
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password => _passwordController.stream.transform(validatePassword);


//  Change data
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.add;

  Stream<bool> get submitValid => Observable.combineLatest2(email, password, (e, p) => true);

  void submit() {
    final validEmail = _emailController.value;
    final validPassword = _passwordController.value;

    print('Email: $validEmail');
    print('Password: $validPassword');

  }

  dispose() {
    _emailController.close();
    _passwordController.close();
  }
}

//final bloc = Bloc(); // Single Global Instance Approach