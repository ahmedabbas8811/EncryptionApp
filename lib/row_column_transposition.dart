class RowColumnTransposition {
  static String cleanText(String text) {
    return text.replaceAll(RegExp(r'\s+'), '').toUpperCase();
  }

  static List<List<String>> generateMatrix(String text, String key) {
    text = cleanText(text);
    int cols = key.length;
    int rows = (text.length / cols).ceil();
    int totalLength = rows * cols;
    text = text.padRight(totalLength, 'X');

    List<List<String>> matrix = [];
    int k = 0;
    for (int i = 0; i < rows; i++) {
      List<String> row = [];
      for (int j = 0; j < cols; j++) {
        row.add(text[k++]);
      }
      matrix.add(row);
    }
    return matrix;
  }

  static List<List<String>> reorderColumns(
      List<List<String>> matrix, String key) {
    int cols = key.length;
    List<int> order = List.generate(cols, (i) => i);
    order.sort((a, b) => key[a].compareTo(key[b]));

    List<List<String>> transposed =
        List.generate(matrix.length, (_) => List.filled(cols, ''));

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < matrix.length; j++) {
        transposed[j][order[i]] = matrix[j][i];
      }
    }
    return transposed;
  }

  static String encryptRowWise(List<List<String>> matrix) {
    return matrix.expand((row) => row).join();
  }

  static String encryptColumnWise(List<List<String>> matrix) {
    String result = '';
    for (int i = 0; i < matrix[0].length; i++) {
      for (int j = 0; j < matrix.length; j++) {
        result += matrix[j][i];
      }
    }
    return result;
  }

  // Decryption methods
  static List<List<String>> generateDecryptionMatrix(
      String text, String key, bool rowWise) {
    text = cleanText(text);
    int cols = key.length;
    int rows = (text.length / cols).ceil();
    text = text.padRight(rows * cols, 'X');

    List<List<String>> matrix = [];
    if (rowWise) {
      int k = 0;
      for (int i = 0; i < rows; i++) {
        matrix.add(text.substring(k, k + cols).split(''));
        k += cols;
      }
    } else {
      matrix = List.generate(rows, (_) => List.filled(cols, ''));
      int k = 0;
      for (int i = 0; i < cols; i++) {
        for (int j = 0; j < rows; j++) {
          matrix[j][i] = text[k++];
        }
      }
    }
    return matrix;
  }

  static List<List<String>> orderColumnsByKey(
      List<List<String>> matrix, String key) {
    List<int> order = List.generate(key.length, (i) => i);
    order.sort((a, b) => key[a].compareTo(key[b]));

    List<List<String>> ordered =
        List.generate(matrix.length, (_) => List.filled(key.length, ''));
    for (int newCol = 0; newCol < key.length; newCol++) {
      int originalCol = order[newCol];
      for (int row = 0; row < matrix.length; row++) {
        ordered[row][newCol] = matrix[row][originalCol];
      }
    }
    return ordered;
  }

  static String decryptRowWise(List<List<String>> matrix) =>
      matrix.expand((row) => row).join();
  static String decryptColumnWise(List<List<String>> matrix) =>
      decryptRowWise(matrix);
}
