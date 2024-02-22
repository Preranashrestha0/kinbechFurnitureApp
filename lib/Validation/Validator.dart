class Validator {
  static String? validateName({ String? name}) {
    if (name == null) {
      return null;
    }
    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }

    return null;
  }

  static String? validateAddress({required String address}) {
    if (address == null) {
      return null;
    }
    if (address.isEmpty) {
      return 'Address can\'t be empty';
    }

    return null;
  }
  static String? validatephoneNo({required String phone}) {
    if ({phone} == null) {
      return null;
    }
    if (phone.isEmpty) {
      return 'Address can\'t be empty';
    }

    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email can\'t be empty';
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null) {
      return 'Password can\'t be empty';
    } else if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    }

    return null;
  }
}