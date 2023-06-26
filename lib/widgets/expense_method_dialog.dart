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
  "CREDIT CARD",
  "DEBIT CARD",
  "MOBILE TRANSFER",
  "BANK TRANSFER"
];

class _ExpenseMethodDialogState extends State<ExpenseMethodDialog> {
  final _expenseDetailController = TextEditingController();
  final _expenseShortNameController = TextEditingController();

  bool isChecked = false;
  int nameLength = 0;
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
          final provider = Provider.of<BackEndProvider>(context, listen: false);
          await changeDefault(defaultEmid, false, provider);
        }
        final provider = Provider.of<BackEndProvider>(context, listen: false);
        await createExpenseMethod(
            provider: provider,
            emname: initialValue,
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
      insetPadding: EdgeInsets.zero,
      child: Container(
        height: SizeConfig.height! * 65,
        width: SizeConfig.width! * 90,
        padding: const EdgeInsets.symmetric(horizontal: 36),
        decoration: const BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Create Expense Method",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(
              height: 26,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text("Expense Type : ",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 2,
                  child: PopupMenuButton<String>(
                    offset: const Offset(0, 24),
                    itemBuilder: (context) {
                      return expenseNameList.map((str) {
                        return PopupMenuItem(
                          value: str,
                          child: Text(str),
                        );
                      }).toList();
                    },
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          initialValue,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: initialValue.length > 14 ? 12 : 14),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                    onSelected: (value) {
                      setState(() {
                        initialValue = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text("Expense Detail : ",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  flex: 2,
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    // width: SizeConfig.width! * 40,
                    child: TextField(
                      controller: _expenseDetailController,
                      decoration: const InputDecoration(
                        // hintText: "Expense Detail",
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text("Short Name : ",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  flex: 2,
                  // ignore: sized_box_for_whitespace
                  child: Container(
                    width: SizeConfig.width! * 40,
                    child: TextFormField(
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
                        suffixStyle:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                        counterText: "",
                        counterStyle: const TextStyle(
                          fontSize: 10,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
              child: Divider(),
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
                const Text("Make this as default")
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
