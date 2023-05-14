import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../common/screen_size.dart';
import '../widgets/search_bar.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            toolbarHeight: SizeConfig.height! * 10,
            title: SearchBarWidget(),
            leading: IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () {},
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(30),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(
                    text: ("Deals"),
                  ),
                  Tab(
                    text: ("Subscription"),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                child: Container(
                  child: Text("Deals"),
                ),
              ),
              Center(
                child: Container(
                  child: Text("Subscription"),
                ),
              )
            ],
          )),
    );
  }
}
