class WeightEntry {
  int? id;
  double? weight;
  String date;

  WeightEntry({this.id, required this.weight, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'weight' : weight,
      'date' : date,
    };
  }

  factory WeightEntry.fromMap(Map<String, dynamic> map) {
    return WeightEntry(id: map['id'], weight: map['weight'], date: map['date']);
  }
}