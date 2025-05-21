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
  final _cipherTextController = TextEditingController();
  List<List<String>> _originalMatrix = [];
  List<List<String>> _reorderedMatrix = [];
  List<List<String>> _decryptMatrix = [];
  List<List<String>> _decryptOrderedMatrix = [];
  String _cipherText = '';
  String _decryptedText = '';
  bool _hasResult = false;
  bool _hasDecryptResult = false;
  String _selectedMethod = 'Row-wise';
  String _selectedDecryptMethod = 'Row-wise';
  bool _showEncryptSection = true;

  void _encrypt() {
    final text = _textController.text;
    final key = _keyController.text;

    if (text.isEmpty || key.isEmpty) return;

    final originalMatrix = RowColumnTransposition.generateMatrix(text, key);
    final reorderedMatrix = RowColumnTransposition.reorderColumns(originalMatrix, key);

    String cipher = '';
    if (_selectedMethod == 'Row-wise') {
      cipher = RowColumnTransposition.encryptRowWise(reorderedMatrix);
    } else {
      cipher = RowColumnTransposition.encryptColumnWise(reorderedMatrix);
    }

    setState(() {
      _originalMatrix = originalMatrix;
      _reorderedMatrix = reorderedMatrix;
      _cipherText = cipher;
      _hasResult = true;
      _cipherTextController.text = cipher.replaceAll(' ', '');
    });
  }

  void _decrypt() {
    final cipherText = _cipherTextController.text;
    final key = _keyController.text;

    if (cipherText.isEmpty || key.isEmpty) return;

    bool rowWise = _selectedDecryptMethod == 'Row-wise';
    final decryptMatrix = RowColumnTransposition.generateDecryptionMatrix(
        cipherText, key, rowWise);
    final orderedMatrix = RowColumnTransposition.orderColumnsByKey(decryptMatrix, key);

    setState(() {
      _decryptMatrix = decryptMatrix;
      _decryptOrderedMatrix = orderedMatrix;
      _decryptedText = rowWise 
          ? RowColumnTransposition.decryptRowWise(orderedMatrix)
          : RowColumnTransposition.decryptColumnWise(orderedMatrix);
      _hasDecryptResult = true;
    });
  }

  Widget _buildMatrix(List<List<String>> matrix, String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(color: Colors.white70)),
      const SizedBox(height: 10),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Table(
            border: TableBorder.all(color: Colors.white24),
            defaultColumnWidth: const FixedColumnWidth(40.0),
            children: matrix
                .map((row) => TableRow(
                      children: row
                          .map((cell) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    cell,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ))
                          .toList(),
                    ))
                .toList(),
          ),
        ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showEncryptSection = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showEncryptSection
                          ? Colors.blueAccent
                          : Colors.blueGrey.shade800,
                    ),
                    child: const Text('Encrypt'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showEncryptSection = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_showEncryptSection
                          ? Colors.blueAccent
                          : Colors.blueGrey.shade800,
                    ),
                    child: const Text('Decrypt'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_showEncryptSection) ...[
                TextField(
                  controller: _keyController,
                  decoration: InputDecoration(
                    labelText: 'Key (e.g., KEY)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
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
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.blueGrey.shade900.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _selectedMethod,
                  items: ['Row-wise', 'Column-wise']
                      .map((method) => DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedMethod = value);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Encryption Method',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
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
                  _buildMatrix(
                      _reorderedMatrix, 'Reordered Matrix (Based on Key)'),
                  const SizedBox(height: 20),
                  Text(
                      '${_selectedMethod} Cipher Text:\n$_cipherText',
                      style: const TextStyle(color: Colors.lightGreenAccent)),
                ],
              ] else ...[
                TextField(
                  controller: _keyController,
                  decoration: InputDecoration(
                    labelText: 'Key (e.g., KEY)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.blueGrey.shade900.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _cipherTextController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Cipher Text',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.blueGrey.shade900.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _selectedDecryptMethod,
                  items: ['Row-wise', 'Column-wise']
                      .map((method) => DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedDecryptMethod = value);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Decryption Method',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.blueGrey.shade900.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _decrypt,
                  child: const Text('Decrypt'),
                ),
                const SizedBox(height: 20),
                if (_hasDecryptResult)
                  _buildMatrix(_decryptMatrix, 'Initial Cipher Matrix'),
                if (_hasDecryptResult) ...[
                  const SizedBox(height: 20),
                  _buildMatrix(_decryptOrderedMatrix,
                      'Columns Ordered by Sorted Key'),
                  const SizedBox(height: 20),
                  Text('Decrypted Text: $_decryptedText',
                      style: const TextStyle(color: Colors.lightGreenAccent)),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}