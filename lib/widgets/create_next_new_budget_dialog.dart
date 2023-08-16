// ignore_for_file: use_build_context_synchronously

import 'package:budget_app/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNextNewBudgetDialog extends StatefulWidget {
  final Function() callback;
  const CreateNextNewBudgetDialog({required this.callback, super.key});

  @override
  State<CreateNextNewBudgetDialog> createState() =>
      _CreateNextNewBudgetDialogState();
}

class _CreateNextNewBudgetDialogState extends State<CreateNextNewBudgetDialog> {
  @override
  Widget build(BuildContext context) {
    createNewBudgetFunction() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String subscriptionStatus = prefs.getString('substatus')!.toLowerCase();
      final provider = Provider.of<BackEndProvider>(context, listen: false);

      ///If the Subscription is Free then we have to allow 2 budget creations
      if (subscriptionStatus == 'free') {
        ///TODO:Navigate the Users to subscription portal
        await createNewBudget(provider);
      } else {
        await createNewBudget(provider);
      }
      widget.callback();
      Navigator.of(context).pop();
    }

    return AlertDialog(actions: [
      FilledButton(
        onPressed: () async {
          await createNewBudgetFunction();
        },
        child: const Text("Yes"),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text("No"),
      )
    ], content: const Text("Do you want to create budget for the next month?"));
  }
}
