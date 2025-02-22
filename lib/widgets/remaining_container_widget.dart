import 'package:budget_app/provider/app_provider.dart';
import 'package:budget_app/widgets/edit_budget_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import '../common/screen_size.dart';

///This Widget displays the Total and the remaining amount in the Homepage
class RemainingContainer extends StatefulWidget {
  const RemainingContainer({super.key});

  @override
  State<RemainingContainer> createState() => _RemainingContainerState();
}

class _RemainingContainerState extends State<RemainingContainer> {
  late Future<String> total;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BackEndProvider>(context, listen: false);

    ///To Fetch the total amount data from the server
    total = getTotal(
        provider, provider.selectedBudget!, provider.selectedBudgetIndex!);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);

    return FutureBuilder(
        future: total,
        builder: (context, snapshot) {
          final balance = provider.balance;
          final budgetAmount = provider.budgetAmount;
          double percentage = 0;

          ///This will find the percentage value so that it can be used to determine the
          ///Color of the container based on its percentage value
          if (budgetAmount > 0 && balance >= 0 && budgetAmount >= balance) {
            percentage = balance / budgetAmount;
          }

          /// This will change the Container's color from green to red based
          /// on the total and remaining amount
          /// red ---> Low amount
          /// green ---> High amount
          Color? color = Color.lerp(Colors.red, Colors.green, percentage);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: SizeConfig.width! * 44,
              width: SizeConfig.width! * 44,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          } else {
            return Container(
              height: SizeConfig.width! * 44,
              width: SizeConfig.width! * 44,
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                //color: Theme.of(context).colorScheme.primary,

                color: color,
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${dotenv.get("CURRENCY")}$balance",
                    style: balance.toString().length > 6
                        ? Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600)
                        : Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Balance",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return EditBudgetDialog(
                                    callback: updateBudgetAmount);
                              },
                            );
                          },
                          child: Ink(
                            height: 24,
                            width: 24,
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          )),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        "Budget ${dotenv.get("CURRENCY")}$budgetAmount",
                        style: budgetAmount.toString().length >= 6
                            ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                )
                            : Theme.of(context).textTheme.titleSmall!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ],
                  ),
                ],
              )),
            );
          }
        });
  }

  Future<void> updateBudgetAmount(String text, BuildContext context) async {
    final provider1 = Provider.of<BackEndProvider>(context, listen: false);

    if (text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text("Please enter the amount"),
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
      await updateBudget(
        provider1,
        provider1.budget!,
        provider1.selectedBudgetIndex!,
        int.parse(text),
      );
      setState(() {
        total = getTotal(provider1, provider1.selectedBudget!,
            provider1.selectedBudgetIndex!);
      });
    }
  }
}
