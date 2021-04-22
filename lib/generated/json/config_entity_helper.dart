import 'package:flutter_bmob/entity/config_entity.dart';
import 'package:flutter_bmob/bmob/table/bmob_object.dart';

configFromJson(Config data, Map<String, dynamic> json) {
  if (json['createdAt'] != null) {
    data.createdAt = json['createdAt'].toString();
  }
  if (json['key'] != null) {
    data.key = json['key'].toString();
  }
  if (json['objectId'] != null) {
    data.objectId = json['objectId'].toString();
  }
  if (json['updatedAt'] != null) {
    data.updatedAt = json['updatedAt'].toString();
  }
  if (json['value'] != null) {
    data.value = json['value'].toString();
  }
  return data;
}

Map<String, dynamic> configToJson(Config entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['createdAt'] = entity.createdAt;
  data['key'] = entity.key;
  data['objectId'] = entity.objectId;
  data['updatedAt'] = entity.updatedAt;
  data['value'] = entity.value;
  return data;
}
