import 'package:flutter/material.dart';

class EditBudgetDialog extends StatefulWidget {
  final Function(String, BuildContext) callback;

  const EditBudgetDialog({required this.callback, super.key});

  @override
  State<EditBudgetDialog> createState() => _EditBudgetDialogState();
}

class _EditBudgetDialogState extends State<EditBudgetDialog> {
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 36),
            child: Container(
                // height: SizeConfig.height! * 50,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(
                  vertical: 42,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Edit Budget",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: amountController,
                      decoration:
                          const InputDecoration(hintText: "Enter amount"),
                      maxLength: 6,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    SizedBox(
                      height: 36,
                      width: double.infinity,
                      child: FilledButton(
                          onPressed: () async {
                            if (amountController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content:
                                        const Text("Please enter the amount"),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("OK"))
                                    ],
                                  );
                                },
                              );
                            } else {
                              widget.callback(amountController.text, context);
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text(
                            "Add",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          )),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
