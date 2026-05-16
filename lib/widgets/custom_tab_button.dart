import 'package:flutter/material.dart';

class CustomTabButton extends StatelessWidget {
  final String? text;
  final bool isSelected;
  final VoidCallback? onTap;
  
  const CustomTabButton({
    super.key, 
    this.text, 
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: ShapeDecoration(
          color: isSelected ? Color(0xFFF15B25) : Colors.transparent,
          shape: RoundedRectangleBorder(
            side: isSelected ? BorderSide.none : BorderSide(
              width: 1,
              color: const Color(0xFFE0E0E0),
            ),
            borderRadius: BorderRadius.circular(8)
          ),
        ),
        constraints: BoxConstraints(
          minWidth: 60
        ),
        child: Text(
          text ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFFBABEC1),
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
        ),
      ),
    );
  }
}

// Hello I am Tamim