import 'package:budget_app/provider/app_provider.dart';
import 'package:budget_app/screens/Login/login_screen.dart';
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
  late Future<String> getBudgetDataStr;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BackEndProvider>(context, listen: false);
    // context.read<BackEndProvider>().setBottomNavIndex(0);
    getBudgetDataStr = getBudgetData(provider);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    
    const pages = [
      HomeScreen(),
      HistoryScreen(),
      InsightsScreen(),
      // DealsScreen(),
      LogoutScreen()
    ];
    print("Triggered");
    return Scaffold(
      body: FutureBuilder(
        future: getBudgetDataStr,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            //print(snapshot.data);
            return pages[provider.bottomnavIndex];
          }
          if (snapshot.hasError) {
            print(snapshot);
            return const Center(
              child: Text("Oops , Something went wrong"),
            );
          } else {
            return const LoginScreen();
          }
        },
      ),
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
            // const BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.monetization_on,
            //     ),
            //     label: ""),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.logout,
                ),
                label: "")
          ],
          onTap: (value) {
            print("Tapped $value");
            provider.setBottomNavIndex(value);
            // setState(() {
            //   index = value;
            // });
          },
          currentIndex: provider.bottomnavIndex),
    );
  }
}
