import 'package:flutter/material.dart';
import 'package:weight_tracker/behaviour/database_helper.dart';
import 'package:weight_tracker/behaviour/weight_model.dart';
import 'package:intl/intl.dart';
import 'package:weight_tracker/screens/home_screen.dart';

class AddrecordScreen extends StatefulWidget {
  const AddrecordScreen({super.key});

  @override
  State<AddrecordScreen> createState() => _AddrecordScreenState();
}

class _AddrecordScreenState extends State<AddrecordScreen> {
  final TextEditingController _entryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            AppBar(
              title: Text('Додавання запису'),
            ),

            Padding(
              padding: EdgeInsets.all(20.0), 
              child: TextField(
                controller: _entryController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(1, 82, 181, 1)
                    )
                  ),
                  labelText: 'Вага',
                  floatingLabelStyle: TextStyle(
                    color: Color.fromRGBO(1, 82, 181, 1)
                  )
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22), 
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    double? weight = double.tryParse(_entryController.text);
                    if (weight != null) {
                      DateTime dateTimeNow = DateTime.now();
                      String formattedDate = DateFormat('dd.MM.yyyy').format(dateTimeNow);
                      WeightEntry weightEntry = WeightEntry(weight: weight, date: formattedDate);
                      DatabaseHelper().insertWeight(weightEntry);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Помилка! Перевірте введені дані на коректність.')
                        )
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color.fromRGBO(0, 0, 0, 1),
                  ),
                  child: Text('Додати'),
                ),
              ),
            )
          
          ],
        )
      ),
    );
  }
}