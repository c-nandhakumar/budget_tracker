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
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                children: <Widget>[...categoryGrid],
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Container(
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey, offset: Offset(-4, 4))
                            ],
                            color: Colors.white,
                            border: Border.all(width: 1),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: const Text(
                              "Tap the \"+\" Icon to create a category")),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.only(right: 24),
                        height: 100,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationZ(1.3),
                          child: Image.asset('assets/images/arrow.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
