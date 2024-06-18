import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackizer/common/color_extension.dart';

class RemindersPage extends StatefulWidget {
  @override
  _RemindersPageState createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final _expenseDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _expenseName = '';
  String _expenseDate = '';
  String _expenseAmount = '';
  DateTime? _selectedDate;

  List<Map<String, String>> _reminders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders', style: TextStyle(color: Colors.white)),
        backgroundColor: TColor.gray70,
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
                  onSaved: (value) => _expenseName = value!,
                ),
                SizedBox(height: 20),
                TextFormField(
                  readOnly: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Expense Date',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                    ),
                  ),
                  controller: _expenseDateController,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                        _expenseDate = DateFormat('yyyy-MM-dd').format(picked);
                        _expenseDateController.text = _expenseDate;
                      });
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please select expense date';
                    }
                    return null;
                  },
                  onSaved: (value) => _expenseDate = value!,
                ),
                SizedBox(height: 20),
                TextFormField(
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
                  onSaved: (value) => _expenseAmount = value!,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        _reminders.add({
                          'name': _expenseName,
                          'date': _expenseDate,
                          'amount': _expenseAmount,
                        });
                      });
                      _expenseDateController.clear();
                      _formKey.currentState!.reset();
                    }
                  },
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
                          title: Text(reminder['name']!, style: TextStyle(color: Colors.white)),
                          subtitle: Text(
                            'Date: ${reminder['date']} - Amount: ${reminder['amount']}',
                            style: TextStyle(color: Colors.white70),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              setState(() {
                                _reminders.removeAt(index);
                              });
                            },
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
