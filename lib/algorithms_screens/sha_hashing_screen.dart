import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class Sha256HashScreen extends StatefulWidget {
  const Sha256HashScreen({super.key});

  @override
  State<Sha256HashScreen> createState() => _Sha256HashScreenState();
}

class _Sha256HashScreenState extends State<Sha256HashScreen> {
  final _inputController = TextEditingController();
  String _hashedText = '';
  bool _hasResult = false;

  void _hashText() {
    final input = _inputController.text.trim();
    if (input.isEmpty) return;

    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);

    setState(() {
      _hashedText = digest.toString();
      _hasResult = true;
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
                controller: _inputController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Text to hash',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.blueGrey.shade900.withOpacity(0.5),
                  prefixIcon: Icon(Icons.text_fields, color: Colors.blueAccent.shade200),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _hashText,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Generate Hash'),
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
                      _hashedText.isEmpty
                          ? 'Your hashed text will appear here...'
                          : _hashedText,
                      style: TextStyle(
                        color: _hashedText.isEmpty ? Colors.blueGrey.shade500 : Colors.lightGreenAccent,
                      ),
                    ),
                    if (_hasResult) ...[
                      const SizedBox(height: 15),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _inputController.text = '';
                            _hashedText = '';
                            _hasResult = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blueAccent,
                          side: BorderSide(color: Colors.blueAccent.shade200),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.clear_all, size: 18),
                            SizedBox(width: 8),
                            Text('Clear All'),
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