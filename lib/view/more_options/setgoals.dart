import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:trackizer/sqldb.dart';

class SetGoalsPage extends StatefulWidget {
  @override
  _SetGoalsPageState createState() => _SetGoalsPageState();
}

class _SetGoalsPageState extends State<SetGoalsPage> {
  final _formKey = GlobalKey<FormState>();
  final _goalNameController = TextEditingController();
  final _goalDescriptionController = TextEditingController();
  List<Map<String, dynamic>> _goals = [];

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  @override
  void dispose() {
    _goalNameController.dispose();
    _goalDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadGoals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? goalsString = prefs.getString('goals');
    if (goalsString != null) {
      setState(() {
        _goals = List<Map<String, dynamic>>.from(json.decode(goalsString));
      });
    }
  }

  Future<void> _saveGoals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('goals', json.encode(_goals));
  }
final SqlDb sqldb = SqlDb();
  String? email = '';
  Future<void> _addGoal() async {
    if (_formKey.currentState!.validate()) {
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                  email = sharedPreferences.getString('current_email');
      if (email != null && email!.isNotEmpty) {
       //List<Map<String, dynamic>> data = await sqldb.readData("SELECT * FROM Expense WHERE userEmail = '$email' ");
        //print('$data');
          int response = await sqldb.insertData(
                        "INSERT INTO 'Goal' ('userEmail','title','description') VALUES ('$email','${_goalNameController.text}','${_goalDescriptionController.text}')",
                      );
         //print('$response');     
          List<Map<String, dynamic>> bigData = await sqldb.readData("SELECT * FROM 'Goal' where userEmail='$email'");
          //print("$bigData");
      }
      _formKey.currentState!.save();
      setState(() {
        _goals.add({
          'name': _goalNameController.text,
          'description': _goalDescriptionController.text,
          'achieved': false,
        });
        _goalNameController.clear();
        _goalDescriptionController.clear();
      });
      await _saveGoals();
    }
  }

  Future<void> _deleteGoal(int index) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      email = sharedPreferences.getString('current_email');
      if (email != null && email!.isNotEmpty) {
            int response = await sqldb.deleteData("DELETE FROM Goal WHERE title = '${_goals[index]['name']}' AND userEmail = '$email'");
                                    
         //print('$response');     
          List<Map<String, dynamic>> bigData = await sqldb.readData("SELECT * FROM 'Goal' where userEmail='$email'");
          //print("$bigData");
      }
    setState(() {
      _goals.removeAt(index);
    });
    await _saveGoals();
  }

  Future<void> _toggleAchieved(int index) async {
    setState(() {
      _goals[index]['achieved'] = !_goals[index]['achieved'];
    });
    await _saveGoals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Goals', style: TextStyle(color: Colors.white)),
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
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Goal Name',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter goal name';
                    }
                    return null;
                  },
                  controller: _goalNameController,
                ),
                SizedBox(height: 20),
                TextFormField(
                  maxLines: 3,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Goal Description',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter goal description';
                    }
                    return null;
                  },
                  controller: _goalDescriptionController,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addGoal,
                  child: Text('Set Goal', style: TextStyle(fontSize: 18, color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                SizedBox(height: 20),
                if (_goals.isNotEmpty) ...[
                  Text(
                    'Goals',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _goals.length,
                    itemBuilder: (context, index) {
                      final goal = _goals[index];
                      return Card(
                        color: Color.fromRGBO(70, 70, 70, 1),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text(goal['name'], style: TextStyle(color: Colors.white)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(goal['description'], style: TextStyle(color: Colors.white70)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Achieved: ${goal['achieved'] ? 'Yes' : 'No'}',
                                    style: TextStyle(color: goal['achieved'] ? Colors.greenAccent : Colors.redAccent),
                                  ),
                                  Checkbox(
                                    value: goal['achieved'],
                                    onChanged: (value) {
                                      _toggleAchieved(index);
                                    },
                                    activeColor: Colors.blueAccent,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              _deleteGoal(index);
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

class TColor {
  static const gray = Color(0xFF212121);
  static const gray70 = Color(0xFF333333);
  static const gray30 = Color(0xFF8F8F8F);
  static const gray60 = Color(0xFF646464);
  static const white = Color(0xFFFFFFFF);
}
