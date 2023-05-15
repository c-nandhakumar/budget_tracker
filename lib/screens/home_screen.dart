import 'package:budget_app/common/screen_size.dart';
import 'package:budget_app/provider/app_provider.dart';
import 'package:budget_app/widgets/category_dialog.dart';
import 'package:budget_app/widgets/category_grid.dart';
import 'package:budget_app/widgets/date_remaining_container.dart';
import 'package:budget_app/widgets/dialog_widget.dart';
import 'package:budget_app/widgets/flipcard_widget.dart';
import 'package:budget_app/widgets/remaining_container_widget.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:provider/provider.dart';

import '../widgets/drop_down_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          showDialog(context: context, builder: (context) => CategoryDialog());
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: SizeConfig.height! * 12,
          title: DropDownWidget(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                padding: const EdgeInsets.all(5),
                constraints: const BoxConstraints(),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  showDialog(
                      context: context, builder: (context) => DialogWidget());
                },
                color: Colors.white,
                icon: const Icon(Icons.add),
              ),
            )
          ]),
      body: ListView(
        children: [
          //Two Main Containers
          Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.width! * 5,
              right: SizeConfig.width! * 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                RemainingContainer(),
                DateRemainingContainer(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 24.0, bottom: 16),
            child: Text(
              "Expenses",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.bold),
            ),
          ),
          CategoryGrid(),
        ],
      ),
    );
  }
}

// Padding(
//             padding: const EdgeInsets.only(left: 16.0),
//             child: Text(
//               "Home Budget",
//               style: Theme.of(context).textTheme.headlineSmall!.copyWith(
//                   color: Theme.of(context).colorScheme.tertiary,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),

//  IconButton(
//               style: IconButton.styleFrom(
//                 backgroundColor: Theme.of(context).colorScheme.primary,
//               ),
//               padding: const EdgeInsets.all(5),
//               constraints: const BoxConstraints(),
//               onPressed: () {},
//               color: Colors.white,
//               icon: const Icon(Icons.keyboard_arrow_down_outlined),
//             ),