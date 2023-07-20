// ignore_for_file: unused_local_variable

import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/category_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:http/http.dart" as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../models/expense_model.dart';
import '../models/expensemethod_model.dart';

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
  double filteredAmount = 0;

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

  bool isNewUser = false;

  ///Sets true if the user is new
  void setNewUser(bool value) {
    isNewUser = value;
    notifyListeners();
  }

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

  ///Chart Data Response is stored here
  ///Due to dynamic mapping of keys it is stored as Map<String,dynamic>
  Map<String, dynamic> expenseSummary = {};

  ///Expense methods are stored here
  List<ExpenseMethod> expenseMethods = [];

  ///Default Expense Method
  ExpenseMethod? defaultExpenseMethod;

  ///FilteredExpenses
  List<Expenses>? filteredExpenses;
  List<Expenses>? unsortedExpenses;

  bool isFilterCleared = true;

  ///SelectedFilteredList
  Map<String, int> selectedRadioButtons = {
    "Budget": -1,
    "Category": -1,
    "Expense": -1,
  };

  Map<String, String> selectedRadioButtonsData = {
    "Budget": "",
    "Category": "",
    "Expense": "",
  };

  bool isAscending = false;
  bool isDescending = false;

  void setAscending(bool value) {
    isAscending = value;
    notifyListeners();
  }

  void setDescending(bool value) {
    isDescending = value;
    notifyListeners();
  }

  void changeToUnsorted() {
    filteredExpenses = [...unsortedExpenses!];
    notifyListeners();
  }

  void setSearchResults(List<Expenses> expense) {
    filteredExpenses = expense;
    filteredAmount = 0;
    for (var element in filteredExpenses!) {
      filteredAmount += element.expensecost;
    }
    notifyListeners();
  }

  bool isDateChanged = false;
  DateTime? startDate;
  DateTime? endDate;

  void setStartDate(DateTime date) {
    startDate = date;
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    endDate = date;
    notifyListeners();
  }

  ///This will retrieve the balance based on the given index
  ///As a result it will be stored in the Cost Remaining Container in the Home page
  void getBalance(int index) {
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
      filteredExpenses = expensesFromJson(payload);

      ///These lines would remember the filters when changing the screens
      /* String selectedBudget = selectedRadioButtonsData["Budget"]!;
      String selectedCategory = selectedRadioButtonsData["Category"]!;
      String selectedExpenseMethod = selectedRadioButtonsData["Expense"]!;
      print(selectedBudget);
      print(selectedCategory);
      print(selectedExpenseMethod);

    
       var result = filterFunction(selectedBudget, filteredExpenses!,
          selectedCategory, selectedExpenseMethod, startDate, endDate);
      print('Inside the Setter Expense Method');
      filteredExpenses = [...result]; */

      isAscending = false;
      isDescending = false;
      unsortedExpenses = [...filteredExpenses!];
      filteredAmount = 0;

      filteredExpenses = filteredExpenses!.where(
        (element) {
          return element.budgetname == selectedBudget;
        },
      ).toList();

      for (var element in filteredExpenses!) {
        filteredAmount += element.expensecost;
      }

      // print(filteredExpenses);
      notifyListeners();
    } else {
      print('Inside the Setter Else Expense Method');
      expenses = [];
      notifyListeners();
    }
  }

  ///Stores the selected data from radio button
  void setSelectedRadioData(String name, int value, String selectedData) {
    selectedRadioButtons[name] = value;
    selectedRadioButtonsData[name] = selectedData;
    notifyListeners();
  }

  // void setfilteredData(List<Expenses> filteredExpensesData) {
  //   filteredExpenses = filteredExpensesData;
  //   // unsortedExpenses = filteredExpensesData;
  //   notifyListeners();
  // }

  void resetFilteredData() {
    filteredExpenses = expenses;
    startDate = null;
    endDate = null;
    selectedRadioButtons = {
      "Budget": -1,
      "Category": -1,
      "Expense": -1,
    };
    selectedRadioButtonsData = {
      "Budget": "",
      "Category": "",
      "Expense": "",
    };

    notifyListeners();
  }

  void setFilteredData(List<Expenses> expenses) {
    print(expenses.length);
    filteredExpenses = expenses;
    filteredAmount = 0;
    for (var element in expenses) {
      filteredAmount += element.expensecost;
    }
    unsortedExpenses = expenses;
    notifyListeners();
  }

  ///To set the expense summary
  void setExpenseSummary(String payload) {
    expenseSummary = jsonDecode(payload);
    notifyListeners();
  }

  ///To set the expense methods
  void setExpenseMethods(String payload) {
    expenseMethods = expenseMethodFromJson(payload);
    for (int i = 0; i < expenseMethods.length; i++) {
      if (expenseMethods[i].emisdefault) {
        defaultExpenseMethod = expenseMethods[i];
        break;
      }
    }

    // print(defaultExpenseMethod);
    notifyListeners();
  }

  ///Resets all the values to its initial State
  ///Triggered when the existing user logout
  ///Resets the memory and makes new memory for the new User;
  @override
  void disposeValues() {
    filteredAmount = 0;
    bottomnavIndex = 0;
    budget = null;
    categories = null;
    expenses = [];
    categoriesPriceJson = null;
    categoriesPriceList = [];

    selectedBudget = null;
    selectedInsights = null;
    selectedBudgetIndex = 0;
    total = 0;
    balance = 0;
    budgetAmount = 0;
    expenseSummary = {};
    expenseMethods = [];
    filteredExpenses = [];
    startDate = null;
    endDate = null;
    selectedRadioButtons = {
      "Budget": -1,
      "Category": -1,
      "Expense": -1,
    };

    selectedRadioButtonsData = {
      "Budget": "",
      "Category": "",
      "Expense": "",
    };
    startDate = null;
    endDate = null;
    isAscending = false;
    isDescending = false;
    unsortedExpenses = [];

    isNewUser = false;
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
    // print("Success in Creating user");
  } else {
    // print(res.body);
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
    // print("Success in getting header");
    provider.setBudgets(res.body);
    await getExpenseMethods(provider);
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
  // print(budgetname);
  if (res.statusCode == 200) {
    print("Success in getting total");
    final data = json.decode(res.body);
    // print(data);
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
    //print(res.body);

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
    provider.resetFilteredData();
    provider.setExpenses(res.body);
    print(res.body);
    return res.body;
  }
  if (res.statusCode == 404) {
    print("New User Expense");
    // print(res.body);
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

///To get the Expense Summary
///Endpoint "/expenses/summary/:userid" [GET]
Future<String> getSummary(BackEndProvider provider) async {
  var res = await http.get(Uri.parse(
      "$SERVER_URL/expenses/summary/${FirebaseAuth.instance.currentUser!.uid}"));
  // print(res.body);
  if (res.statusCode == 200) {
    print("Success in getting summary");
    provider.setExpenseSummary(res.body);
    return res.body;
  }
  return "";
}

///This function is used to send PUT request to the server
///Endpoint "/budgets/:budgetid" [PUT]
Future<void> updateBudget(BackEndProvider provider, Budget budget, int index,
    int budgetamount) async {
  String budgetId = budget.budgets[index].budgetid.toString();
  String budgetname = budget.budgets[index].budgetname;
  String budgetcreated = DateTime.now().toIso8601String();

  var res = await http.put(Uri.parse("$SERVER_URL/budgets/$budgetId"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "userid": FirebaseAuth.instance.currentUser!.uid,
        "budgetname": budgetname,
        "budgetamount": budgetamount,
        "budgetcreated": budgetcreated,
      }));
  var data = {
    "userid": FirebaseAuth.instance.currentUser!.uid,
    "budgetname": budgetname,
    "budgetamount": budgetamount,
    "budgetcreated": budgetcreated,
  };
  print(data);
  print(res.statusCode);
  print(res.body);
  if (res.statusCode == 200) {
    await getBudgetData(provider);
  }
}

///This function is used to send DELETE request to the server
///Endpoint "/expenses/:expenseId" [DELETE]
Future<String> deleteExpenses(
    String expenseId, BackEndProvider provider) async {
  var res = await http.delete(
    Uri.parse("$SERVER_URL/expenses/$expenseId"),
  );
  // print(res.body);
  if (res.statusCode == 200) {
    print("Deleted Successfully");
    await getExpenses(provider);
    return "Deleted Successfully";
  }
  return "Error Occured!";
}

///Create the Expense Method [POST]
///Endpoint "/expensemethod"
Future<void> createExpenseMethod(
    {BackEndProvider? provider,
    String? emname,
    String? emdetail,
    String? emshortname,
    bool? emisdefault}) async {
  var res = await http.post(Uri.parse("$SERVER_URL/expensemethod"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "userid": FirebaseAuth.instance.currentUser!.uid,
        "emname": emname,
        "emdetail": emdetail,
        "emshortname": emshortname,
        "emisdefault": emisdefault,
        "emcreated": DateTime.now().toIso8601String()
      }));

  // print(res.body);
  getExpenseMethods(provider!);
}

///Creates the new budget for the user
///Endpoint "/createnewbudget/:userid" [POST]
Future<void> createNewBudget(provider) async {}

///Creates the initial budget for the user
///Endpoint "/budgets" [POST]
Future<void> createInitialBudget(provider, int amount) async {
  String budgetname = DateFormat('MMMM yyyy').format(DateTime.now());
  String time = DateTime.now().toIso8601String();

  print(budgetname);

  var res = await http.post(
    Uri.parse("$SERVER_URL/budgets"),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode({
      "userid": FirebaseAuth.instance.currentUser!.uid,
      "budgetname": budgetname,
      "budgetamount": amount,
      "budgetcreated": time
    }),
  );
  await getBudgetData(provider);
}

///To get the expense methods
///Endpoint "/expensemethods/user/:userid" [GET]
Future<String> getExpenseMethods(BackEndProvider provider) async {
  var res = await http.get(Uri.parse(
      "$SERVER_URL/expensemethods/user/${FirebaseAuth.instance.currentUser!.uid}"));

  if (res.statusCode == 200) {
    print("Success in getting expensemethods");
    // print(res.body);
    provider.setExpenseMethods(res.body);
    return res.body;
  }
  return "";
}

///Change the Expense Method of Expense
///Endpoint "/expense/:expenseid" [PUT]
Future<void> changeExpenseMethod(
    {String? expenseid,
    String? emdetail,
    String? emname,
    String? emshortname,
    BackEndProvider? provider}) async {
  var res = await http.put(
    Uri.parse("$SERVER_URL/expense/$expenseid"),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(
      {
        "emname": emname,
        "emdetail": emdetail,
        "emshortname": emshortname,
      },
    ),
  );
  // print(res.statusCode);
  print("Changing expense method");
  // print(res.body);
  await getExpenses(provider!);
}

Future<void> changeNotes(
    {String? expenseNotes,
    String? expenseId,
    BackEndProvider? provider}) async {
  var res = await http.put(
    Uri.parse("$SERVER_URL/expense/$expenseId"),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(
      {
        "expensenotes": expenseNotes,
      },
    ),
  );

  ///Commented to improve performances
  // await getExpenses(provider!);
}

Future<void> changeRecurring(
    {bool? recurring, String? expenseId, BackEndProvider? provider}) async {
  print(recurring);
  var res = await http.put(
    Uri.parse("$SERVER_URL/expense/$expenseId"),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(
      {
        "recurring": recurring,
      },
    ),
  );

  print(res.body);

  ///Commented to improve performances
  // await getExpenses(provider!);
}

///Changes the default expense method
///Endpoint "/expensemethods/:emid" [PUT]
Future<void> changeDefault(
    String emid, bool emisdefault, BackEndProvider provider) async {
  var res = await http.put(Uri.parse("$SERVER_URL/expensemethods/$emid"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({"emisdefault": emisdefault}));
  print("Changing Default ==> ${res.statusCode}");
  if (res.statusCode == 500) {
    print("Something went wrong ");
  }
  if (emisdefault == true && res.statusCode == 200) {
    await getExpenseMethods(provider);
  }
  // print(res.body);
}

///Delete the expense method
///Endpoint "/expensemethods/:emid" [DELETE]
Future<void> deleteExpenseMethod(String emid, BackEndProvider provider) async {
  var res = await http.delete(
    Uri.parse("$SERVER_URL/expensemethods/$emid"),
  );
  // print(res.body);
  if (res.statusCode == 200) {
    print("Deleted Successfully");
    await getExpenseMethods(provider);
  }
}
