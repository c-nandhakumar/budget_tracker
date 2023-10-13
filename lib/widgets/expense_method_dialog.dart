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

List<dynamic> expenseNameList = [
  {"name": "Credit Card", "icon": const Icon(Icons.credit_card)},
  {"name": "Debit Card", "icon": const Icon(Icons.view_compact_alt_rounded)},
  {
    "name": "Mobile Transfer",
    "icon": const Icon(Icons.mobile_screen_share_rounded)
  },
  {"name": "Bank Transfer", "icon": const Icon(Icons.account_balance)},
];

class _ExpenseMethodDialogState extends State<ExpenseMethodDialog> {
  final _expenseDetailController = TextEditingController();
  final _expenseShortNameController = TextEditingController();

  bool isChecked = false;
  int nameLength = 0;
  dynamic initialValue = expenseNameList[0];
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
          final provider = Provider.of<BackEndProvider>(context, listen: false);
          await changeDefault(defaultEmid, false, provider);
        }
        final provider = Provider.of<BackEndProvider>(context, listen: false);
        await createExpenseMethod(
            provider: provider,
            emname: initialValue['name'],
            emdetail: _expenseDetailController.text,
            emisdefault: isChecked,
            emshortname: _expenseShortNameController.text.toUpperCase());
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
      insetPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.screenWidth! > tabWidth ? 120 : 36),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Create Expense Method",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 26,
            ),
            Row(
              children: [
                Text("Expense Type : ",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                const SizedBox(
                  width: 4,
                ),
                PopupMenuButton<dynamic>(
                  offset: const Offset(0, 24),
                  itemBuilder: (context) {
                    return expenseNameList.map((str) {
                      return PopupMenuItem(
                        value: str,
                        child: Row(
                          children: [
                            str['icon'],
                            const SizedBox(
                              width: 6,
                            ),
                            Text(str['name']),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          initialValue['name'],
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: initialValue['name'].length > 14
                                      ? 12
                                      : 14,
                                  color: Colors.white),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  onSelected: (value) {
                    setState(() {
                      initialValue = value;
                    });
                  },
                ),
              ],
            ),
            Divider(
              color: Colors.grey[600],
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _expenseDetailController,
              maxLength: 20,
              decoration: const InputDecoration(
                hintText: "Expense Detail",
                counterText: "",
                isDense: true,
                hintStyle: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              maxLength: 4,
              onChanged: (value) {
                setState(() {
                  nameLength = value.length;
                });
              },
              controller: _expenseShortNameController,
              decoration: InputDecoration(
                // hintText: "Expense Short Name (Max 4 characters)",
                suffixText: "$nameLength/4",
                hintText: "Short Name",
                suffixStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                counterText: "",
                counterStyle: const TextStyle(
                  fontSize: 10,
                ),
                isDense: true,

                hintStyle: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  child: Checkbox(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                ),
                const Text("Make this as default")
              ],
            ),
            const SizedBox(
              height: 18,
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
