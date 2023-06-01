import 'dart:convert';

Budget budgetFromJson(String str) => Budget.fromJson(json.decode(str));

String budgetToJson(Budget data) => json.encode(data.toJson());

/// This class is used to convert the JSON data into Dart Objects 
class Budget {
  User user;
  List<BudgetElement> budgets;

  Budget({
    required this.user,
    required this.budgets,
  });

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
        user: User.fromJson(json["user"]),
        budgets: List<BudgetElement>.from(
                json["budgets"].map((x) => BudgetElement.fromJson(x)))
            .reversed
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "budgets": List<dynamic>.from(budgets.map((x) => x.toJson())),
      };
}

class BudgetElement {
  String budgetid;
  int budgetamount;
  String budgetname;
  String userid;
  DateTime budgetcreated;

  BudgetElement({
    required this.budgetid,
    required this.budgetamount,
    required this.budgetname,
    required this.userid,
    required this.budgetcreated,
  });

  factory BudgetElement.fromJson(Map<String, dynamic> json) => BudgetElement(
        budgetid: json["budgetid"],
        budgetamount: json["budgetamount"],
        budgetname: json["budgetname"],
        userid: json["userid"],
        budgetcreated: DateTime.parse(json["budgetcreated"]),
      );

  Map<String, dynamic> toJson() => {
        "budgetid": budgetid,
        "budgetamount": budgetamount,
        "budgetname": budgetname,
        "userid": userid,
        "budgetcreated": budgetcreated.toIso8601String(),
      };
}


class User {
  String displayName;
  String userid;
  String email;

  User({
    required this.displayName,
    required this.userid,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        displayName: json["display_name"],
        userid: json["userid"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "display_name": displayName,
        "userid": userid,
        "email": email,
      };
}
