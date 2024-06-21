import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/view/more_options/sqldbreminders.dart'; // Import the SQL database helper class

class RemindersPage extends StatefulWidget {
  @override
  _RemindersPageState createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final _expenseDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _expenseNameController = TextEditingController();
  final _expenseAmountController = TextEditingController();
  List<Map<String, dynamic>> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  @override
  void dispose() {
    _expenseDateController.dispose();
    _expenseNameController.dispose();
    _expenseAmountController.dispose();
    super.dispose();
  }

  Future<void> _loadReminders() async {
    final SqlDb sqlDb = SqlDb();
    final List<Map<String, dynamic>> reminders = await sqlDb.getReminders();
    setState(() {
      _reminders = reminders;
    });
  }

  Future<void> _addReminder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final SqlDb sqlDb = SqlDb();
      await sqlDb.insertReminder({
        'name': _expenseNameController.text,
        'date': _expenseDateController.text,
        'amount': _expenseAmountController.text,
      });
      _expenseNameController.clear();
      _expenseDateController.clear();
      _expenseAmountController.clear();
      _loadReminders();
    }
  }

  Future<void> _deleteReminder(int id) async {
    final SqlDb sqlDb = SqlDb();
    await sqlDb.deleteReminder(id);
    _loadReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(80, 80, 80, 75),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: TColor.gray70,
        ),
        child: Padding(
          padding: const EdgeInsets.all(45.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _expenseNameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Expense Name',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter expense name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  readOnly: true,
                  controller: _expenseDateController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Expense Date',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                    ),
                  ),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() {
                        _expenseDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                      });
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please select expense date';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _expenseAmountController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Expense Amount',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter expense amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addReminder,
                  child: Text('Add Reminder', style: TextStyle(fontSize: 18, color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                SizedBox(height: 20),
                if (_reminders.isNotEmpty) ...[
                  Text(
                    'Reminders',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = _reminders[index];
                      return Card(
                        color: Color.fromRGBO(70, 70, 70, 1),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text(reminder['name'], style: TextStyle(color: Colors.white)),
                          subtitle: Text(
                            'Date: ${reminder['date']} - Amount: ${reminder['amount']}',
                            style: TextStyle(color: Colors.white70),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _deleteReminder(reminder['id']),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TColor {
  static const gray = Color(0xFF212121);
  static const gray70 = Color(0xFF333333);
  static const gray30 = Color(0xFF8F8F8F);
  static const gray60 = Color(0xFF646464);
  static const white = Color(0xFFFFFFFF);
}

