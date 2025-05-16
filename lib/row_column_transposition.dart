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

  static List<List<String>> reorderColumns(List<List<String>> matrix, String key) {
    int cols = key.length;
    List<int> order = List.generate(cols, (i) => i);
    order.sort((a, b) => key[a].compareTo(key[b]));

    List<List<String>> transposed = List.generate(matrix.length, (_) => List.filled(cols, ''));

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
}
