import 'package:encryption_app/affine_cipher.dart';
import 'package:flutter/material.dart';

class AffineScreen extends StatefulWidget {
  const AffineScreen({super.key});

  @override
  State<AffineScreen> createState() => _AffineScreenState();
}

class _AffineScreenState extends State<AffineScreen> {
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _bController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String _resultText = '';
  bool _isEncrypting = true;
  bool _hasResult = false;

  void _processAffine() {
    final a = int.tryParse(_aController.text);
    final b = int.tryParse(_bController.text);
    final message = _messageController.text;

    if (a == null || b == null || message.isEmpty) {
      setState(() {
        _resultText = 'Please enter valid values in all fields.';
        _hasResult = true;
      });
      return;
    }

    try {
      final cipher = AffineCipher(a: a, b: b);
      final result = _isEncrypting
          ? 'Encrypted: ${cipher.encryptText(message)}'
          : 'Decrypted: ${cipher.decryptText(message)}';

      setState(() {
        _resultText = result;
        _hasResult = true;
      });
    } catch (e) {
      setState(() {
        _resultText = 'Error: ${e.toString()}';
        _hasResult = true;
      });
    }
  }

  void _toggleMode() {
    setState(() {
      _isEncrypting = !_isEncrypting;
      _messageController.text = _resultText
          .replaceAll('Encrypted: ', '')
          .replaceAll('Decrypted: ', '');
      _processAffine();
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
              _buildNumberField(_aController, 'Enter a (coprime with 26)'),
              const SizedBox(height: 10),
              _buildNumberField(_bController, 'Enter b'),
              const SizedBox(height: 10),
              _buildTextField(
                _messageController,
                _isEncrypting ? 'Text to Encrypt' : 'Text to Decrypt',
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
                      onSelectionChanged: (val) {
                        setState(() => _isEncrypting = val.first);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _processAffine,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _resultText.isEmpty
                          ? 'Your ${_isEncrypting ? 'encrypted' : 'decrypted'} message will appear here...'
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

  Widget _buildNumberField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.blueGrey.shade900.withOpacity(0.5),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.blueGrey.shade900.withOpacity(0.5),
      ),
    );
  }
}
