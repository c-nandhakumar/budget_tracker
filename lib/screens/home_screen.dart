import 'package:budget_app/common/screen_size.dart';
import 'package:budget_app/widgets/category_dialog.dart';
import 'package:budget_app/widgets/date_remaining_container.dart';
import 'package:budget_app/widgets/dialog_widget.dart';
import 'package:budget_app/widgets/flipcard_widget.dart';
import 'package:budget_app/widgets/remaining_container_widget.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

import '../widgets/drop_down_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FlipCardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();
  }

  void doStuff() {
    // Flip the card a bit and back to indicate that it can be flipped (for example on page load)
    _controller.hint(
        duration: Duration(seconds: 1), total: Duration(seconds: 1));

    // Flip the card programmatically
    _controller.toggleCard();
  }

  @override
  Widget build(BuildContext context) {
    // doStuff();
    const expenses_list = [
      {"name": "Food", "cost": "\$160"},
      {"name": "Rent", "cost": "\$160"},
      {"name": "Gas", "cost": "\$160"},
      {"name": "Travel", "cost": "\$160"},
      {"name": "Gift", "cost": "\$160"},
      {"name": "Gas", "cost": "\$160"}
    ];
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
          GridView.count(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            children: <Widget>[
              ...expenses_list.map(
                (e) => FlipCardWidget(
                  name: e['name'],
                  cost: e['cost'],
                ),
              )
            ],
          )
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