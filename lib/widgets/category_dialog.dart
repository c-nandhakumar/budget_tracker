import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/screen_size.dart';
import '../provider/app_provider.dart';

class CategoryDialog extends StatefulWidget {
  const CategoryDialog({super.key});

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final _namecontroller = TextEditingController();
  final _costcontroller = TextEditingController();

  Future createCategory(String budgetname, BackEndProvider provider) async {
    String categoryname = _namecontroller.text;
    String expensecost = _costcontroller.text;
    String time = DateTime.now().toIso8601String();
    if (categoryname.isNotEmpty) {
      var categoryres = await http.post(Uri.parse("$SERVER_URL/categories"),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            "userid": USER_ID,
            "categoryname": categoryname,
            "categorycreated": time,
          }));
      getCategories(provider);
      print(categoryres.body);
      Navigator.of(context).pop();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("Please Enter the category name"),
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
    /* if (categoryres.statusCode == 200) {
      var res = await http.post(
        Uri.parse("$SERVER_URL/expenses"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "userid": USER_ID,
          "budgetname": budgetname,
          "categoryname": categoryname,
          "expensecost": expensecost,
          "expensetransaction": time,
          "expensedate": time
        }),
      );
      print(res.body);
      Navigator.of(context).pop();
    } else {
      print("Oops! .. Error Occured"); 
    }*/
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    final provider2 = Provider.of<BackEndProvider>(context, listen: false);
    String budgetname = provider.selectedBudget!;
    print(provider.selectedBudget);
    return Dialog(
      child: Container(
        height: SizeConfig.height! * 42.5,
        width: SizeConfig.width! * 90,
        padding: EdgeInsets.symmetric(horizontal: 36),
        decoration: BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Add category name",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.w600),
            ),
            TextField(
                controller: _namecontroller,
                decoration:
                    InputDecoration(hintStyle: TextStyle(fontSize: 16))),
            const SizedBox(
              height: 30,
            ),
            /*Text(
              "Add Expense",
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
            ),*/
            FilledButton(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                minimumSize: Size.zero,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              onPressed: () => createCategory(budgetname, provider2),
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
