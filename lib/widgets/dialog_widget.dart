import 'package:budget_app/common/screen_size.dart';
import 'package:flutter/material.dart';

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
            const TextField(
                decoration:
                    InputDecoration(hintStyle: TextStyle(fontSize: 16))),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Add Budget",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.w600),
            ),
            const TextField(
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
