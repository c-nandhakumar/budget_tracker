import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/category_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../models/expense_model.dart';

const SERVER_URL =
    "http://ec2-3-110-68-255.ap-south-1.compute.amazonaws.com:8000";
// const USER_ID = 'gCyuWfM3TuYcx71B3Za99qQjeRz2';

abstract class DisposableProvider with ChangeNotifier {
  void disposeValues();
}

class AppProviders {
  static List<DisposableProvider> getDisposableProviders(BuildContext context) {
    return [
      Provider.of<BackEndProvider>(context, listen: false),
      //...other disposable providers
    ];
  }

  static void disposeAllDisposableProviders(BuildContext context) {
    getDisposableProviders(context).forEach((disposableProvider) {
      disposableProvider.disposeValues();
    });
  }
}

class BackEndProvider extends DisposableProvider {
  String getServerUrl() {
    return SERVER_URL;
  }

  String jwt = "";
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String getUserId() {
    return userId;
  }

  void setUserId() {
    userId = "";
    notifyListeners();
  }

  int bottomnavIndex = 0;

  void setBottomNavIndex(int index) {
    bottomnavIndex = index;
    notifyListeners();
  }

  Budget? budget;
  List<Categories>? categories;
  List<Expenses>? expenses;

  Future<Budget> getBudget() {
    return budget as Future<Budget>;
  }

  Map<String, dynamic>? categoriesPriceJson;
  List<Map<String, int>> categoriesPriceList = [];

  String? selectedBudget;
  String? selectedInsights;
  int? selectedBudgetIndex;

  void setSelectedBudget(String selectedBudget) {
    this.selectedBudget = selectedBudget;
    selectedInsights = selectedBudget;
    notifyListeners();
  }

  void setSelectedInsights(String selectedText) {
    selectedInsights = selectedText;
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    selectedBudgetIndex = index;
    notifyListeners();
  }

  void setRawData(data) {
    categoriesPriceJson = data;
    notifyListeners();
  }

  int total = 0;
  int balance = 0;
  int budgetAmount = 0;
  void getBalance(int index) {
    print("Budget : ${budget!.budgets[index].budgetamount}");
    print("Total : $total");
    budgetAmount = budget!.budgets[index].budgetamount;
    balance = budgetAmount - total;
    notifyListeners();
  }

  void setTotal(int total) {
    this.total = total;
    notifyListeners();
  }

  void setBudgets(String payload) {
    budget = budgetFromJson(payload);
    if (budget!.budgets.isNotEmpty) {
      selectedBudgetIndex = 0;
      selectedBudget = budget!.budgets[selectedBudgetIndex!].budgetname;
      selectedInsights = selectedBudget;
    } else {
      selectedBudgetIndex = 0;
    }
    notifyListeners();
  }

  void setCategories(String payload) {
    if (payload.isNotEmpty) {
      categories = categoriesFromJson(payload);
      notifyListeners();
    } else {
      categories = [];
    }
  }

  void setExpenses(String payload) {
    if (payload.isNotEmpty) {
      expenses = expensesFromJson(payload);
      notifyListeners();
    } else {
      expenses = [];
    }
  }

  @override
  void disposeValues() {
    bottomnavIndex = 0;
    budget = null;
    categories = null;
    expenses = null;
    categoriesPriceJson = null;
    categoriesPriceList = [];

    selectedBudget = null;
    selectedInsights = null;
    selectedBudgetIndex = 0;
    total = 0;
    balance = 0;
    budgetAmount = 0;
  }
}

Future<void> postUser() async {
  final email = FirebaseAuth.instance.currentUser!.email;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final displayName = FirebaseAuth.instance.currentUser!.displayName;
  var res = await http.post(
    Uri.parse("$SERVER_URL/user"),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(
        {"userid": uid, "email": email, "display_name": displayName}),
  );

  if (res.statusCode == 200) {
    print("Success in Creating user");
  } else {
    print(res.body);
  }
}

Future<String> getBudgetData(BackEndProvider provider) async {
  print("Backend===> ${FirebaseAuth.instance.currentUser!.uid}");
  print(provider.getUserId());
  var res = await http.get(Uri.parse(
      "$SERVER_URL/budgets/user/${FirebaseAuth.instance.currentUser!.uid}"));
  print("<===== Get Budget Data Status Code =====> ${res.statusCode}");
  if (res.statusCode == 200) {
    print("Success in getting header");
    provider.setBudgets(res.body);
    return res.body;
  }
  if (res.statusCode == 422) {
    print("Error");
    return res.body;
  } else {
    print(res);
  }
  return "";
}

Future<String> getTotal(
    BackEndProvider provider, String budgetname, int index) async {
  print("Backend Total===> ${provider.getUserId()}");
  print("User id printed");
  print("User id ===> ${FirebaseAuth.instance.currentUser?.uid}");

  var res = await http.get(Uri.parse(
      "$SERVER_URL/expenses/total-by-category/$budgetname/${FirebaseAuth.instance.currentUser!.uid}"));
  print(budgetname);
  if (res.statusCode == 200) {
    print("Success in getting total");
    final data = json.decode(res.body);
    print(data);
    provider.setSelectedBudget(budgetname);
    provider.setSelectedIndex(index);
    provider.setRawData(data);
    getCategories(provider);
    provider.setTotal(data["Total"] as int);
    provider.getBalance(index);
    return res.body;
  }
  if (res.statusCode == 404) {
    print("There is no expense total");
    print(res.body);
    provider.setRawData({"Total": 0});
    provider.setTotal(0);

    provider.getBalance(index);
    return res.body;
  } else {
    print("500 - Internal SERVER error");
  }
  return "";
}

Future<String> getCategories(BackEndProvider provider) async {
  var res = await http.get(Uri.parse(
      "$SERVER_URL/categories/user/${FirebaseAuth.instance.currentUser!.uid}"));

  if (res.statusCode == 200) {
    print("Success in getting categories");
    print(res.body);

    provider.setCategories(res.body);
    // provider.setCategoryPrice();
    return res.body;
  }
  if (res.statusCode == 404) {
    provider.setCategories("");
    return res.body;
  }
  if (res.statusCode == 422) {
    print("Error");
    return res.body;
  } else {
    print(res);
  }
  return "";
}

Future<String> getExpenses(BackEndProvider provider) async {
  var res = await http.get(Uri.parse(
      "$SERVER_URL/expenses/user/${FirebaseAuth.instance.currentUser!.uid}"));

  if (res.statusCode == 200) {
    print("Success in getting expenses");
    // print(res.body);

    provider.setExpenses(res.body);
    return res.body;
  }
  if (res.statusCode == 404) {
    print("New User Expense");
    provider.setExpenses("");
    return res.body;
  }
  if (res.statusCode == 422) {
    print("Error");
    return res.body;
  } else {
    print(res.statusCode);
  }
  return "";
}

Future<String> deleteExpenses(
    String expenseId, BackEndProvider provider) async {
  var res = await http.delete(
    Uri.parse("$SERVER_URL/expenses/$expenseId"),
  );
  print(res.body);
  if (res.statusCode == 200) {
    print("Deleted Successfully");
    await getExpenses(provider);
    return "Deleted Successfully";
  }
  return "Error Occured!";
}
