import 'package:encryption_app/algorithms_screens/affine_cipher_screen.dart';
import 'package:encryption_app/algorithms_screens/one_time_pad_screen.dart';
import 'package:encryption_app/algorithms_screens/playfair_screen.dart';
import 'package:encryption_app/algorithms_screens/rail_fence_screen.dart';
import 'package:encryption_app/algorithms_screens/row_column_screen.dart';
import 'package:encryption_app/algorithms_screens/rsa_screen.dart';
import 'package:flutter/material.dart';
import 'package:encryption_app/algorithms_screens/caesar_cipher_screen.dart';
import 'package:encryption_app/algorithms_screens/viginere_cipher_screen.dart';

void main() {
  runApp(const EncryptionApp());
}

class EncryptionApp extends StatelessWidget {
  const EncryptionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure Cipher',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2A3F7B),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.blueGrey.shade900.withOpacity(0.7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(
              Colors.blueGrey.shade900.withOpacity(0.9),
            ),
            elevation: const WidgetStatePropertyAll(8),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Colors.blueAccent.shade200.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
      home: const EncryptionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class EncryptionScreen extends StatefulWidget {
  const EncryptionScreen({super.key});

  @override
  State<EncryptionScreen> createState() => _EncryptionScreenState();
}

class _EncryptionScreenState extends State<EncryptionScreen> {
  String _selectedAlgorithm = 'Caesar Cipher';

  @override
  Widget build(BuildContext context) {
    Widget algorithmWidget;

    switch (_selectedAlgorithm) {
      case 'Caesar Cipher':
        algorithmWidget = CaesarCipherScreen();
        break;
      case 'Vigenère Cipher':
        algorithmWidget = VigenereCipherScreen();
        break;
      case 'Playfair Cipher':
        algorithmWidget = PlayfairCipherScreen();
        break;
      case 'One-Time Pad':
        algorithmWidget = OneTimePadScreen();
        break;
      case 'Row & Column Transposition':
        algorithmWidget = const RowColumnCipherScreen();
        break;
      case 'Rail Fence Cipher':
        algorithmWidget = RailFenceCipherScreen();
        break;
      case 'RSA':
        algorithmWidget = RSAScreen();
        break;
      case 'Affine Cipher':
        algorithmWidget = AffineScreen();
        break;

      default:
        algorithmWidget = const Center(child: Text('Select an algorithm.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Cipher'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownMenu<String>(
              width: MediaQuery.of(context).size.width - 32,
              initialSelection: _selectedAlgorithm,
              dropdownMenuEntries: const [
                DropdownMenuEntry(
                  value: 'Caesar Cipher',
                  label: 'Caesar Cipher',
                  style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                ),
                DropdownMenuEntry(
                  value: 'Vigenère Cipher',
                  label: 'Vigenère Cipher',
                  style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                ),
                DropdownMenuEntry(
                  // Add Playfair Cipher to dropdown
                  value: 'Playfair Cipher',
                  label: 'Playfair Cipher',
                  style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                ),
                DropdownMenuEntry(
                  value: 'One-Time Pad',
                  label: 'One-Time Pad',
                  style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                ),
                DropdownMenuEntry(
                  value: 'Row & Column Transposition',
                  label: 'Row & Column Transposition',
                  style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                ),
                DropdownMenuEntry(
                  value: 'Rail Fence Cipher',
                  label: 'Rail Fence Cipher',
                  style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                ),
                DropdownMenuEntry(
                  value: 'RSA',
                  label: 'RSA',
                  style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                ),
                DropdownMenuEntry(
                  value: 'Affine Cipher',
                  label: 'Affine Cipher',
                  style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                ),
              ],
              onSelected: (value) {
                setState(() {
                  _selectedAlgorithm = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(child: algorithmWidget),
          ],
        ),
      ),
    );
  }
}
