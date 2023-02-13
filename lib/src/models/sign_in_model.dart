
class SignInModel{
  String? username;
  String? password;

  SignInModel({
    this.username,
    this.password,
  });

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data["email"] = username;
    data["password"] = password;
    return data;
  }

}