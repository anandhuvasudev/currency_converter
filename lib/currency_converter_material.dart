import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CurrencyConverterMaterial extends StatefulWidget {
  const CurrencyConverterMaterial({super.key});

  @override
  State<CurrencyConverterMaterial> createState() =>
      _CurrencyConverterMaterialState();
}

class _CurrencyConverterMaterialState extends State<CurrencyConverterMaterial> {
  // --- STATE VARIABLES ---
  final TextEditingController _amountController = TextEditingController();
  Map<String, String> _currencies = {};
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  bool _isLoading = true;
  bool _isConverting = false;
  String? _errorMessage;

  // Manual map for full currency names and country codes for emojis
  final Map<String, Map<String, String>> _currencyInfo = {
    'USD': {'name': 'US Dollar', 'code': 'US'},
    'EUR': {'name': 'Euro', 'code': 'EU'},
    'JPY': {'name': 'Japanese Yen', 'code': 'JP'},
    'GBP': {'name': 'Pound Sterling', 'code': 'GB'},
    'AUD': {'name': 'Australian Dollar', 'code': 'AU'},
    'CAD': {'name': 'Canadian Dollar', 'code': 'CA'},
    'CHF': {'name': 'Swiss Franc', 'code': 'CH'},
    'CNY': {'name': 'Chinese Yuan', 'code': 'CN'},
    'INR': {'name': 'Indian Rupee', 'code': 'IN'},
    'BRL': {'name': 'Brazilian Real', 'code': 'BR'},
    'RUB': {'name': 'Russian Ruble', 'code': 'RU'},
    'KRW': {'name': 'South Korean Won', 'code': 'KR'},
    'MXN': {'name': 'Mexican Peso', 'code': 'MX'},
    'SGD': {'name': 'Singapore Dollar', 'code': 'SG'},
    'NZD': {'name': 'New Zealand Dollar', 'code': 'NZ'},
    'ZAR': {'name': 'South African Rand', 'code': 'ZA'},
    'HKD': {'name': 'Hong Kong Dollar', 'code': 'HK'},
  };

  @override
  void initState() {
    super.initState();
    _fetchCurrencies();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // --- LOGIC AND HELPER FUNCTIONS ---

  String countryCodeToEmoji(String countryCode) {
    if (countryCode.length != 2) return '🏳️';
    final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  Future<void> _fetchCurrencies() async {
    const apiUrl = 'https://api.frankfurter.app/currencies';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          _currencies = Map<String, String>.from(jsonDecode(response.body));
          // Update the currency info map with any new currencies from the API
          _currencies.forEach((key, value) {
            _currencyInfo.putIfAbsent(key, () => {'name': value, 'code': ''});
          });
          _isLoading = false;
        });
      } else {
        throw 'Failed to load currencies.';
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch data. Check connection.';
        _isLoading = false;
      });
    }
  }

  Future<void> _convert() async {
    if (_amountController.text.isEmpty) {
      _showResultDialog('Please enter an amount.');
      return;
    }
    setState(() => _isConverting = true);
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showResultDialog('Please enter a valid amount.');
      setState(() => _isConverting = false);
      return;
    }

    final apiUrl =
        'https://api.frankfurter.app/latest?amount=$amount&from=$_fromCurrency&to=$_toCurrency';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final convertedAmount = data['rates'][_toCurrency];
        _showResultDialog(
          '${amount.toString()} $_fromCurrency = ${convertedAmount.toStringAsFixed(2)} $_toCurrency',
        );
      } else {
        throw 'Conversion failed.';
      }
    } catch (e) {
      _showResultDialog('Error during conversion. Please try again.');
    } finally {
      setState(() => _isConverting = false);
    }
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
  }

  void _showResultDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2E3B),
        title: const Text(
          'Conversion Result',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white70, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: Color(0xFF8ea7f1))),
          ),
        ],
      ),
    );
  }

  void _showCurrencySelection(bool isFromCurrency) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1F26),
      builder: (context) {
        return ListView.builder(
          itemCount: _currencies.keys.length,
          itemBuilder: (context, index) {
            final currencyCode = _currencies.keys.elementAt(index);
            final info =
                _currencyInfo[currencyCode] ??
                {'name': currencyCode, 'code': ''};

            return ListTile(
              leading: Text(
                info['code']!.isNotEmpty
                    ? countryCodeToEmoji(info['code']!)
                    : '🏳️',
                style: const TextStyle(fontSize: 30),
              ),
              title: Text(
                currencyCode,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                info['name']!,
                style: const TextStyle(color: Colors.white70),
              ),
              onTap: () {
                setState(() {
                  if (isFromCurrency) {
                    _fromCurrency = currencyCode;
                  } else {
                    _toCurrency = currencyCode;
                  }
                });
                Navigator.of(context).pop();
              },
            );
          },
        );
      },
    );
  }

  // --- UI BUILD METHODS ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1F26),
      appBar: AppBar(
        title: const Text(
          'Currency Converter',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1C1F26),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _errorMessage != null
          ? Center(
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 18),
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(), // Pushes content towards the center
                    _buildAmountField(),
                    const SizedBox(height: 20),
                    _buildCurrencySwapSection(),
                    const Spacer(), // Balances the centering
                    _buildConvertButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAmountField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2E3B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _amountController,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
        ],
        decoration: const InputDecoration.collapsed(
          hintText: '100',
          hintStyle: TextStyle(color: Colors.white38),
        ),
      ),
    );
  }

  Widget _buildCurrencySwapSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            _buildCurrencyCard(isFrom: true),
            const SizedBox(height: 16),
            _buildCurrencyCard(isFrom: false),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Color(0xFF1C1F26),
            shape: BoxShape.circle,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF2A2E3B),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.swap_vert, color: Colors.white70),
              onPressed: _swapCurrencies,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyCard({required bool isFrom}) {
    final currencyCode = isFrom ? _fromCurrency : _toCurrency;
    final info = _currencyInfo[currencyCode] ?? {'name': 'Unknown', 'code': ''};

    return InkWell(
      onTap: () => _showCurrencySelection(isFrom),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2E3B),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(
              info['code']!.isNotEmpty
                  ? countryCodeToEmoji(info['code']!)
                  : '🏳️',
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currencyCode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  info['name']!,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConvertButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isConverting ? null : _convert,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF35415E),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isConverting
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : const Text(
                'CONVERT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
