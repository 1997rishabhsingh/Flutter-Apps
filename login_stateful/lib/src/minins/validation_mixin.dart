class ValidationMixin {
  String validateEmail(String value) {
    if(!value.contains('@')) {
      return 'Please enter valid email';
    }
    return null;
  }

  String validatePassword(String value) {
    if(value.length<4) {
      return 'Password too short';
    }
    return null;
  }
}