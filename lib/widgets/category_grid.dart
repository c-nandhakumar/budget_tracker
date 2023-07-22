import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import '../provider/app_provider.dart';
import 'flipcard_widget.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  late Future<String> categories;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BackEndProvider>(context, listen: false);
    categories = getCategories(provider);
    print("InitState Fired in Grid List");
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    return FutureBuilder(
        future: categories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //print("<=======Categories=======> ${provider.categories}");
            if (provider.categories != null &&
                provider.categories!.isNotEmpty) {
              Map<String, dynamic>? categoriesPriceJson =
                  provider.categoriesPriceJson;
              Map<String, int> categoriesPriceMap = {};

              ///Categories and price mapping
              ///Here is where the mapping of the Named Categories and
              ///the total sum of expenses of categories under single name takes place here.
              for (var e in provider.categories!) {
                categoriesPriceMap.putIfAbsent(e.categoryname, () => 0);
                if (categoriesPriceJson != null &&
                    categoriesPriceJson[e.categoryname] != null) {
                  categoriesPriceMap.update(
                      e.categoryname,
                      (value) =>
                          value + categoriesPriceJson[e.categoryname] as int);
                }
              }

              List<Widget> categoryGrid = [];
              categoriesPriceMap.forEach((key, value) => categoryGrid.add(
                    FlipCardWidget(
                      name: key,
                      cost: "${dotenv.get("CURRENCY")}$value",
                    ),
                  ));
              return GridView.count(
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                crossAxisSpacing: 12.5,
                mainAxisSpacing: 12.5,
                crossAxisCount: 3,
                children: <Widget>[...categoryGrid],
              );
            } else {
              return fallbackUI(context);
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

Widget fallbackUI(context) {
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          // height: 64,
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 4),
                  blurRadius: 3,
                  spreadRadius: 1)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  "Tap the ",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(48),
                          color: Theme.of(context).colorScheme.primary),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      )),
                ),
                Text(" icon",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 18)),
                Text(
                  "to create new category",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ));
}
