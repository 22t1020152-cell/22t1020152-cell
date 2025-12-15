import 'package:flutter/material.dart';

class BmiForm extends StatefulWidget {
  const BmiForm({super.key});

  @override
  State<BmiForm> createState() => _BmiFormState();
}

class _BmiFormState extends State<BmiForm> {
  final _formKey = GlobalKey<FormState>();

  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  double? _bmi;
  String? _category;

  // Hàm tính BMI
  void _calculateBMI() {
    final height = double.parse(_heightController.text) / 100; // đổi cm → m
    final weight = double.parse(_weightController.text);

    final bmi = weight / (height * height);

    String category;
    if (bmi < 18.5) {
      category = "Thiếu cân";
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      category = "Bình thường";
    } else if (bmi >= 25 && bmi <= 29.9) {
      category = "Thừa cân";
    } else {
      category = "Béo phì";
    }

    setState(() {
      _bmi = bmi;
      _category = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tính BMI")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Chiều cao (cm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập chiều cao';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Chiều cao phải là số';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cân nặng (kg)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập cân nặng';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Cân nặng phải là số';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _calculateBMI();
                  }
                },
                child: const Text("Tính BMI"),
              ),

              const SizedBox(height: 20),

              if (_bmi != null)
                Text(
                  "BMI: ${_bmi!.toStringAsFixed(2)}\nPhân loại: $_category",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
