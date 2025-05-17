import 'package:flutter/material.dart';
import '../vigenere_cipher.dart'; 
class VigenereCipherScreen extends StatefulWidget {
  const VigenereCipherScreen({super.key});

  @override
  State<VigenereCipherScreen> createState() => _VigenereCipherScreenState();
}

class _VigenereCipherScreenState extends State<VigenereCipherScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  String _resultText = '';
  bool _isEncrypting = true;
  bool _hasResult = false;

  void _processText() {
  final text = _textController.text.trim();
  final key = _keyController.text.trim();

  if (text.isEmpty || key.isEmpty) {
    setState(() {
      _resultText = 'Please enter both text and key.';
      _hasResult = false;
    });
    return;
  }

  if (!RegExp(r'^[a-zA-Z]+$').hasMatch(key)) {
    setState(() {
      _resultText = 'Error: Key must contain only letters (A-Z, a-z).';
      _hasResult = false;
    });
    return;
  }

  setState(() {
    _resultText = _isEncrypting
        ? 'Encrypted: ${VigenereCipher.encrypt(text, key)}'
        : 'Decrypted: ${VigenereCipher.decrypt(text, key)}';
    _hasResult = true;
  });
}

  void _toggleMode() {
    setState(() {
      _isEncrypting = !_isEncrypting;
      _textController.text =
          _resultText.replaceAll('Encrypted: ', '').replaceAll('Decrypted: ', '');
      _processText();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _keyController,
                decoration: InputDecoration(
                  labelText: 'Enter Key',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.blueGrey.shade900.withOpacity(0.5),
                  prefixIcon: Icon(Icons.key, color: Colors.blueAccent.shade200),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _textController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: _isEncrypting ? 'Text to encrypt' : 'Text to decrypt',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.blueGrey.shade900.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SegmentedButton(
                      segments: const [
                        ButtonSegment(value: true, label: Text('Encrypt'), icon: Icon(Icons.lock)),
                        ButtonSegment(value: false, label: Text('Decrypt'), icon: Icon(Icons.lock_open)),
                      ],
                      selected: {_isEncrypting},
                      onSelectionChanged: (newSelection) {
                        setState(() => _isEncrypting = newSelection.first);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _processText,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(_isEncrypting ? 'Encrypt' : 'Decrypt'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade800.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blueGrey.shade700),
                ),
                child: Column(
                  children: [
                    Text(
                      _resultText.isEmpty
                          ? 'Your ${_isEncrypting ? 'encrypted' : 'decrypted'} text will appear here...'
                          : _resultText,
                      style: TextStyle(
                        color: _resultText.isEmpty ? Colors.blueGrey.shade500 : Colors.white,
                      ),
                    ),
                    if (_hasResult) ...[
                      const SizedBox(height: 15),
                      OutlinedButton(
                        onPressed: _toggleMode,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blueAccent,
                          side: BorderSide(color: Colors.blueAccent.shade200),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_isEncrypting ? Icons.lock_open : Icons.lock, size: 18),
                            const SizedBox(width: 8),
                            Text(_isEncrypting ? 'Decrypt Now' : 'Encrypt Now'),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
