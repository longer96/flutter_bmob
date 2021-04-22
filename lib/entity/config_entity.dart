import 'package:flutter_bmob/bmob/table/bmob_object.dart';
import 'package:flutter_bmob/generated/json/base/json_convert_content.dart';

class Config extends BmobObject with JsonConvert<Config> {
  String? createdAt;
  String? key;
  String? objectId;
  String? updatedAt;
  String? value;

  @override
  Map<String, dynamic> getParams() {
    throw toJson();
  }
}
