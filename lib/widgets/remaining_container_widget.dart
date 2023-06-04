import 'package:budget_app/provider/app_provider.dart';
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
          if (snapshot.hasData) {
            return Container(
              height: SizeConfig.width! * 44,
              width: SizeConfig.width! * 44,
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
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Balance",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      "Budget ${dotenv.get("CURRENCY")}$budgetAmount",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              )),
            );
          } else {
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
          }
        });
  }
}
