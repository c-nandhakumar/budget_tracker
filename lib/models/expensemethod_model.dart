// To parse this JSON data, do
//
//     final expenseMethod = expenseMethodFromJson(jsonString);

import 'dart:convert';

List<ExpenseMethod> expenseMethodFromJson(String str) =>
    List<ExpenseMethod>.from(
        json.decode(str).map((x) => ExpenseMethod.fromJson(x)));

String expenseMethodToJson(List<ExpenseMethod> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExpenseMethod {
  String emdetail;
  String emid;
  String emshortname;
  DateTime emcreated;
  String userid;
  String emname;
  bool emisdefault;

  ExpenseMethod({
    required this.emdetail,
    required this.emid,
    required this.emshortname,
    required this.emcreated,
    required this.userid,
    required this.emname,
    required this.emisdefault,
  });

  factory ExpenseMethod.fromJson(Map<String, dynamic> json) => ExpenseMethod(
        emdetail: json["emdetail"],
        emid: json["emid"],
        emshortname: json["emshortname"],
        emcreated: DateTime.parse(json["emcreated"]),
        userid: json["userid"],
        emname: json["emname"],
        emisdefault: json["emisdefault"],
      );

  Map<String, dynamic> toJson() => {
        "emdetail": emdetail,
        "emid": emid,
        "emshortname": emshortname,
        "emcreated":
            "${emcreated.year.toString().padLeft(4, '0')}-${emcreated.month.toString().padLeft(2, '0')}-${emcreated.day.toString().padLeft(2, '0')}",
        "userid": userid,
        "emname": emname,
        "emisdefault": emisdefault,
      };
}
