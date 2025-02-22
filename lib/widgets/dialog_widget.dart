// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:budget_app/common/screen_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../provider/app_provider.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget({super.key});

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  final _namecontroller = TextEditingController();
  final _costcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final mainprovider = Provider.of<BackEndProvider>(context);
    Future createBudget() async {
      String budgetname = _namecontroller.text;
      String budgetamount = _costcontroller.text;
      String time = DateTime.now().toIso8601String();
      if (budgetname.isNotEmpty && budgetamount.isNotEmpty) {
        var res = await http.post(
          Uri.parse("$SERVER_URL/budgets"),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            "userid": FirebaseAuth.instance.currentUser!.uid,
            "budgetname": budgetname,
            "budgetamount": budgetamount,
            "budgetcreated": time
          }),
        );
        print("BudgetCreation ${res.body}");
        Navigator.of(context).pop();
        final provider = Provider.of<BackEndProvider>(context, listen: false);
        await getBudgetData(provider);
        await getTotal(provider, budgetname, provider.selectedBudgetIndex!);
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
                  "Create new Budget",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _namecontroller,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(8),
                    hintText: "Enter the Budget Name",
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Add Budget",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.w600),
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
                    border: const OutlineInputBorder(),
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
