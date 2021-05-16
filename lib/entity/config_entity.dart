import 'package:flutter_bmob/shack_api_sdk.dart';

class Config extends BmobObject with JsonConvert<Config> {
  String? createdAt;
  String? key;
  String? objectId;
  String? updatedAt;
  String? value;

  @override
  Map<String, dynamic> getParams() {
    return removeMapNull(toJson());
  }
}
