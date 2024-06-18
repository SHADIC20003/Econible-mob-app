import 'package:flutter/material.dart';
import 'package:trackizer/common/color_extension.dart';

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
  void dispose() {
    _goalNameController.dispose();
    _goalDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveGoal() async {
    // Make API call to save goal data
    // ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Goals', style: TextStyle(color: Colors.white)),
        backgroundColor: TColor.gray,
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
                  onSaved: (value) => _goalNameController.text = value!,
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
                  onSaved: (value) => _goalDescriptionController.text = value!,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        _goals.add({
                          'name': _goalNameController.text,
                          'description': _goalDescriptionController.text,
                          'achieved': false,
                        });
                      });
                      _goalNameController.clear();
                      _goalDescriptionController.clear();
                      await _saveGoal();
                    }
                  },
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
                                      setState(() {
                                        goal['achieved'] = value!;
                                      });
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
                              setState(() {
                                _goals.removeAt(index);
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
