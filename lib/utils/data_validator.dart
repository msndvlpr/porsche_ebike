
String? isVinValid(String? vin) {

  List<int> values = [
    1, 2, 3, 4, 5, 6, 7, 8, 0, 1, 2, 3, 4, 5, 0, 7, 0, 9,
    2, 3, 4, 5, 6, 7, 8, 9
  ];
  List<int> weights = [
    8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2
  ];

  if(vin == null || vin.isEmpty){
    return "VIN number must be 17 characters";
  }
  String s = vin.replaceAll("-", "").replaceAll(" ", "").toUpperCase();
  if (s.length != 17) {
    return "VIN number must be 17 characters";
  }

  int sum = 0;
  for (int i = 0; i < 17; i++) {
    String c = s[i];
    int value;
    int weight = weights[i];

    if (c.codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
        c.codeUnitAt(0) <= 'Z'.codeUnitAt(0)) {
      value = values[c.codeUnitAt(0) - 'A'.codeUnitAt(0)];
      if (value == 0) {
        return "Illegal character: $c";
      }
    }
    // number
    else if (c.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
        c.codeUnitAt(0) <= '9'.codeUnitAt(0)) {
      value = c.codeUnitAt(0) - '0'.codeUnitAt(0);
    }
    // illegal character
    else {
      return "Illegal character: $c";
    }

    sum += weight * value;
  }

  // check digit
  sum = sum % 11;
  String check = s[8];
  if (sum == 10 && check == 'X') {
    return null;
  } else if (sum == _transliterate(check)) {
    return null;
  } else {
    return "VIN number is in illegal format";
  }
}

int _transliterate(String check) {
  if (check == 'A' || check == 'J') {
    return 1;
  } else if (check == 'B' || check == 'K' || check == 'S') {
    return 2;
  } else if (check == 'C' || check == 'L' || check == 'T') {
    return 3;
  } else if (check == 'D' || check == 'M' || check == 'U') {
    return 4;
  } else if (check == 'E' || check == 'N' || check == 'V') {
    return 5;
  } else if (check == 'F' || check == 'W') {
    return 6;
  } else if (check == 'G' || check == 'P' || check == 'X') {
    return 7;
  } else if (check == 'H' || check == 'Y') {
    return 8;
  } else if (check == 'R' || check == 'Z') {
    return 9;
  } else if (int.tryParse(check) != null) {
    return int.parse(check);
  }
  return -1;
}
