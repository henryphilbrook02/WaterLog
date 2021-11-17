

class User {
  String userName;
  String token;
  int weight;
  String height;
  int BMI;
  int currentUsage;
  String unit;
  String email;
  String creationDate;
  String updateDate;

  User({
    required this.userName,
    required this.token,
    required this.weight,
    required this.height,
    required this.BMI,
    required this.currentUsage,
    required this.unit,
    required this.email,
    required this.creationDate,
    required this.updateDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['USERNAME'],
      token: json['TOKEN'],
      weight: json['WEIGHT'],
      height: json['HEIGHT'],
      BMI: json['BMI'],
      currentUsage: json['CUR_USAGE'],
      unit: json['UNIT'],
      email: json['EMAIL'],
      creationDate: json['CREATION'],
      updateDate: json['LAST_UPDATE'],
    );
  }

  getapiBody(){
    Map<String, dynamic> map = {
      "id": this.userName,
      "tolken": this.token,
      "weight": this.weight,
      "height": this.height,
      "BMI": this.BMI,
      "curUsage": this.currentUsage,
      "unit": this.unit,
      "email": this.email,
      "creation": this.creationDate,
      "update": this.updateDate
    };

    return map;
  }

  getUserName() {
    return this.userName;
  }

  getEmail() {
    return this.email;
  }
}