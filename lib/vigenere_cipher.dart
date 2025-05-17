class VigenereCipher {
  static final List<List<String>> _vigenereTable = _buildVigenereTable();

  static List<List<String>> _buildVigenereTable() {
    List<List<String>> table = List.generate(26, (_) => List.filled(26, ''));
    for (int i = 0; i < 26; i++) {
      for (int j = 0; j < 26; j++) {
        table[i][j] = String.fromCharCode(((i + j) % 26) + 65); // A-Z
      }
    }
    return table;
  }

  static String encrypt(String plaintext, String key) {
    StringBuffer ciphertext = StringBuffer();
    key = key.toUpperCase();
    int keyIndex = 0;

    for (int i = 0; i < plaintext.length; i++) {
      String char = plaintext[i];
      if (_isLetter(char)) {
        bool isLower = _isLowerCase(char);
        int row = key.codeUnitAt(keyIndex % key.length) - 65;
        int col = char.toUpperCase().codeUnitAt(0) - 65;
        String cipherChar = _vigenereTable[row][col];
        ciphertext.write(isLower ? cipherChar.toLowerCase() : cipherChar);
        keyIndex++;
      } else {
        ciphertext.write(char);
      }
    }

    return ciphertext.toString();
  }

  static String decrypt(String ciphertext, String key) {
    StringBuffer plaintext = StringBuffer();
    key = key.toUpperCase();
    int keyIndex = 0;

    for (int i = 0; i < ciphertext.length; i++) {
      String char = ciphertext[i];
      if (_isLetter(char)) {
        bool isLower = _isLowerCase(char);
        int row = key.codeUnitAt(keyIndex % key.length) - 65;
        String upperChar = char.toUpperCase();
        int col = _vigenereTable[row].indexOf(upperChar);
        String plainChar = String.fromCharCode(col + 65);
        plaintext.write(isLower ? plainChar.toLowerCase() : plainChar);
        keyIndex++;
      } else {
        plaintext.write(char);
      }
    }

    return plaintext.toString();
  }

  static bool _isLetter(String ch) {
    return RegExp(r'[a-zA-Z]').hasMatch(ch);
  }

  static bool _isLowerCase(String ch) {
    return ch.codeUnitAt(0) >= 97 && ch.codeUnitAt(0) <= 122;
  }
}
