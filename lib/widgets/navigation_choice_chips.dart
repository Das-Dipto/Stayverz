import 'package:flutter/material.dart';

class NavigationChoiceChips extends StatefulWidget {
  final Function(int) onSelected;
  final int initialSelected;

  const NavigationChoiceChips({
    Key? key,
    required this.onSelected,
    this.initialSelected = 0,
  }) : super(key: key);

  @override
  State<NavigationChoiceChips> createState() => _NavigationChoiceChipsState();
}

class _NavigationChoiceChipsState extends State<NavigationChoiceChips> {
  late int selectedIndex;

  final List<String> options = ['Full access', 'Semi access'];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                label,
                style: TextStyle(
                  color: selectedIndex == index
                      ? Colors.black
                      : Colors.black54,
                  fontSize: 12,
                  fontWeight: selectedIndex == index
                      ? FontWeight.w500
                      : FontWeight.w400,
                ),
              ),
              visualDensity: VisualDensity.standard,
              showCheckmark: false,
              selected: selectedIndex == index,
              onSelected: (bool selected) {
                if (selected) {
                  setState(() {
                    selectedIndex = index;
                  });
                  widget.onSelected(index);
                }
              },
              backgroundColor: Colors.white,
              selectedColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding:  EdgeInsets.symmetric(horizontal: 16),
              surfaceTintColor: Colors.black,
              pressElevation: 0,
              elevation: 0,
              side: BorderSide(
                color: selectedIndex == index
                    ? Colors.grey[300]!
                    : Colors.grey[200]!,
                width: 1,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
// Hello I am Tamim