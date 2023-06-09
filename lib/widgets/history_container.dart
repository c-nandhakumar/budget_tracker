import 'package:budget_app/common/screen_size.dart';
import 'package:budget_app/models/expense_model.dart';
import 'package:budget_app/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/expensemethod_model.dart';

class HistoryContainer extends StatefulWidget {
  final Expenses? expense;
  const HistoryContainer({super.key, this.expense});

  @override
  State<HistoryContainer> createState() => _HistoryContainerState();
}

class _HistoryContainerState extends State<HistoryContainer> {
  @override
  Widget build(BuildContext context) {
    ///Formatting the date to display in the history list
    String timestamp = widget.expense!.expensetransaction;
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedDate = DateFormat('MMM dd').format(dateTime);

    final provider = Provider.of<BackEndProvider>(context);
    List<ExpenseMethod> expenseMethodList = provider.expenseMethods;

    // ExpenseMethod initialValue = expenseMethodList.firstWhere((element) =>
    //     (element.emname == widget.expense!.emname &&
    //         element.emshortname == widget.expense!.emshortname &&
    //         element.emdetail == widget.expense!.emdetail));
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: Theme.of(context).colorScheme.secondary),
      height: SizeConfig.height! * 13.75,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 24, vertical: SizeConfig.height! * 1.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.expense!.budgetname,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff808080)),
                  ),
                  Text(
                    widget.expense!.categoryname,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff808080)),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    child: Consumer<BackEndProvider>(
                        builder: (context, value, child) {
                      ExpenseMethod initialValue = value.expenseMethods
                          .firstWhere((element) => (element.emshortname ==
                                  widget.expense!.emshortname &&
                              element.emdetail == widget.expense!.emdetail));

                      return DropdownButton<ExpenseMethod>(
                          borderRadius: BorderRadius.circular(10),
                          isDense: true,
                          padding: EdgeInsets.zero,
                          value: initialValue,
                          underline: SizedBox(),
                          elevation: 5,
                          onChanged: (ExpenseMethod? value) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            final provider =
                                                Provider.of<BackEndProvider>(
                                                    context,
                                                    listen: false);
                                            await changeExpenseMethod(
                                                provider: provider,
                                                expenseNotes: "",
                                                expenseid:
                                                    widget.expense!.expenseid,
                                                expensedate: widget
                                                    .expense!.expensedate
                                                    .toString(),
                                                emdetail: value!.emdetail,
                                                emshortname: value.emshortname,
                                                expensetransaction: widget
                                                    .expense!
                                                    .expensetransaction,
                                                emname: value.emname);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Yes"),
                                        ),
                                        FilledButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("No"),
                                        )
                                      ],
                                      content: Text(
                                          "Do you want to change this payment method to \"${value!.emshortname}\""),
                                    ));
                            print(value!.emshortname);
                            // This is called when the user selects an item.
                          },
                          items: expenseMethodList.map((ExpenseMethod value) {
                            return DropdownMenuItem(
                                onTap: () {},
                                value: value,
                                child: Text(value.emshortname));
                          }).toList());
                    }),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "${dotenv.get("CURRENCY")}${widget.expense!.expensecost}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ]),
    );
  }
}
