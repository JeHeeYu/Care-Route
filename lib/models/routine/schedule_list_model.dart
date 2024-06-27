class ScheduleListModel {
  int statusCode;
  String message;
  List<Routine> routines;

  ScheduleListModel({
    required this.statusCode,
    required this.message,
    required this.routines,
  });

  factory ScheduleListModel.fromJson(Map<String, dynamic> json) {
    return ScheduleListModel(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      routines: json['routines'] != null
          ? List<Routine>.from(json['routines'].map((routine) => Routine.fromJson(routine)))
          : [],
    );
  }
}


class Routine {
  int routineId;
  String title;
  String content;
  String startDate;
  String endDate;
  double startLatitude;
  double startLongitude;
  List<Destination> destinations;
  bool roundTrip;

  Routine({
    required this.routineId,
    required this.title,
    required this.content,
    required this.startDate,
    required this.endDate,
    required this.startLatitude,
    required this.startLongitude,
    required this.destinations,
    required this.roundTrip,
  });

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      routineId: json['routineId'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      startLatitude: json['startLatitude'] != null ? json['startLatitude'].toDouble() : 0.0,
      startLongitude: json['startLongitude'] != null ? json['startLongitude'].toDouble() : 0.0,
      destinations: json['destinations'] != null
          ? List<Destination>.from(json['destinations'].map((destination) => Destination.fromJson(destination)))
          : [],
      roundTrip: json['roundTrip'] ?? false,
    );
  }
}


class Destination {
  int destinationId;
  String name;
  double destinationLatitude;
  double destinationLongitude;
  String time;

  Destination({
    required this.destinationId,
    required this.name,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.time,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      destinationId: json['destinationId'] ?? 0,
      name: json['name'] ?? '',
      destinationLatitude: json['destinationLatitude'] != null ? json['destinationLatitude'].toDouble() : 0.0,
      destinationLongitude: json['destinationLongitude'] != null ? json['destinationLongitude'].toDouble() : 0.0,
      time: json['time'] ?? '',
    );
  }
}
