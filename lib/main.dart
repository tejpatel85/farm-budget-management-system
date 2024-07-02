import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(FarmManagementApp());
}

class Farm {
  final String name;

  Farm({required this.name});
}

class FarmManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Management System',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 20.0),
          bodyText2: TextStyle(fontSize: 16.0),
        ),
      ),
      home: AuthenticationPage(),
    );
  }
}

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isAuthenticated = false;

  void _authenticate() {
    // For simplicity, check if username is 'admin' and password is 'password'
    if (_usernameController.text == 'admin' && _passwordController.text == 'password') {
      setState(() {
        _isAuthenticated = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomePage(),
        ),
      );
    } else {
      // Show an error dialog if authentication fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Authentication Failed'),
            content: Text('Invalid username or password. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Farmer!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FarmSelectionPage(),
                  ),
                );
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class FarmSelectionPage extends StatefulWidget {
  @override
  _FarmSelectionPageState createState() => _FarmSelectionPageState();
}

class _FarmSelectionPageState extends State<FarmSelectionPage> {
  late TextEditingController _farmNameController;
  List<Farm> farms = [];

  @override
  void initState() {
    super.initState();
    _farmNameController = TextEditingController();
  }

  @override
  void dispose() {
    _farmNameController.dispose();
    super.dispose();
  }

  void _addFarm(String farmName) {
    setState(() {
      farms.add(Farm(name: farmName));
    });
    Navigator.of(context).pop(); // Close the dialog
  }

  void _deleteFarm(Farm farm) {
    setState(() {
      farms.remove(farm);
    });
  }

  void _showAddFarmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Farm'),
          content: TextField(
            controller: _farmNameController,
            decoration: InputDecoration(
              labelText: 'Farm Name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _addFarm(_farmNameController.text);
                _farmNameController.clear();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToManagementPage(Farm farm) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FarmManagementPage(farm: farm),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farm Selection'),
        actions: [
          IconButton(
            onPressed: _showAddFarmDialog,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], // Set a light background color
        ),
        child: ListView.builder(
          itemCount: farms.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: InkWell(
                onTap: () {
                  _navigateToManagementPage(farms[index]);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green[200], // Set a larger background color for the farm tile
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        farms[index].name,
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteFarm(farms[index]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


class FarmManagementPage extends StatelessWidget {
  final Farm farm;

  FarmManagementPage({required this.farm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage ${farm.name}'),
        backgroundColor: Colors.green[700],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Budget Management'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BudgetPage(title: 'Farm Budget for ${farm.name}'),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Fertilizer Management'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FertilizerManagementPage(title: 'Fertilizer Management for ${farm.name}'),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Electricity Management'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ElectricityManagementPage(title: 'Electricity Management for ${farm.name}'),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Labour Management'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LabourManagementPage(title: 'Labour Management for ${farm.name}'),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Loan Management'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoanManagementPage(title: 'Loan Management for ${farm.name}'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BudgetPage extends StatefulWidget {
  final String title;

  BudgetPage({Key? key, required this.title}) : super(key: key);

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final TextEditingController _productController = TextEditingController();
  DateTime _selectedDate = DateTime.now(); // Initialize with current date
  final TextEditingController _amountController = TextEditingController();

  List<Map<String, dynamic>> recordBook = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _productController,
              decoration: InputDecoration(
                labelText: 'Product',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Date'),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null && pickedDate != _selectedDate) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String product = _productController.text;
              double amount = double.parse(_amountController.text);

              setState(() {
                recordBook.add({
                  'product': product,
                  'date': _selectedDate,
                  'amount': amount,
                });
                _productController.clear();
                _amountController.clear();
              });
            },
            child: Text('Add Expense'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text('Product'),
                  ),
                  DataColumn(
                    label: Text('Date'),
                  ),
                  DataColumn(
                    label: Text('Amount'),
                  ),
                ],
                rows: recordBook
                    .map((record) => DataRow(cells: [
                  DataCell(Text(record['product'])),
                  DataCell(Text(DateFormat('yyyy-MM-dd').format(record['date']))),
                  DataCell(Text('\$${record['amount'].toStringAsFixed(2)}')),
                ]))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Add other management pages here





class FertilizerManagementPage extends StatefulWidget {
  final String title;

  FertilizerManagementPage({Key? key, required this.title}) : super(key: key);

  @override
  _FertilizerManagementPageState createState() =>
      _FertilizerManagementPageState();
}

class _FertilizerManagementPageState extends State<FertilizerManagementPage> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _costController;
  late DateTime _selectedDate;

  List<Map<String, dynamic>> recordBook = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _quantityController = TextEditingController();
    _costController = TextEditingController();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _addEntry() {
    final name = _nameController.text;
    final quantity = double.tryParse(_quantityController.text) ?? 0.0;
    final cost = double.tryParse(_costController.text) ?? 0.0;

    setState(() {
      recordBook.add({
        'name': name,
        'quantity': quantity,
        'cost': cost,
        'date': _selectedDate,
      });

      // Clear controllers after adding entry
      _nameController.clear();
      _quantityController.clear();
      _costController.clear();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity Purchased'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _costController,
              decoration: InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Date: '),
                Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addEntry,
              child: Text('Add Entry'),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Cost')),
                    DataColumn(label: Text('Date')),
                  ],
                  rows: recordBook
                      .map(
                        (entry) => DataRow(cells: [
                      DataCell(Text(entry['name'])),
                      DataCell(Text(entry['quantity'].toString())),
                      DataCell(Text(entry['cost'].toString())),
                      DataCell(Text(
                          DateFormat('yyyy-MM-dd').format(entry['date']))),
                    ]),
                  )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ElectricityManagementPage extends StatefulWidget {
  final String title;

  ElectricityManagementPage({Key? key, required this.title}) : super(key: key);

  @override
  _ElectricityManagementPageState createState() => _ElectricityManagementPageState();
}

class _ElectricityManagementPageState extends State<ElectricityManagementPage> {
  double unitPrice = 0.50;
  double unitsProduced = 0.0;
  List<double> recordBook = [];

  void _updateUnitsProduced(double newUnitsProduced) {
    setState(() {
      unitsProduced = newUnitsProduced;
      recordBook.add(unitsProduced);
    });
  }

  double _calculateTotalCost() {
    return unitPrice * unitsProduced;
  }

  @override
  Widget build(BuildContext context) {
    double totalCost = _calculateTotalCost();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Unit Price: \$${unitPrice.toStringAsFixed(2)}',
            ),
            DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Units Produced',
                  ),
                ),
              ],
              rows: recordBook.map((record) => DataRow(
                cells: <DataCell>[
                  DataCell(Text('${record.toStringAsFixed(2)}')),
                ],
              )).toList(),
            ),
            Text(
              'Total Cost: \$${totalCost.toStringAsFixed(2)}',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          double tempUnitsProduced = 0.0;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Update Units Produced'),
                content: TextField(
                  onChanged: (value) {
                    tempUnitsProduced = double.parse(value);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "Enter New Units Produced"),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Submit'),
                    onPressed: () {
                      _updateUnitsProduced(tempUnitsProduced);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}



class LabourManagementPage extends StatefulWidget {
  final String title;

  LabourManagementPage({Key? key, required this.title}) : super(key: key);

  @override
  _LabourManagementPageState createState() => _LabourManagementPageState();
}

class _LabourManagementPageState extends State<LabourManagementPage> {
  Map<String, List<dynamic>> daysWorked = {};
  List<String> recordBook = [];

  void _updateDaysWorked(String name, DateTime? startDate, DateTime? endDate, double amountPaid) {
    setState(() {
      daysWorked[name] = [startDate!, endDate!, amountPaid];
      recordBook.add(name);
    });
  }

  String _formatDate(DateTime? date) {
    return date != null ? DateFormat('yyyy-MM-dd').format(date) : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Name',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Days Worked',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Amount Paid',
                  ),
                ),
              ],
              rows: daysWorked.keys.map((name) => DataRow(
                cells: <DataCell>[
                  DataCell(Text(name)),
                  DataCell(
                    Text(
                      '${_formatDate(daysWorked[name]![0])} - ${_formatDate(daysWorked[name]![1])}',
                    ),
                  ),
                  DataCell(Text('\$${daysWorked[name]![2].toStringAsFixed(2)}')),
                ],
              )).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String tempName = '';
          DateTime? tempStartDate;
          DateTime? tempEndDate;
          double tempAmountPaid = 0.0;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Update Days Worked'),
                content: Column(
                  children: <Widget>[
                    TextField(
                      onChanged: (value) {
                        tempName = value;
                      },
                      decoration: InputDecoration(hintText: "Enter Worker's Name"),
                    ),
                    ListTile(
                      title: Text('Start Date'),
                      subtitle: Text(tempStartDate == null
                          ? 'Select Start Date'
                          : _formatDate(tempStartDate)),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            tempStartDate = pickedDate;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text('End Date'),
                      subtitle: Text(tempEndDate == null
                          ? 'Select End Date'
                          : _formatDate(tempEndDate)),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            tempEndDate = pickedDate;
                          });
                        }
                      },
                    ),
                    TextField(
                      onChanged: (value) {
                        tempAmountPaid = double.parse(value);
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: "Enter Amount Paid"),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Submit'),
                    onPressed: () {
                      if (tempStartDate != null && tempEndDate != null) {
                        _updateDaysWorked(tempName, tempStartDate, tempEndDate, tempAmountPaid);
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select start and end dates.'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}



class LoanManagementPage extends StatefulWidget {
  final String title;

  LoanManagementPage({Key? key, required this.title}) : super(key: key);

  @override
  _LoanManagementPageState createState() => _LoanManagementPageState();
}

class _LoanManagementPageState extends State<LoanManagementPage> {
  double interestRate = 0.10; // 10% interest rate
  Map<String, Map<String, double>> loans = {};

  void _addLoan(String name, double amount, double timePeriod) {
    setState(() {
      loans[name] = {
        'amount': amount,
        'timePeriod': timePeriod,
        'totalRepayment': amount * (1 + interestRate * timePeriod),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Interest Rate: ${interestRate * 100}%',
            ),
            ...loans.keys.map((name) => Text(
              '$name: Loan Amount: \$${loans[name]?['amount']?.toStringAsFixed(2)}, Time Period: ${loans[name]?['timePeriod']?.toStringAsFixed(2)} years, Total Repayment: \$${loans[name]?['totalRepayment']?.toStringAsFixed(2)}',
            )).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String tempName = '';
          double tempAmount = 0.0;
          double tempTimePeriod = 0.0;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Loan'),
                content: Column(
                  children: <Widget>[
                    TextField(
                      onChanged: (value) {
                        tempName = value;
                      },
                      decoration: InputDecoration(hintText: "Enter Borrower's Name"),
                    ),
                    TextField(
                      onChanged: (value) {
                        tempAmount = double.parse(value);
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: "Enter Loan Amount"),
                    ),
                    TextField(
                      onChanged: (value) {
                        tempTimePeriod = double.parse(value);
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: "Enter Time Period in Years"),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Submit'),
                    onPressed: () {
                      _addLoan(tempName, tempAmount, tempTimePeriod);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}









