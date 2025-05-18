import 'dart:math';

class RSA {
  int? p, q, n, phi, e, d;
  late int k;
  late Map<String, dynamic> publicKey;
  late Map<String, dynamic> privateKey;

  RSA({required this.p, required this.q, required this.e}) {
    _initialize();
  }

  void _initialize() {
    if (!_areRelativelyPrime(p!, q!)) {
      throw ArgumentError('p and q must be relatively prime');
    }

    n = p! * q!;
    phi = (p! - 1) * (q! - 1);

    if (_gcd(e!, phi!) != 1) {
      throw ArgumentError('e must be relatively prime to φ(n)');
    }

    d = _calculateD(e!, phi!);
    publicKey = {'e': e, 'n': n};
    privateKey = {'d': d, 'n': n};
  }

  int encrypt(int plaintext) {
    return _modularExponentiation(plaintext, e!, n!);
  }

  int decrypt(int ciphertext) {
    return _modularExponentiation(ciphertext, d!, n!);
  }

  /// Private helper methods

  int _gcd(int a, int b) {
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  bool _areRelativelyPrime(int a, int b) {
    return _gcd(a, b) == 1;
  }

  int _calculateD(int e, int phi) {
    k = 0;
    while (true) {
      int numerator = 1 + k * phi;
      if (numerator % e == 0) {
        return numerator ~/ e; // Integer division
      }
      k++;
    }
  }

  int _modularExponentiation(int base, int exponent, int mod) {
    int result = 1;
    base = base % mod;
    while (exponent > 0) {
      if (exponent % 2 == 1) {
        result = (result * base) % mod;
      }
      exponent = exponent >> 1;
      base = (base * base) % mod;
    }
    return result;
  }
}
