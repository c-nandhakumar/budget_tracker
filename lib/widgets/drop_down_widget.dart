import 'package:budget_app/common/screen_size.dart';
import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({super.key});

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

const List<String> list = <String>[
  'Home Budget',
  'Work Budget',
  'Personal Budget'
];

class _DropDownWidgetState extends State<DropDownWidget> {
  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      borderRadius: BorderRadius.circular(10),
      value: dropdownValue,
      isExpanded: true,
      icon: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(483)),
        padding: const EdgeInsets.all(5),
        constraints: const BoxConstraints(),
        // color: Colors.white,
        child: const Icon(
          Icons.keyboard_arrow_down_outlined,
          color: Colors.white,
        ),
      ),
      elevation: 16,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: Theme.of(context).colorScheme.tertiary,
          fontWeight: FontWeight.bold),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      underline: Container(),
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Container(
            width: SizeConfig.width! * 66,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }
}
