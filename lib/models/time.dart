class Time {
  int? id;
  int? time;

  Time({this.id, this.time});

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      id: json['id'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time'] = this.time;
    return data;
  }
}