class Validator {
  ///Email Validator
  static String? emailValidator(var value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email address";
    }
    if (!value.contains("@gmail.com")) {
      return "Please enter a valid email address";
    }
    return null;
  }

  ///Password Validator
  static String? passwordValidator(var value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  ///Username Validator
  static String? usernameValidator(var value) {
    if (value == null || value.isEmpty) {
      return "Please enter a username";
    }
    if (value.contains('!@#%^&*()_+~`|?/<>,.:;')) {
      return 'Please enter a valid username';
    }
    return null;
  }
}
