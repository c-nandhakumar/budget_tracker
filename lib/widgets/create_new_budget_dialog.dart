// ignore_for_file: use_build_context_synchronously
import 'package:budget_app/common/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/app_provider.dart';

class CreateNewBudgetDialog extends StatefulWidget {
  final int status;
  const CreateNewBudgetDialog({required this.status, super.key});

  @override
  State<CreateNewBudgetDialog> createState() => _CreateNewBudgetDialogState();
}

class _CreateNewBudgetDialogState extends State<CreateNewBudgetDialog> {
  final _costcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final mainprovider = Provider.of<BackEndProvider>(context);
    Future createBudget() async {
      String budgetamount = _costcontroller.text;

      if (budgetamount.isNotEmpty) {
        final provider = Provider.of<BackEndProvider>(context, listen: false);
        await createInitialBudget(
            provider: provider,
            amount: int.parse(budgetamount),
            status: widget.status);
        Navigator.of(context).pop();

        String? budgetname;
        if (widget.status == 1) {
          budgetname = DateFormat('MMMM yyyy').format(DateTime.now());
        } else if (widget.status == 2) {
          var dateTime = DateTime.now();
          dateTime = DateTime(dateTime.year, dateTime.month + 1, dateTime.day,
              dateTime.hour, dateTime.minute, dateTime.second);
          budgetname = DateFormat('MMMM yyyy').format(dateTime);
        }
        await getBudgetData(provider);
        await getTotal(provider, budgetname!, provider.selectedBudgetIndex!);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text("Please Enter the budget name and amount"),
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
      // surfaceTintColor: Colors.white,
      // insetPadding: EdgeInsets.zero,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Enter budget amount",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                      height: 1.25,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.status == 2
                      ? "(for the next month)"
                      : "(for the current month)",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: const Color(0xFF808080),
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _costcontroller,
                  maxLength: 6,
                  decoration: InputDecoration(
                    hintText: "${dotenv.get("CURRENCY")}0",
                    isDense: true,
                    contentPadding: const EdgeInsets.all(8),
                    hintStyle: const TextStyle(fontSize: 14),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: SizeConfig.width! * 100,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                    ),
                    onPressed: createBudget,
                    child: const Text("Add"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
