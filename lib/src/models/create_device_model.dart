
class CreateDeviceModel{
  String? deviceName;
  String? deviceId;
  String? token;

  CreateDeviceModel({
    this.deviceName,
    this.deviceId,
    this.token,
  });

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = deviceName;
    data["uniqueId"] = deviceId;
    return data;
  }

}