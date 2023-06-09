// ignore_for_file: use_build_context_synchronously
import 'package:budget_app/common/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/app_provider.dart';

class ExpenseMethodDialog extends StatefulWidget {
  const ExpenseMethodDialog({super.key});

  @override
  State<ExpenseMethodDialog> createState() => _ExpenseMethodDialogState();
}

List<String> expenseNameList = [
  "CASH",
  "CREDIT CARD",
  "DEBIT CARD",
  "MOBILE TRANSFER",
  "BANK TRANSFER"
];

class _ExpenseMethodDialogState extends State<ExpenseMethodDialog> {
  final _expenseDetailController = TextEditingController();
  final _expenseShortNameController = TextEditingController();

  bool isChecked = false;

  String initialValue = expenseNameList[0];
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final mainprovider = Provider.of<BackEndProvider>(context);
    Future createExpenseMethodCall() async {
      if (_expenseDetailController.text.isNotEmpty &&
          _expenseShortNameController.text.isNotEmpty &&
          _expenseShortNameController.text.length <= 4) {
        if (isChecked) {
          final defaultEmid = mainprovider.defaultExpenseMethod!.emid;
          await changeDefault(defaultEmid, false);
        }
        final provider = Provider.of<BackEndProvider>(context, listen: false);
        await createExpenseMethod(
            provider: provider,
            emname: initialValue,
            emdetail: _expenseDetailController.text,
            emisdefault: isChecked,
            emshortname: _expenseShortNameController.text);
        Navigator.of(context).pop();
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text("Please Enter the Necessary Details"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"))
            ],
          ),
        );
      }
    }

    return Dialog(
      child: Container(
        height: SizeConfig.height! * 45,
        width: SizeConfig.width! * 90,
        padding: const EdgeInsets.symmetric(horizontal: 36),
        decoration: const BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
                borderRadius: BorderRadius.circular(10),
                isDense: true,
                padding: EdgeInsets.zero,
                value: initialValue,
                underline: SizedBox(),
                elevation: 5,
                onChanged: (String? value) {
                  setState(() {
                    initialValue = value!;
                  });
                },
                items: expenseNameList.map((String value) {
                  return DropdownMenuItem(
                      onTap: () {}, value: value, child: Text(value));
                }).toList()),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: _expenseDetailController,
              decoration: const InputDecoration(
                hintText: "Expense Detail",
                isDense: true,
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(),
                hintStyle: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: _expenseShortNameController,
              decoration: const InputDecoration(
                hintText: "Expense Short Name (Max 4 characters)",
                isDense: true,
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(),
                hintStyle: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                const Text("Default Expense Method")
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: SizeConfig.width! * 100,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  minimumSize: Size.zero,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                onPressed: createExpenseMethodCall,
                child: const Text("Add"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
