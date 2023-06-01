import 'dart:convert';

List<Expenses> expensesFromJson(String str) =>
    List<Expenses>.from(json.decode(str).map((x) => Expenses.fromJson(x)));

String expensesToJson(List<Expenses> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// This class is used to convert the JSON data into Dart Objects 
class Expenses {
  String expenseid;
  String userid;
  String categoryname;
  DateTime expensetransaction;
  String budgetname;
  int expensecost;
  DateTime? expensedate;

  Expenses({
    required this.expenseid,
    required this.userid,
    required this.categoryname,
    required this.expensetransaction,
    required this.budgetname,
    required this.expensecost,
    this.expensedate,
  });

  factory Expenses.fromJson(Map<String, dynamic> json) => Expenses(
        expenseid: json["expenseid"],
        userid: json["userid"],
        categoryname: json["categoryname"],
        expensetransaction: DateTime.parse(json["expensetransaction"]),
        budgetname: json["budgetname"],
        expensecost: json["expensecost"],
        expensedate: json["expensedate"] == null
            ? null
            : DateTime.parse(json["expensedate"]),
      );

  Map<String, dynamic> toJson() => {
        "expenseid": expenseid,
        "userid": userid,
        "categoryname": categoryname,
        "expensetransaction": expensetransaction.toIso8601String(),
        "budgetname": budgetname,
        "expensecost": expensecost,
        "expensedate":
            "${expensedate!.year.toString().padLeft(4, '0')}-${expensedate!.month.toString().padLeft(2, '0')}-${expensedate!.day.toString().padLeft(2, '0')}",
      };
}
