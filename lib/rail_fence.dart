class RailFenceCipher {
  /// Encrypts the given text using Rail Fence Cipher
  static String encrypt(String text, int rails) {
    final matrix = _buildEmptyMatrix(rails, text.length);
    final filledMatrix = _fillEncryptionMatrix(matrix, text);
    return _readCipherFromMatrix(filledMatrix);
  }

  /// Decrypts the given cipher using Rail Fence Cipher
  static String decrypt(String cipher, int rails) {
    final placeholderMatrix = _buildPlaceholderMatrix(rails, cipher.length);
    final filledMatrix = _fillDecryptionMatrix(placeholderMatrix, cipher);
    return _readPlaintextFromMatrix(filledMatrix);
  }

  /// Returns the encryption/decryption matrix for visualization
  static List<List<String>> getMatrixForDisplay(String text, int rails, bool isEncrypting) {
    if (isEncrypting) {
      final matrix = _buildEmptyMatrix(rails, text.length);
      return _fillEncryptionMatrix(matrix, text);
    } else {
      final matrix = _buildPlaceholderMatrix(rails, text.length);
      return _fillDecryptionMatrix(matrix, text);
    }
  }

  // ========== PRIVATE HELPER METHODS ========== //

  static List<List<String>> _buildEmptyMatrix(int rows, int cols) {
    return List.generate(rows, (_) => List.filled(cols, '·'));
  }

  static List<List<String>> _fillEncryptionMatrix(List<List<String>> matrix, String text) {
    bool dirDown = false;
    int row = 0, col = 0;

    for (int i = 0; i < text.length; i++) {
      if (row == 0 || row == matrix.length - 1) {
        dirDown = !dirDown;
      }

      matrix[row][col] = text[i];
      col++;

      dirDown ? row++ : row--;
    }

    return matrix;
  }

  static List<List<String>> _buildPlaceholderMatrix(int rows, int cols) {
    return List.generate(rows, (_) => List.filled(cols, '·'));
  }

  static List<List<String>> _fillDecryptionMatrix(List<List<String>> matrix, String cipher) {
    // First pass: Mark the rail positions
    bool dirDown = false;
    int row = 0, col = 0;

    for (int i = 0; i < cipher.length; i++) {
      if (row == 0) dirDown = true;
      if (row == matrix.length - 1) dirDown = false;

      matrix[row][col] = '✱'; // Placeholder
      col++;

      dirDown ? row++ : row--;
    }

    // Second pass: Fill with cipher characters
    int cipherIndex = 0;
    for (int r = 0; r < matrix.length; r++) {
      for (int c = 0; c < matrix[r].length; c++) {
        if (matrix[r][c] == '✱') {
          matrix[r][c] = cipher[cipherIndex++];
        }
      }
    }

    return matrix;
  }

  static String _readCipherFromMatrix(List<List<String>> matrix) {
    String result = '';
    for (var row in matrix) {
      for (var char in row) {
        if (char != '·') {
          result += char;
        }
      }
    }
    return result;
  }

  static String _readPlaintextFromMatrix(List<List<String>> matrix) {
    String result = '';
    bool dirDown = false;
    int row = 0, col = 0;

    for (int i = 0; i < matrix[0].length; i++) {
      if (row == 0) dirDown = true;
      if (row == matrix.length - 1) dirDown = false;

      if (matrix[row][col] != '·' && matrix[row][col] != '✱') {
        result += matrix[row][col];
      }
      col++;

      dirDown ? row++ : row--;
    }

    return result;
  }
}