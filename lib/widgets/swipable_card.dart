import 'package:budget_app/widgets/history_container.dart';
import 'package:flutter/material.dart';

class SwipableCard extends StatefulWidget {
  const SwipableCard({super.key});

  @override
  State<SwipableCard> createState() => _SwipableCardState();
}

class _SwipableCardState extends State<SwipableCard> {
  final List<Map<String, String>> historyList = [
    {"name": "Food", "cost": "\$160", "date": "May 02"},
    {"name": "Rent", "cost": "\$160", "date": "May 02"},
    {"name": "Gas", "cost": "\$160", "date": "May 02"},
    {"name": "Travel", "cost": "\$160", "date": "May 02"},
    {"name": "Food", "cost": "\$160", "date": "May 01"}
  ];

  // final items = List<String>.generate(20, (i) => 'Item ${i + 1}');

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
              height: 12,
            ),
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          final item = historyList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Dismissible(
                key: ValueKey(item),
                secondaryBackground: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffEA0000),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Delete",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.white),
                          ),
                        )
                      ],
                    )),
                background: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffEA0000),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Delete",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.white),
                          ),
                        )
                      ],
                    )),
                onDismissed: (direction) {
                  setState(() {
                    historyList.removeAt(index);
                  });

                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('$item dismissed')));
                },
                child: HistoryContainer(
                  name: item['name'],
                  cost: item['cost'],
                  date: item['date'],
                )),
          );
        });
  }
}
