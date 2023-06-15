import 'package:budget_app/widgets/expense_method_dialog.dart';
import 'package:budget_app/widgets/expense_methods_list_widget.dart';
import 'package:budget_app/widgets/swipable_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/screen_size.dart';
import '../provider/app_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => const ExpenseMethodDialog());
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      insetPadding: EdgeInsets.zero,
                      contentPadding: EdgeInsets.zero,
                      content: ExpenseMethodsListWidget(),
                    );
                  },
                );
              },
              icon: const Icon(Icons.more_vert))
        ],
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            provider.setBottomNavIndex(0);
          },
        ),
        toolbarHeight: SizeConfig.height! * 10,
        centerTitle: true,
        title: Text(
          "History",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: const SwipableCard(),
    );
  }
}
