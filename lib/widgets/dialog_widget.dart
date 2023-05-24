// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:budget_app/common/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/budget_model.dart';
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
            "userid": mainprovider.getUserId(),
            "budgetname": budgetname,
            "budgetamount": budgetamount,
            "budgetcreated": time
          }),
        );
        //print(res.body);
        Navigator.of(context).pop();
        // ignore: use_build_context_synchronously
        final provider = Provider.of<BackEndProvider>(context, listen: false);
        getBudgetData(provider);
        // if (provider.selectedBudgetIndex != null) {
        getTotal(provider, budgetname, provider.selectedBudgetIndex!);
        //     }else{
        //       final budget = budgetFromJson(payload);
        // if (budget!.budgets.isNotEmpty) {
        //   selectedBudgetIndex = 0;
        //   selectedBudget = budget!.budgets[selectedBudgetIndex!].budgetname;

        // }
        // }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text("Please Enter the budget name and amount"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"))
            ],
          ),
        );
      }
    }

    return Dialog(
      child: Container(
        height: SizeConfig.height! * 42.5,
        width: SizeConfig.width! * 90,
        padding: const EdgeInsets.symmetric(horizontal: 36),
        decoration: const BoxDecoration(),
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
            TextField(
                controller: _namecontroller,
                decoration:
                    const InputDecoration(hintStyle: TextStyle(fontSize: 16))),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Add Budget",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.w600),
            ),
            TextField(
              controller: _costcontroller,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 45,
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                minimumSize: Size.zero,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              onPressed: createBudget,
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
