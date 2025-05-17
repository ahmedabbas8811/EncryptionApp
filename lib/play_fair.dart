import 'dart:collection';

class PlayfairCipher {
  // Generate 5x5 matrix using keyword
 static List<List<String>> generateMatrix(String keyword) {
  String alphabet = 'ABCDEFGHIKLMNOPQRSTUVWXYZ'; // 'J' is excluded
  LinkedHashSet<String> uniqueLetters = LinkedHashSet<String>();

  // Process keyword: treat J as I, uppercase, and skip duplicates
  for (int i = 0; i < keyword.length; i++) {
    String letter = keyword[i].toUpperCase();
    if (letter == 'J') letter = 'I';
    if (!uniqueLetters.contains(letter) && alphabet.contains(letter)) {
      uniqueLetters.add(letter);
    }
  }

  // Add remaining letters from the alphabet
  for (int i = 0; i < alphabet.length; i++) {
    String letter = alphabet[i];
    if (!uniqueLetters.contains(letter)) {
      uniqueLetters.add(letter);
    }
  }

  // Now build the matrix from exactly 25 characters
  List<List<String>> matrix = [];
  List<String> temp = [];

  for (String letter in uniqueLetters) {
    temp.add(letter);
    if (temp.length == 5) {
      matrix.add(List.from(temp));
      temp.clear();
    }
  }

  return matrix;
}



  // Preprocess text: uppercase, remove non-letters, replace J with I, and pad with 'X' if needed
  static String preprocessText(String text) {
    text = text.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '').replaceAll('J', 'I');
    if (text.length % 2 != 0) {
      text += 'X';
    }
    return text;
  }

  // Helper to find position of a character in matrix
  static List<int> findPosition(List<List<String>> matrix, String char) {
    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 5; col++) {
        if (matrix[row][col] == char) {
          return [row, col];
        }
      }
    }
    return [-1, -1]; // fallback
  }

  // Encrypt using Playfair cipher
  static String encrypt(String plaintext, String keyword) {
    List<List<String>> matrix = generateMatrix(keyword);
    String processedText = preprocessText(plaintext);
    StringBuffer ciphertext = StringBuffer();

    for (int i = 0; i < processedText.length; i += 2) {
      String a = processedText[i];
      String b = processedText[i + 1];
      List<int> pos1 = findPosition(matrix, a);
      List<int> pos2 = findPosition(matrix, b);

      if (pos1[0] == pos2[0]) {
        // Same row: shift right
        ciphertext.write(matrix[pos1[0]][(pos1[1] + 1) % 5]);
        ciphertext.write(matrix[pos2[0]][(pos2[1] + 1) % 5]);
      } else if (pos1[1] == pos2[1]) {
        // Same column: shift down
        ciphertext.write(matrix[(pos1[0] + 1) % 5][pos1[1]]);
        ciphertext.write(matrix[(pos2[0] + 1) % 5][pos2[1]]);
      } else {
        // Rectangle rule
        ciphertext.write(matrix[pos1[0]][pos2[1]]);
        ciphertext.write(matrix[pos2[0]][pos1[1]]);
      }
    }

    return ciphertext.toString();
  }

  // Decrypt using Playfair cipher
  static String decrypt(String ciphertext, String keyword) {
    ciphertext = ciphertext.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '').replaceAll('J', 'I');
    List<List<String>> matrix = generateMatrix(keyword);
    StringBuffer plaintext = StringBuffer();

    for (int i = 0; i < ciphertext.length; i += 2) {
      String a = ciphertext[i];
      String b = ciphertext[i + 1];
      List<int> pos1 = findPosition(matrix, a);
      List<int> pos2 = findPosition(matrix, b);

      if (pos1[0] == pos2[0]) {
        // Same row: shift left
        plaintext.write(matrix[pos1[0]][(pos1[1] - 1 + 5) % 5]);
        plaintext.write(matrix[pos2[0]][(pos2[1] - 1 + 5) % 5]);
      } else if (pos1[1] == pos2[1]) {
        // Same column: shift up
        plaintext.write(matrix[(pos1[0] - 1 + 5) % 5][pos1[1]]);
        plaintext.write(matrix[(pos2[0] - 1 + 5) % 5][pos2[1]]);
      } else {
        // Rectangle rule
        plaintext.write(matrix[pos1[0]][pos2[1]]);
        plaintext.write(matrix[pos2[0]][pos1[1]]);
      }
    }

    // Optional: remove padding 'X' if added during preprocessing
    String result = plaintext.toString();
    if (result.endsWith('X')) {
      result = result.substring(0, result.length - 1);
    }

    return result;
  }
}