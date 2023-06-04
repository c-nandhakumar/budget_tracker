import 'dart:async';
import 'dart:convert';

import 'package:budget_app/provider/app_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class FlipCardWidget extends StatefulWidget {
  final String? name;
  final String? cost;
  const FlipCardWidget({this.name, this.cost, super.key});

  @override
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget> {
  late FlipCardController _controller;
  TextEditingController? amountController;
  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();
    amountController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    amountController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    String budgetname = provider.selectedBudget!;

    Future<void> addAmount(String budgetname) async {
      final expensecost = amountController!.text;
      String time = DateTime.now().toIso8601String();
      print("----Budget Name---- $budgetname");
      if (expensecost.isNotEmpty) {
        // ignore: unused_local_variable
        var res = await http.post(
          Uri.parse("$SERVER_URL/expenses"),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            "userid": FirebaseAuth.instance.currentUser!.uid,
            "budgetname": budgetname,
            "categoryname": widget.name,
            "expensecost": expensecost,
            "expensetransaction": time,
            "expensedate": time
          }),
        );
        //print(res.body);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text("Please Enter the Expense"),
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
      // Navigator.of(context).pop();
    }

    return FlipCard(
      key: ValueKey(widget.name),
      controller: _controller,

      fill: Fill
          .fillBack, // Fill the back side of the card to make in the same size as the front.
      direction: FlipDirection.HORIZONTAL, // default
      side: CardSide.FRONT, // The side to initially display.
      front: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${widget.name}",
                style: widget.name!.length <= 11
                    ? Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w500)
                    : Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontWeight: FontWeight.w500)),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                "${widget.cost}",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 113, 113, 113)),
              ),
            ),
          ],
        ),
      ),

      /// This property displays the back side of the card
      /// This has an input field to add the expense value to a particular category
      back: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Add Expenses",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            // ignore: prefer_const_constructors
            Padding(
              padding:
                  const EdgeInsets.only(top: 12.0, left: 20.0, right: 20.0),
              child: TextField(
                textAlign: TextAlign.center,
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "${dotenv.get("CURRENCY")}0",
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  minimumSize: Size.zero,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                ),
                onPressed: () async {
                  print("Button Works Perfectly ${widget.name}");

                  await addAmount(budgetname);

                  if (amountController!.text.isNotEmpty) {
                    await getTotal(
                        provider, budgetname, provider.selectedBudgetIndex!);
                  }
                  amountController!.clear();
                  _controller.toggleCard();
                },
                child: const Text("Add"),
              ),
            ),
          ],
        ),
      ),

      onFlip: () {
        if (_controller.state!.isFront) {
          Timer(const Duration(seconds: 15), () {
            _controller.toggleCard();
          });
        }
      },
    );
  }
}
