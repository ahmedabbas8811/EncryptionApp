class CaesarCipher {
  static String encrypt(String plaintext, int shift) {
    StringBuffer ciphertext = StringBuffer();
    
    for (int i = 0; i < plaintext.length; i++) {
      int charCode = plaintext.codeUnitAt(i);
      
      if (charCode >= 65 && charCode <= 90) { // Uppercase letters
        ciphertext.writeCharCode((charCode - 65 + shift) % 26 + 65);
      } 
      else if (charCode >= 97 && charCode <= 122) { // Lowercase letters
        ciphertext.writeCharCode((charCode - 97 + shift) % 26 + 97);
      } 
      else { // Non-alphabetic characters
        ciphertext.writeCharCode(charCode);
      }
    }
    
    return ciphertext.toString();
  }

  static String decrypt(String ciphertext, int shift) {
    return encrypt(ciphertext, 26 - shift); // Decrypting is just encrypting with inverse shift
  }
}