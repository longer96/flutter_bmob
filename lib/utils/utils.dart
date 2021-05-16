import 'dart:core';

Map<String, dynamic> removeMapNull(Map<String, dynamic> map) {
  Map<String, dynamic> data = Map();
  //去除空值
  map.forEach((key, value) {
    if (value != null) {
      data[key] = value;
    }
  });
  return data;
}
