import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/screen_size.dart';
import '../provider/app_provider.dart';
import '../widgets/search_bar.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            toolbarHeight: SizeConfig.height! * 10,
            title: const SearchBarWidget(),
            leading: IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                provider.setBottomNavIndex(0);
              },
            ),
            bottom: const PreferredSize(
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
                // ignore: avoid_unnecessary_containers
                child: Container(
                  child: const Text("Deals"),
                ),
              ),
              Center(
                // ignore: avoid_unnecessary_containers
                child: Container(
                  child: const Text("Subscription"),
                ),
              )
            ],
          )),
    );
  }
}
