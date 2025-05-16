class ClassicalOTP {
  static String _preprocess(String input) {
    return input.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
  }

  static String _adjustKey(String text, String key) {
    key = _preprocess(key);
    if (key.isEmpty) throw ArgumentError('Key cannot be empty.');

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(key[i % key.length]);
    }
    return buffer.toString();
  }

  static String encrypt(String plaintext, String key) {
    plaintext = _preprocess(plaintext);
    key = _adjustKey(plaintext, key);

    final encrypted = List.generate(plaintext.length, (i) {
      int p = plaintext.codeUnitAt(i) - 65;
      int k = key.codeUnitAt(i) - 65;
      int c = (p + k) % 26;
      return String.fromCharCode(c + 65);
    }).join();

    return encrypted;
  }

  static String decrypt(String ciphertext, String key) {
    ciphertext = _preprocess(ciphertext);
    key = _adjustKey(ciphertext, key);

    final decrypted = List.generate(ciphertext.length, (i) {
      int c = ciphertext.codeUnitAt(i) - 65;
      int k = key.codeUnitAt(i) - 65;
      int p = (c - k + 26) % 26;
      return String.fromCharCode(p + 65);
    }).join();

    return decrypted;
  }
}
