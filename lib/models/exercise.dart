class Exercise {
  final String name;
  final int? reps;
  final int? sets;
  final int? weight;
  final int? restingTime;

  Exercise({
    required this.name,
    this.reps,
    this.sets,
    this.weight,
    this.restingTime,
  });

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'],
      reps: map['reps'],
      sets: map['sets'],
      weight: map['weight'],
      restingTime: map['resting_time'],
    );
}
}
