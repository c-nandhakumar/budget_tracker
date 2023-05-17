import 'package:budget_app/common/screen_size.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:http/http.dart" as http;

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({super.key});

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

// const List<String> list = <String>[
//   'Home Budget',
//   'Work Budget',
//   'Personal Budget'
// ];

class _DropDownWidgetState extends State<DropDownWidget> {
  // List<String>? list;
  // Future<Budget>? budgetData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // int index = 0;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    int? index = provider.selectedBudgetIndex;
    final provider2 = Provider.of<BackEndProvider>(context, listen: false);

    List<String> list = [...provider.budget!.budgets.map((e) => e.budgetname)];

    String dropdownValue = list[index!];
    return DropdownButton<String>(
      menuMaxHeight: SizeConfig.height! * 27.5,
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
        int selectedValueIndex = list.indexOf(value as String);
        provider.setSelectedBudget(value as String);

        provider.setSelectedIndex(selectedValueIndex);
        getTotal(provider2, value, selectedValueIndex);
        setState(() {
          index = selectedValueIndex;
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
