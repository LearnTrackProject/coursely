class AppRegex {
  static bool isEmailValid(String email) {
    return RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email);
  }

  static bool isEgyptMobile(String mobile) {
    return RegExp(r'^01[0125][0-9]{8}$').hasMatch(mobile);
  }
}
