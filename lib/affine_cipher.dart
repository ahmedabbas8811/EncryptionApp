class AffineCipher {
  final int a;
  final int b;
  final int m = 26;

  AffineCipher({required this.a, required this.b}) {
    if (_gcd(a, m) != 1) {
      throw ArgumentError('a and m must be coprime. Got a=$a and m=$m');
    }
  }

  String encryptText(String plaintext) {
    return plaintext.toUpperCase().replaceAll(' ', '').split('').map((char) {
      int code = char.codeUnitAt(0);
      if (code < 65 || code > 90) return ''; // Skip non A-Z
      int x = code - 65;
      int encrypted = (a * x + b) % m;
      return String.fromCharCode(encrypted + 65);
    }).join();
  }

  String decryptText(String ciphertext) {
    final aInv = _modInverse(a, m);
    return ciphertext.toUpperCase().split('').map((char) {
      int code = char.codeUnitAt(0);
      if (code < 65 || code > 90) return '';
      int y = code - 65;
      int decrypted = (aInv * (y - b + m)) % m;
      return String.fromCharCode(decrypted + 65);
    }).join();
  }

  int _gcd(int x, int y) {
    while (y != 0) {
      int temp = y;
      y = x % y;
      x = temp;
    }
    return x;
  }

  int _modInverse(int a, int m) {
    for (int i = 1; i < m; i++) {
      if ((a * i) % m == 1) return i;
    }
    throw Exception('Modular inverse does not exist.');
  }
}
