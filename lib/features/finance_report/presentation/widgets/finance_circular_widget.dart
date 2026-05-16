import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CircularProgressWidget extends StatelessWidget {
  final double progress;
  final Color color;
  final String title;
  final String year;

  const CircularProgressWidget({
    super.key,
    required this.progress,
    required this.color,
    required this.title,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 1, color: Colors.black12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              const Gap(10),
              Text(
                year,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
// Hello I am Tamim