import 'package:encryption_app/row_column_transposition.dart';
import 'package:flutter/material.dart';

class RowColumnCipherScreen extends StatefulWidget {
  const RowColumnCipherScreen({super.key});

  @override
  State<RowColumnCipherScreen> createState() => _RowColumnCipherScreenState();
}

class _RowColumnCipherScreenState extends State<RowColumnCipherScreen> {
  final _textController = TextEditingController();
  final _keyController = TextEditingController();
  List<List<String>> _originalMatrix = [];
  List<List<String>> _reorderedMatrix = [];
  String _rowCipher = '';
  String _columnCipher = '';
  bool _hasResult = false;

  void _encrypt() {
    final text = _textController.text;
    final key = _keyController.text;

    if (text.isEmpty || key.isEmpty) return;

    final originalMatrix =
        RowColumnTransposition.generateMatrix(text, key);
    final reorderedMatrix =
        RowColumnTransposition.reorderColumns(originalMatrix, key);

    final rowCipher = RowColumnTransposition.encryptRowWise(reorderedMatrix);
    final colCipher = RowColumnTransposition.encryptColumnWise(reorderedMatrix);

    setState(() {
      _originalMatrix = originalMatrix;
      _reorderedMatrix = reorderedMatrix;
      _rowCipher = rowCipher;
      _columnCipher = colCipher;
      _hasResult = true;
    });
  }

  Widget _buildMatrix(List<List<String>> matrix, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 10),
        Table(
          border: TableBorder.all(color: Colors.white24),
          defaultColumnWidth: const FixedColumnWidth(40.0),
          children: matrix
              .map((row) => TableRow(
                    children: row
                        .map((cell) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(cell,
                                      style:
                                          const TextStyle(color: Colors.white))),
                            ))
                        .toList(),
                  ))
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _keyController,
                decoration: InputDecoration(
                  labelText: 'Numeric Key (e.g., 41532)',
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.blueGrey.shade900.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _textController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Plain Text',
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.blueGrey.shade900.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _encrypt,
                child: const Text('Encrypt'),
              ),
              const SizedBox(height: 20),
              if (_hasResult) _buildMatrix(_originalMatrix, 'Original Matrix'),
              if (_hasResult) ...[
                const SizedBox(height: 20),
                _buildMatrix(_reorderedMatrix, 'Reordered Matrix (Based on Key)'),
                const SizedBox(height: 20),
                Text('Row-wise Cipher Text:\n$_rowCipher',
                    style: const TextStyle(color: Colors.lightGreenAccent)),
                const SizedBox(height: 10),
                Text('Column-wise Cipher Text:\n$_columnCipher',
                    style: const TextStyle(color: Colors.amberAccent)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
