
class SignUpModel{
  String? name;
  String? email;
  String? phone;
  String? password;

  SignUpModel({
    this.name,
    this.email,
    this.phone,
    this.password
  });

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["email"] = email;
    data["phone"] = phone;
    data["password"] = password;
    return data;
  }

}