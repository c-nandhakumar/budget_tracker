import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/category_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../models/expense_model.dart';

// ignore: constant_identifier_names, non_constant_identifier_names
String SERVER_URL = dotenv.get("SERVER_URL");
// const USER_ID = 'gCyuWfM3TuYcx71B3Za99qQjeRz2';

///This class is useful for resetting the state to its initial snapshot
///which is getting it back to initial value for the new user
///this gets triggered when signing out
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

///This will act as the Global State for the Application
///All data are transferred from this store
class BackEndProvider extends DisposableProvider {
  String getServerUrl() {
    return SERVER_URL;
  }

  String jwt = "";

  ///This will store the current userid, which is used later
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String getUserId() {
    return userId;
  }

  void setUserId() {
    userId = "";
    notifyListeners();
  }

  ///This is used to set the bottomnavigationindex to zero whenever the user taps
  ///the back button in the history screen, insights screen
  int bottomnavIndex = 0;
  void setBottomNavIndex(int index) {
    bottomnavIndex = index;
    notifyListeners();
  }

  Budget? budget;
  List<Categories>? categories;
  List<Expenses>? expenses;

  ///Returns the budget value
  Future<Budget> getBudget() {
    return budget as Future<Budget>;
  }

  Map<String, dynamic>? categoriesPriceJson;
  List<Map<String, int>> categoriesPriceList = [];

  String? selectedBudget;
  String? selectedInsights;
  int? selectedBudgetIndex;

  ///This will store the selected budget, this will be
  ///used to display it in the homepage appbar
  void setSelectedBudget(String selectedBudget) {
    this.selectedBudget = selectedBudget;
    selectedInsights = selectedBudget;
    notifyListeners();
  }

  ///This will selected value from the insights page to the selectedInsights
  ///(i.e)When the user taps on the below label in the bar chart this will be triggered
  void setSelectedInsights(String selectedText) {
    selectedInsights = selectedText;
    notifyListeners();
  }

  ///This will store the selected budget index, used later to
  ///fetch the budget and the category and the total details
  void setSelectedIndex(int index) {
    selectedBudgetIndex = index;
    notifyListeners();
  }

//Stores the Raw data (i.e) the total json string
  void setRawData(data) {
    categoriesPriceJson = data;
    notifyListeners();
  }

  int total = 0;
  int balance = 0;
  int budgetAmount = 0;

  ///This will retrieve the balance based on the given index
  ///As a result it will be stored in the Cost Remaining Container in the Home page
  void getBalance(int index) {
    print("Budget : ${budget!.budgets[index].budgetamount}");
    print("Total : $total");
    budgetAmount = budget!.budgets[index].budgetamount;
    balance = budgetAmount - total;
    notifyListeners();
  }

  ///Sets the total value, which is the total (sum of the spent categories price)
  void setTotal(int total) {
    this.total = total;
    notifyListeners();
  }

  ///Sets the list of budgetnames from the payload
  ///Stores the json value as dart object in the [budget]
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

  ///This will set the List of Category names into [categories]
  void setCategories(String payload) {
    if (payload.isNotEmpty) {
      categories = categoriesFromJson(payload);
      notifyListeners();
    } else {
      categories = [];
    }
  }

  ///This will set the Every budget's total spent cost and the history of data
  ///which is then filtered based on the requirement
  void setExpenses(String payload) {
    if (payload.isNotEmpty) {
      expenses = expensesFromJson(payload);
      notifyListeners();
    } else {
      expenses = [];
    }
  }

  ///Resets all the values to its initial State
  ///Triggered when the existing user logout
  ///Resets the memory and makes new memory for the new User;
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

///This Function is used to send POST request to the server
///Endpoint "/user" [POST]
///When the new user is created this function is invoked
///the request body contains
///uid ==> Generated from Firebase
///email ==> Given by user
///displayName ==> Given by user
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

///This function is used to send GET request to the server
///Endpoint "/budgets/user/:userid" [GET]
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

///This function is used to send GET request to the server
///Endpoint "/expenses/total-by-category/:budgetname/:userid" [GET]
///This will retrieve the data and stores it in the provider
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

///This function is used to send GET request to the server
///Endpoint "/categories/user/:userid" [GET]
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

///This function is used to send GET request to the server
///Endpoint "/expenses/user/:userid" [GET]
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

///This function is used to send DELETE request to the server
///Endpoint "/expenses/:expenseId" [DELETE]
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
