import 'package:encryption_app/rsa.dart';
import 'package:flutter/material.dart';

class RSAScreen extends StatefulWidget {
  const RSAScreen({super.key});

  @override
  State<RSAScreen> createState() => _RSAScreenState();
}

class _RSAScreenState extends State<RSAScreen> {
  final TextEditingController _pController = TextEditingController();
  final TextEditingController _qController = TextEditingController();
  final TextEditingController _eController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String _resultText = '';
  bool _isEncrypting = true;
  bool _hasResult = false;

  RSA? _rsa;
  String _keyInfo = '';

  void _processRSA() {
    final p = int.tryParse(_pController.text);
    final q = int.tryParse(_qController.text);
    final e = int.tryParse(_eController.text);
    final message = int.tryParse(_messageController.text);

    if (p == null || q == null || e == null || message == null) {
      setState(() {
        _resultText = 'Please enter valid numbers in all fields.';
        _hasResult = true;
      });
      return;
    }

    try {
      _rsa = RSA(p: p, q: q, e: e);
      final result = _isEncrypting
          ? 'Encrypted: ${_rsa!.encrypt(message)}'
          : 'Decrypted: ${_rsa!.decrypt(message)}';

      setState(() {
        _keyInfo =
            'Public Key: ${_rsa!.publicKey}\nPrivate Key: ${_rsa!.privateKey}';
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
      _processRSA();
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
              _buildNumberField(_pController, 'Enter Prime p'),
              const SizedBox(height: 10),
              _buildNumberField(_qController, 'Enter Prime q'),
              const SizedBox(height: 10),
              _buildNumberField(_eController, 'Enter Public Exponent e'),
              const SizedBox(height: 10),
              _buildNumberField(
                _messageController,
                _isEncrypting ? 'Number to Encrypt' : 'Number to Decrypt',
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
                    onPressed: _processRSA,
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
                    if (_keyInfo.isNotEmpty) ...[
                      Text(_keyInfo, style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 12),
                    ],
                    Text(
                      _resultText.isEmpty
                          ? 'Your ${_isEncrypting ? 'encrypted' : 'decrypted'} number will appear here...'
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
}
