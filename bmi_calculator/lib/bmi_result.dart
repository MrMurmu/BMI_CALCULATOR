import 'package:flutter/material.dart';
import 'package:bmi_calculator/bmi_result_ruler_painter.dart';

class BmiResult extends StatelessWidget {
  final double bmi;
  final int weight;
  final int height;
  final int age;
  final String gender;

  BmiResult({
    super.key,
    required this.bmi,
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
  });

  String _getBmiLabel(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  Color _getBmiColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  double _mapBmiToRulerValue(double bmi) {
    const double min = 10;
    const double max = 40;
    return ((bmi - min) / (max - min) * 340).clamp(0, 340);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double rulerWidth = screenWidth * 0.85;
    final double mappedValue = _mapBmiToRulerValue(bmi);
    final String label = _getBmiLabel(bmi);
    final Color color = _getBmiColor(bmi);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Your BMI:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                bmi.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              // Text(
              //   label,
              //   style: TextStyle(
              //     fontSize: 20,
              //     fontWeight: FontWeight.w600,
              //     color: color,
              //   ),
              // ),
              const SizedBox(height: 20),

              // BMI Ruler
              SizedBox(
                width: rulerWidth,
                height: 50,
                child: CustomPaint(
                  painter: BmiResultRulerPainter(
                    currentBmiPosition: mappedValue,
                    width: rulerWidth,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Info Row
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 20,
                runSpacing: 10,
                children: [
                  _infoCard("Weight", "$weight kg", color),
                  _infoCard("Height", "$height cm", color),
                  _infoCard("Age", "$age", color),
                  _infoCard("Gender", gender.isEmpty ? "N/A" : gender, color),
                ],
              ),

              const SizedBox(height: 20),

              // Healthy range info
              Column(
                children: [
                  const Text(
                    "Healthy weight for your height:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "53.5 kg - 72.3 kg",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Close",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
