

class User {
  String userName;
  String token;
  int weight;
  String height;
  int BMI;
  String gender;
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
    required this.gender,
    required this.unit,
    required this.email,
    required this.creationDate,
    required this.updateDate,
  });

  getapiBody(){
    Map<String, dynamic> map = {
      "id": this.userName,
      "tolken": this.token,
      "weight": this.weight,
      "height": this.height,
      "BMI": this.BMI,
      "gender": this.gender,
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