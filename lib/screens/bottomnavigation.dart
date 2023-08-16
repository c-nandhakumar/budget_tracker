import 'package:budget_app/provider/app_provider.dart';
import 'package:budget_app/screens/Login/login_screen.dart';
import 'package:budget_app/screens/history_screen.dart';
import 'package:budget_app/screens/home_screen.dart';
import 'package:budget_app/screens/insights_screen.dart';
import 'package:budget_app/screens/logout_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/ad_helper.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  BannerAd? _bannerAd;
  late Future<String> getBudgetDataStr;
  bool? isNewUser;
  bool isLoading = false;
  bool isDataFetched = false;
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();

    ///Google AdMob
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();

    getData();
  }

  getData() async {
    final provider = Provider.of<BackEndProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isNewUser = prefs.getBool("newUser");
    isDataFetched = true;

    ///If the user is new then it does nothing
    ///else it will get the existing user's budget data;
    if (isNewUser!) {
      getBudgetDataStr = doesNothing();
    } else {
      getBudgetDataStr = getBudgetData(provider);
    }
  }

  Future<String> doesNothing() async {
    return "Empty";
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
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
    return !isDataFetched
        ? const Scaffold(
            body: Center(
            child: CircularProgressIndicator(),
          ))
        : isNewUser!
            ? Scaffold(
                body: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 36),
                            child: Container(
                                // height: SizeConfig.height! * 50,
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 42, horizontal: 24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Enter Budget",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    TextField(
                                      controller: textEditingController,
                                      decoration: const InputDecoration(
                                          hintText: "Enter the budget amount"),
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
                                            if (textEditingController
                                                .text.isNotEmpty) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              final provider1 =
                                                  Provider.of<BackEndProvider>(
                                                      context,
                                                      listen: false);
                                              int amount = int.parse(
                                                  textEditingController.text);

                                              ///This will create the initial budget for the new user
                                              await createInitialBudget(
                                                  provider: provider1,
                                                  amount: amount,
                                                  status: 1);

                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs.setBool("newUser", false);
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
                          )
                        ],
                      ),
              )
            : Scaffold(
                body: FutureBuilder(
                  future: getBudgetDataStr,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      return isNewUser!
                          ? Container()
                          : pages[provider.bottomnavIndex];
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
                bottomNavigationBar: BottomAppBar(
                    height: _bannerAd != null
                        ? _bannerAd!.size.height.toDouble() + 56
                        : 56,
                    // height: 120,
                    padding: EdgeInsets.zero,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _bannerAd != null
                              ? Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    width: _bannerAd!.size.width.toDouble(),
                                    height: _bannerAd!.size.height.toDouble(),
                                    child: AdWidget(ad: _bannerAd!),
                                  ))
                              : Container(),
                          Container(
                            decoration: const BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(255, 224, 224, 224),
                                  offset: Offset(0, -2),
                                  blurRadius: 2)
                            ]),
                            child: BottomNavigationBar(
                                type: BottomNavigationBarType.fixed,
                                selectedItemColor:
                                    Theme.of(context).colorScheme.primary,
                                //  backgroundColor: Colors.grey,
                                unselectedItemColor: Colors.grey,
                                selectedFontSize: 12,
                                elevation: 10,

                                // showUnselectedLabels: true,
                                unselectedFontSize: 10,
                                // ignore: prefer_const_literals_to_create_immutables
                                items: [
                                  const BottomNavigationBarItem(
                                      icon: Icon(
                                        Icons.home,
                                      ),
                                      label: "Home"),
                                  const BottomNavigationBarItem(
                                      icon: Icon(
                                        Icons.history,
                                      ),
                                      label: "History"),
                                  const BottomNavigationBarItem(
                                      icon: Icon(
                                        Icons.insights,
                                      ),
                                      label: "Insights"),
                                  // const BottomNavigationBarItem(
                                  //     icon: Icon(
                                  //       Icons.monetization_on,
                                  //     ),
                                  //     label: ""),
                                  const BottomNavigationBarItem(
                                      icon: Icon(
                                        Icons.logout,
                                      ),
                                      label: "Logout")
                                ],
                                onTap: (value) {
                                  provider.setBottomNavIndex(value);
                                },
                                currentIndex: provider.bottomnavIndex),
                          ),
                        ])));
  }
}
