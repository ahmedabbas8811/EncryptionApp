import 'package:encryption_app/rail_fence.dart';
import 'package:flutter/material.dart';

class RailFenceCipherScreen extends StatefulWidget {
  const RailFenceCipherScreen({super.key});

  @override
  State<RailFenceCipherScreen> createState() => _RailFenceCipherScreenState();
}

class _RailFenceCipherScreenState extends State<RailFenceCipherScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _railController = TextEditingController();
  String _resultText = '';
  bool _isEncrypting = true;
  bool _hasResult = false;
  List<List<String>> _matrix = [];

  void _processText() {
    final text = _textController.text;
    final rails = int.tryParse(_railController.text);

    if (text.isEmpty || rails == null || rails < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid text and rails (≥2)')),
      );
      return;
    }

    setState(() {
      _resultText = _isEncrypting
          ? 'Encrypted: ${RailFenceCipher.encrypt(text, rails)}'
          : 'Decrypted: ${RailFenceCipher.decrypt(text, rails)}';
      
      _matrix = RailFenceCipher.getMatrixForDisplay(text, rails, _isEncrypting);
      _hasResult = true;
    });
  }

  void _toggleMode() {
    setState(() {
      _isEncrypting = !_isEncrypting;
      if (_resultText.isNotEmpty) {
        _textController.text = _resultText
            .replaceAll('Encrypted: ', '')
            .replaceAll('Decrypted: ', '');
        _processText();
      }
    });
  }

  Widget _buildMatrixDisplay() {
    if (_matrix.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('Rail Fence Matrix:', 
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          constraints: BoxConstraints(
            maxHeight: 200, // Limit matrix height
          ),
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _matrix.map((row) {
                    return Row(
                      children: row.map((cell) {
                        return Container(
                          width: 30,
                          height: 30,
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            color: cell == '✱' 
                                ? Colors.blue.withOpacity(0.1)
                                : cell == '·' 
                                    ? Colors.transparent
                                    : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              cell,
                              style: TextStyle(
                                fontSize: 14,
                                color: cell == '✱' 
                                    ? Colors.blue
                                    : cell == '·' 
                                        ? Colors.grey
                                        : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rail Fence Cipher'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 150,
            ),
            child: Column(
              children: [
                TextField(
                  controller: _railController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Number of Rails',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.numbers),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _textController,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    labelText: _isEncrypting ? 'Text to encrypt' : 'Text to decrypt',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<bool>(
                        style: SegmentedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        segments: const [
                          ButtonSegment(
                            value: true,
                            label: Text('Encrypt'),
                            icon: Icon(Icons.lock, size: 18),
                          ),
                          ButtonSegment(
                            value: false,
                            label: Text('Decrypt'),
                            icon: Icon(Icons.lock_open, size: 18),
                          ),
                        ],
                        selected: {_isEncrypting},
                        onSelectionChanged: (newSelection) {
                          setState(() => _isEncrypting = newSelection.first);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _processText,
                        child: Text(_isEncrypting ? 'Encrypt' : 'Decrypt'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _resultText.isEmpty
                            ? 'Your ${_isEncrypting ? 'encrypted' : 'decrypted'} text will appear here...'
                            : _resultText,
                        style: TextStyle(
                          fontSize: 16,
                          color: _resultText.isEmpty 
                              ? Colors.grey 
                              : Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      if (_hasResult) _buildMatrixDisplay(),
                      if (_hasResult) ...[
                        const SizedBox(height: 12),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: _toggleMode,
                          child: Text(_isEncrypting ? 'Decrypt Result' : 'Encrypt Result'),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}