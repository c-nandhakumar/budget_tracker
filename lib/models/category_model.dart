import 'dart:convert';

List<Categories> categoriesFromJson(String str) => List<Categories>.from(json.decode(str).map((x) => Categories.fromJson(x)));

String categoriesToJson(List<Categories> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// This class is used to convert the JSON data into Dart Objects 
class Categories {
    String categoryname;
    DateTime categorycreated;

    Categories({
        required this.categoryname,
        required this.categorycreated,
    });

    factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        categoryname: json["categoryname"],
        categorycreated: DateTime.parse(json["categorycreated"]),
    );

    Map<String, dynamic> toJson() => {
        "categoryname": categoryname,
        "categorycreated": categorycreated.toIso8601String(),
    };
}
