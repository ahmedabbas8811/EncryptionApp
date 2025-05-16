class VigenereCipher {
  static String encrypt(String plaintext, String key) {
    StringBuffer ciphertext = StringBuffer();
    int keyIndex = 0;
    
    for (int i = 0; i < plaintext.length; i++) {
      int charCode = plaintext.codeUnitAt(i);
      if (charCode >= 65 && charCode <= 90) { // Uppercase letters
        ciphertext.writeCharCode(
          ((charCode - 65 + key[keyIndex % key.length].toUpperCase().codeUnitAt(0) - 65) % 26) + 65
        );
        keyIndex++;
      } else if (charCode >= 97 && charCode <= 122) { // Lowercase letters
        ciphertext.writeCharCode(
          ((charCode - 97 + key[keyIndex % key.length].toLowerCase().codeUnitAt(0) - 97) % 26) + 97
        );
        keyIndex++;
      } else { // Non-alphabetic characters
        ciphertext.writeCharCode(charCode);
      }
    }
    return ciphertext.toString();
  }

  static String decrypt(String ciphertext, String key) {
    StringBuffer plaintext = StringBuffer();
    int keyIndex = 0;
    
    for (int i = 0; i < ciphertext.length; i++) {
      int charCode = ciphertext.codeUnitAt(i);
      if (charCode >= 65 && charCode <= 90) { // Uppercase letters
        plaintext.writeCharCode(
          ((charCode - 65 - (key[keyIndex % key.length].toUpperCase().codeUnitAt(0) - 65) + 26) % 26) + 65
        );
        keyIndex++;
      } else if (charCode >= 97 && charCode <= 122) { // Lowercase letters
        plaintext.writeCharCode(
          ((charCode - 97 - (key[keyIndex % key.length].toLowerCase().codeUnitAt(0) - 97) + 26) % 26) + 97
        );
        keyIndex++;
      } else { // Non-alphabetic characters
        plaintext.writeCharCode(charCode);
      }
    }
    return plaintext.toString();
  }
}
