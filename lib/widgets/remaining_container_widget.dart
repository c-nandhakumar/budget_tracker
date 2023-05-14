import 'package:budget_app/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/screen_size.dart';

class RemainingContainer extends StatefulWidget {
  const RemainingContainer({super.key});

  @override
  State<RemainingContainer> createState() => _RemainingContainerState();
}

class _RemainingContainerState extends State<RemainingContainer> {
  late Future<String> total;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final provider = Provider.of<BackEndProvider>(context, listen: false);
    
    total = getTotal(provider, provider.selectedBudget!,provider.selectedBudgetIndex);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    return Container(
      height: SizeConfig.width! * 44,
      width: SizeConfig.width! * 44,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Center(
        child: FutureBuilder(
          future: total,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final balance = provider.balance;
              final budgetAmount = provider.budgetAmount;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "\$${balance}",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Balance",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Budget \$${budgetAmount}",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator(
                color: Colors.white,
              );
            }
          },
        ),
      ),
    );
  }
}
