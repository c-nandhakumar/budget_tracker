import 'package:budget_app/provider/app_provider.dart';
import 'package:budget_app/screens/deals_screen.dart';
import 'package:budget_app/screens/history_screen.dart';
import 'package:budget_app/screens/home_screen.dart';
import 'package:budget_app/screens/insights_screen.dart';
import 'package:budget_app/screens/logout_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    const pages = [
      HomeScreen(),
      HistoryScreen(),
      InsightsScreen(),
      DealsScreen(),
      LogoutScreen()
    ];
    return Scaffold(
      body: pages[provider.bottomnavIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          //  backgroundColor: Colors.grey,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          elevation: 10,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          // showUnselectedLabels: true,
          unselectedFontSize: 10,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: ""),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.history,
                ),
                label: ""),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.insights,
                ),
                label: ""),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.monetization_on,
                ),
                label: ""),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.logout,
                ),
                label: "")
          ],
          onTap: (value) {
            // setState(() {
            //   index = value;
            // });
            provider.setBottomNavIndex(value);
          },
          currentIndex: provider.bottomnavIndex),
    );
  }
}
