import 'package:flutter/material.dart';
import 'package:weight_tracker/screens/add_record_screen.dart';
import 'package:weight_tracker/behaviour/weight_model.dart';
import 'package:weight_tracker/behaviour/database_helper.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<WeightEntry>> _weightEntries;

  @override
  void initState() {
    super.initState();
    _refreshEntries();
  }

  void _refreshEntries() {
    setState(() {
      _weightEntries = DatabaseHelper().getWeights();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Головна'),
        backgroundColor: Color.fromRGBO(1, 82, 181, 1),
        foregroundColor: Color.fromRGBO(255, 255, 255, 1),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: _weightEntries,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final entries = snapshot.data!;

          entries.sort((a, b) {
            DateTime dateA = DateFormat('dd.MM.yyyy').parse(a.date);
            DateTime dateB = DateFormat('dd.MM.yyyy').parse(b.date);

            return dateB.compareTo(dateA);
          });

          if (entries.isEmpty) {
            return Center(child: Text('Записів немає.', style: TextStyle(fontSize: 30),));
          }

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Card(
                margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
                child: ListTile(
                  title: Text('${entry.weight} кг'),
                  subtitle: Text(entry.date),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Color.fromRGBO(0, 0, 0, 1)),
                    onPressed: () async {
                      await DatabaseHelper().deleteWeight(entry.id!);
                      _refreshEntries();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddrecordScreen()));
          _refreshEntries();
        }, 
        backgroundColor: Color.fromRGBO(27, 124, 243, 1), 
        child: Icon(Icons.add, color: Color.fromRGBO(255, 255, 255, 1),),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
