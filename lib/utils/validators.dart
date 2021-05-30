class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  // static final RegExp _passwordRegExp = RegExp(
  //   r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  // );

  static isValidEmail(String email) {
    try {
      if (_emailRegExp.hasMatch(email)) {
        int len = email.length;
        print(email);
        if (email.substring(len - 14) == 'st.utc2.edu.vn') {
          return true;
        } else
          return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // static isValidPassword(String password) {
  //   return _passwordRegExp.hasMatch(password);
  // }
}
