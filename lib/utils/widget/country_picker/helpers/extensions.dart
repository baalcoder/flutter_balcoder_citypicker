extension HelperExtensions on String? {
  // used to get  the character at [index] of the `String`.
  // ex :
  // String name = 'Mahmoud';
  // String char1 = name.charAt(0); // returns 'M'
  // String char2 = name.charAt(4); // returns 'm'
  // String? char3 = name.charAt(-20); // returns null
  // String? char4 = name.charAt(20); // returns null

  String? charAt(int index) {
    if (this == null) {
      return null;
    }
    if (this!.isEmpty) {
      return this;
    }
    if (index > this!.length) {
      return null;
    }
    if (index < 0) {
      return null;
    }
    return this!.split('')[index];
  }
}
