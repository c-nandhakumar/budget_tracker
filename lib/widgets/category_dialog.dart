import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
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
    // ignore: unused_local_variable
    String expensecost = _costcontroller.text;
    String time = DateTime.now().toIso8601String();

    ///POST request to add the Category name
    ///Endpoint /categories [POST]
    if (categoryname.isNotEmpty) {
      var categoryres = await http.post(Uri.parse("$SERVER_URL/categories"),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            "userid": FirebaseAuth.instance.currentUser!.uid,
            "categoryname": categoryname,
            "categorycreated": time,
          }));
      getCategories(provider);
      print(categoryres.body);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text("Please Enter the category name"),
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    final provider2 = Provider.of<BackEndProvider>(context, listen: false);
    if (provider.selectedBudget != null) {
      String budgetname = provider.selectedBudget!;
      print(provider.selectedBudget);

      return Dialog(
        // surfaceTintColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.screenWidth! > tabWidth ? 120 : 36),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
              decoration: const BoxDecoration(),
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
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    maxLength: 13,
                    controller: _namecontroller,
                    decoration: const InputDecoration(
                      hintText: "Enter the category name",
                      isDense: true,
                      // contentPadding: EdgeInsets.all(8),
                      hintStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
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
                      onPressed: () => createCategory(budgetname, provider2),
                      child: const Text("Add"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Dialog(
          child: Container(
        height: SizeConfig.height! * 38,
        width: SizeConfig.width! * 90,
        padding: const EdgeInsets.symmetric(horizontal: 36),
        decoration: const BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Create the Budget (By Tapping the \"+\" Icon on the Top) and then use this button to create Categories",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 30,
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                minimumSize: Size.zero,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      ));
    }
  }
}
