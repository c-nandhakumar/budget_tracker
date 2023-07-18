import 'dart:isolate';

import 'package:budget_app/common/screen_size.dart';
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
  bool? isNewUser;
  bool isLoading = false;
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BackEndProvider>(context, listen: false);
    isNewUser = provider.isNewUser;

    ///If the user is new then it does nothing
    ///else it will get the existing user's budget data;
    if (provider.isNewUser) {
      getBudgetDataStr = doesNothing();
    } else {
      getBudgetDataStr = getBudgetData(provider);
    }
  }

  Future<String> doesNothing() async {
    return "Empty";
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
      body: isNewUser!
          ? isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        height: SizeConfig.height! * 50,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Enter Budget",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            TextField(
                              controller: textEditingController,
                              decoration: const InputDecoration(
                                  hintText: "Enter amount"),
                              maxLength: 6,
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            SizedBox(
                              height: 36,
                              width: double.infinity,
                              child: FilledButton(
                                  onPressed: () async {
                                    if (textEditingController.text.isNotEmpty) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      final provider1 =
                                          Provider.of<BackEndProvider>(context,
                                              listen: false);
                                      int amount =
                                          int.parse(textEditingController.text);

                                      ///This will create the initial budget for the new user
                                      await createInitialBudget(
                                          provider1, amount);
                                      provider1.setNewUser(false);
                                      setState(() {
                                        isNewUser = false;
                                        isLoading = false;
                                      });
                                    }
                                  },
                                  child: const Text(
                                    "Add",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  )),
                            )
                          ],
                        )),
                  ),
                )
          : FutureBuilder(
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
