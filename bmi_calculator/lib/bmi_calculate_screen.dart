import 'dart:ui';
import 'package:bmi_calculator/bmi_result.dart';
import 'package:bmi_calculator/height_select_ruler_painter.dart';
import 'package:flutter/material.dart';

class BmiCalculateScreen extends StatefulWidget {
  final gender;
  BmiCalculateScreen({super.key, this.gender});

  @override
  State<BmiCalculateScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<BmiCalculateScreen> {
  int _height = 150;
  int _weight = 50;
  int _age = 25;

  void _showBmiResult(double bmi) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Background blur
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
            BmiResult(
              bmi: bmi,
              gender: widget.gender,
              age: _age,
              height: _height.toInt(),
              weight: _weight,
            ),
          ],
        );
      },
    );
  }

  void _calculateBmi() {
    double heightInMeter = _height / 100;
    double bmi = _weight / (heightInMeter * heightInMeter);
    _showBmiResult(bmi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "BMI",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Calculator",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  "Please modify the values",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Weight Card
                    _buildCard(
                      label: "Weight (KG)",
                      value: _weight.toString(),
                      onIncrement: () => setState(() => _weight++),
                      onDecrement:
                          () => setState(() => _weight > 1 ? _weight-- : _weight),
                    ),
                    // Age Card
                    _buildCard(
                      label: "Age",
                      value: _age.toString(),
                      onIncrement: () => setState(() => _age++),
                      onDecrement: () => setState(() => _age > 1 ? _age-- : _age),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Height Ruler
                _buildHeightRuler(),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _calculateBmi,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(),
                    child: Center(
                      child: const Text(
                        "Calculate",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showManualEntryDialog({required String type}) {
    final TextEditingController controller = TextEditingController();

    if (type.contains("Height")) {
      controller.text = _height.toString();
    } else if (type.contains("Weight")) {
      controller.text = _weight.toString();
    } else if (type.contains("Age")) {
      controller.text = _age.toString();
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Enter $type"),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: type),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 216, 161, 57),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (type.contains("Height")) {
                      // _height = double.tryParse(controller.text) ?? _height;
                      _height = int.tryParse(controller.text) ?? _height;
                    } else if (type.contains("Weight")) {
                      _weight = int.tryParse(controller.text) ?? _weight;
                    } else if (type.contains("Age")) {
                      _age = int.tryParse(controller.text) ?? _age;
                    }
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildCard({
    required String label,
    required String value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      height: 140,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color.fromARGB(255, 250, 245, 229),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 20)),
          GestureDetector(
            onTap: () => _showManualEntryDialog(type: label),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 216, 161, 57),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onDecrement,
                icon: const CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.remove,
                    size: 30,
                    color: Color.fromARGB(255, 216, 161, 57),
                  ),
                ),
              ),
              IconButton(
                onPressed: onIncrement,
                icon: const CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: Color.fromARGB(255, 216, 161, 57),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeightRuler() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color.fromARGB(255, 250, 245, 229),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Height (CM)",
            style: TextStyle(color: Colors.grey, fontSize: 20),
          ),
          GestureDetector(
            onTap: () => _showManualEntryDialog(type: "Height (CM)"),
            child: Text(
              _height.toInt().toString(),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 216, 161, 57),
              ),
            ),
          ),

          Container(
            height: 80,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const int totalTicks = 21;
                const int intervals = totalTicks - 1;
                double spacing = constraints.maxWidth / intervals;

                double closestTickIndex = (_height / 340) * intervals;
                int nearestTickIndex = closestTickIndex.round();
                double pointerX = nearestTickIndex * spacing;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 30,
                      child: CustomPaint(
                        painter: HeightSelectRulerPainter(
                          currentHeight: _height.toDouble(),
                          width: constraints.maxWidth,
                        ),
                        size: Size(constraints.maxWidth, 40),
                      ),
                    ),
                    Positioned(
                      left: pointerX - 20,
                      top: 0,
                      child: const Icon(
                        Icons.arrow_drop_down,
                        size: 40,
                        color: Color.fromARGB(255, 216, 161, 57),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        height: 40,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.transparent,
                            inactiveTrackColor: Colors.transparent,
                            thumbColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 0,
                            ),
                            trackHeight: 0,
                          ),
                          child: Slider(
                            value: _height.toDouble(),
                            min: 0,
                            max: 340,
                            divisions: 220,
                            onChanged: (value) {
                              setState(() {
                                _height = value.toInt();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

