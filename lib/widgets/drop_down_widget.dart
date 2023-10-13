import 'package:budget_app/common/screen_size.dart';
import 'package:budget_app/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({super.key});

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  @override
  void initState() {
    super.initState();
  }

  // int index = 0;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    int? index = provider.selectedBudgetIndex;
    final provider2 = Provider.of<BackEndProvider>(context, listen: false);

    List<Map<String, dynamic>> list = [];

    ///Only shows latest 12 budgets
    int length = provider.budget!.budgets.length < 12
        ? provider.budget!.budgets.length
        : 12;

    for (int i = 0; i < length; i++) {
      list.add({
        "budgetname": provider.budget!.budgets[i].budgetname,
        "budgetid": provider.budget!.budgets[i].budgetid
      });
    }

    Map<String, dynamic> dropdownValue = list[index!];
    return DropdownButton<Map<String, dynamic>>(
      menuMaxHeight: SizeConfig.height! * 27.5,
      borderRadius: BorderRadius.circular(10),
      value: dropdownValue,
      isExpanded: SizeConfig.screenWidth! > tabWidth ? false : true,
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
      onChanged: (Map<String, dynamic>? value) {
        int selectedValueIndex = list.indexOf(value as Map<String, dynamic>);
        print(selectedValueIndex);
        // ignore: unnecessary_cast
        provider.setSelectedBudget(value['budgetname'] as String);

        provider.setSelectedIndex(selectedValueIndex);
        getTotal(provider2, value['budgetname'], selectedValueIndex);
        setState(() {
          index = selectedValueIndex;
        });
      },
      underline: Container(),
      items: list.map<DropdownMenuItem<Map<String, dynamic>>>(
          (Map<String, dynamic> value) {
        return DropdownMenuItem<Map<String, dynamic>>(
          value: value,
          child: Container(
            width: SizeConfig.screenWidth! > tabWidth
                ? null
                : SizeConfig.width! * 66,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            padding: SizeConfig.screenWidth! > tabWidth
                ? const EdgeInsets.only(right: 12)
                : null,
            child: Text(
              value['budgetname'],
              overflow: TextOverflow.ellipsis,
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
