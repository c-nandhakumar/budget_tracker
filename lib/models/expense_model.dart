// To parse this JSON data, do
//
//     final expenses = expensesFromJson(jsonString);

import 'dart:convert';

List<Expenses> expensesFromJson(String str) =>
    List<Expenses>.from(json.decode(str).map((x) => Expenses.fromJson(x)));

String expensesToJson(List<Expenses> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Expenses {
  String budgetname;
  String expenseid;
  int expensecost;
  String emdetail;
  String expensenotes;
  DateTime expensedate;
  String categoryname;
  String userid;
  String emname;
  String emshortname;
  String expensetransaction;
  bool? recurring;

  Expenses({
    required this.budgetname,
    required this.expenseid,
    required this.expensecost,
    required this.emdetail,
    required this.expensenotes,
    required this.expensedate,
    required this.categoryname,
    required this.userid,
    required this.emname,
    required this.emshortname,
    required this.expensetransaction,
    this.recurring,
  });

  factory Expenses.fromJson(Map<String, dynamic> json) => Expenses(
        budgetname: json["budgetname"],
        expenseid: json["expenseid"],
        expensecost: json["expensecost"],
        emdetail: json["emdetail"],
        expensenotes: json["expensenotes"],
        expensedate: DateTime.parse(json["expensedate"]),
        categoryname: json["categoryname"],
        userid: json["userid"],
        emname: json["emname"],
        emshortname: json["emshortname"],
        expensetransaction: json["expensetransaction"],
        recurring: json["recurring"],
      );

  Map<String, dynamic> toJson() => {
        "budgetname": budgetname,
        "expenseid": expenseid,
        "expensecost": expensecost,
        "emdetail": emdetail,
        "expensenotes": expensenotes,
        "expensedate":
            "${expensedate.year.toString().padLeft(4, '0')}-${expensedate.month.toString().padLeft(2, '0')}-${expensedate.day.toString().padLeft(2, '0')}",
        "categoryname": categoryname,
        "userid": userid,
        "emname": emname,
        "emshortname": emshortname,
        "expensetransaction": expensetransaction,
        "recurring": recurring,
      };
}
