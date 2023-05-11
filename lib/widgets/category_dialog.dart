import 'package:flutter/material.dart';

import '../common/screen_size.dart';

class CategoryDialog extends StatefulWidget {
  const CategoryDialog({super.key});

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final _namecontroller = TextEditingController();
  final _costcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                decoration:
                    InputDecoration(hintStyle: TextStyle(fontSize: 16))),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Add Expense",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.w600),
            ),
            TextField(
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
              onPressed: () {},
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
