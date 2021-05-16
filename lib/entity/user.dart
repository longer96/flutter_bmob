import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bmob/bmob/bmob.dart';
import 'package:flutter_bmob/bmob/bmob_dio.dart';
import 'package:flutter_bmob/bmob/response/bmob_handled.dart';
import 'package:flutter_bmob/bmob/response/bmob_registered.dart';
import 'package:flutter_bmob/shack_api_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// copy 了BmobUser
/// BmobUser 有bug 不能自己增加字段
class BUser extends BmobObject {
  String? avatar;
  List<String>? device;
  String? infor;
  String? nickname;
  String? pwd;
  String? registerWay;
  String? remark;
  int? state;
  String? username;
  String? password;
  String? email;
  bool? emailVerified;
  String? mobilePhoneNumber;
  bool? mobilePhoneNumberVerified;
  String? sessionToken;

  ///用户账号密码注册
  Future<BmobRegistered> register() async {
    Map<String, dynamic> map = bUserToJson();
    Map<String, dynamic> data = new Map();
    //去除由服务器生成的字段值
    map.remove("objectId");
    map.remove("createdAt");
    map.remove("updatedAt");
    map.remove("sessionToken");
    //去除空值
    map.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });
    //Map转String
    String params = json.encode(data);
    //发送请求
    Map<String, dynamic> responseData = await BmobDio.getInstance().post(Bmob.BMOB_API_USERS, data: params);
    BmobRegistered bmobRegistered = BmobRegistered.fromJson(responseData);
    BmobDio.getInstance().setSessionToken(bmobRegistered.sessionToken);
    return bmobRegistered;
  }

  ///账号密码登录
  Future<BUser> login() async {
    Map<String, dynamic> map = bUserToJson();
    debugPrint('longer  >>>${bUserToJson()}');
    Map<String, dynamic> data = new Map();
    //去除由服务器生成的字段值
    map.remove("objectId");
    map.remove("createdAt");
    map.remove("updatedAt");
    map.remove("sessionToken");
    //去除空值
    map.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });
    //Map转String
    //发送请求
    Map<String, dynamic> result = await BmobDio.getInstance().get(Bmob.BMOB_API_LOGIN + getUrlParams(data));
    BUser bmobUser = bUserFromJson(result);
    // obtain shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    prefs.setString("user", result.toString());
    prefs.setString("user", json.encode(bmobUser));
    debugPrint(result.toString());

    BmobDio.getInstance().setSessionToken(bmobUser.sessionToken);
    return bmobUser;
  }

  ///手机短信验证码登录
  Future<BUser> loginBySms(String smsCode) async {
    Map<String, dynamic> map = bUserToJson();
    Map<String, dynamic> data = new Map();
    data["smsCode"] = smsCode;
    //去除由服务器生成的字段值
    map.remove("objectId");
    map.remove("createdAt");
    map.remove("updatedAt");
    map.remove("sessionToken");
    //去除空值
    map.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });
    //Map转String
    //发送请求
    Map<String, dynamic> result =
        await BmobDio.getInstance().post(Bmob.BMOB_API_USERS, data: getParamsJsonFromParamsMap(data));
    debugPrint(result.toString());
    BUser bmobUser = bUserFromJson(result);
    BmobDio.getInstance().setSessionToken(bmobUser.sessionToken);
    return bmobUser;
  }

  ///发送邮箱重置密码的请求
  Future<BmobHandled> requestPasswordResetByEmail() async {
    Map<String, dynamic> map = bUserToJson();
    Map<String, dynamic> data = new Map();
    //去除由服务器生成的字段值
    map.remove("objectId");
    map.remove("createdAt");
    map.remove("updatedAt");
    map.remove("sessionToken");
    //去除空值
    map.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });
    //Map转String
    //发送请求
    Map<String, dynamic> result =
        await BmobDio.getInstance().post(Bmob.BMOB_API_REQUEST_PASSWORD_RESET, data: getParamsJsonFromParamsMap(data));
    debugPrint(result.toString());
    BmobHandled bmobHandled = BmobHandled.fromJson(result);
    return bmobHandled;
  }

  ///短信重置密码
  Future<BmobHandled> requestPasswordResetBySmsCode(String smsCode) async {
    Map<String, dynamic> map = bUserToJson();
    Map<String, dynamic> data = new Map();
    //去除由服务器生成的字段值
    map.remove("objectId");
    map.remove("createdAt");
    map.remove("updatedAt");
    map.remove("sessionToken");
    //去除空值
    map.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });
    //Map转String
    //发送请求
    Map<String, dynamic> result = await BmobDio.getInstance().put(
        Bmob.BMOB_API_REQUEST_PASSWORD_BY_SMS_CODE + Bmob.BMOB_API_SLASH + smsCode,
        data: getParamsJsonFromParamsMap(data));
    debugPrint(result.toString());
    BmobHandled bmobHandled = BmobHandled.fromJson(result);
    return bmobHandled;
  }

  ///发送验证邮箱
  static Future<BmobHandled> requestEmailVerify(String email) async {
    Map<String, dynamic> data = new Map();

    data["email"] = email;

    //Map转String
    //发送请求
    Map<String, dynamic> result =
        await BmobDio.getInstance().post(Bmob.BMOB_API_REQUEST_REQUEST_EMAIL_VERIFY, data: data);
    debugPrint(result.toString());
    BmobHandled bmobHandled = BmobHandled.fromJson(result);
    return bmobHandled;
  }

  ///旧密码重置密码
  Future<BmobHandled> updateUserPassword(String oldPassword, String newPassword) async {
    Map<String, dynamic> map = bUserToJson();
    Map<String, dynamic> data = new Map();

    data["oldPassword"] = oldPassword;
    data["newPassword"] = newPassword;
    //去除由服务器生成的字段值
    map.remove("objectId");
    map.remove("createdAt");
    map.remove("updatedAt");
    map.remove("sessionToken");
    //去除空值
    map.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });
    //Map转String
    //发送请求
    Map<String, dynamic> result = await BmobDio.getInstance()
        .put(Bmob.BMOB_API_REQUEST_UPDATE_USER_PASSWORD + objectId!, data: getParamsJsonFromParamsMap(data));
    debugPrint(result.toString());
    BmobHandled bmobHandled = BmobHandled.fromJson(result);
    return bmobHandled;
  }

  ///获取在url中的请求参数
  String getUrlParams(Map data) {
    String urlParams = "";
    int index = 0;
    data.forEach((key, value) {
      if (index == 0) {
        urlParams = '$urlParams?$key=$value';
      } else {
        urlParams = '$urlParams&$key=$value';
      }
      index++;
    });
    return urlParams;
  }

  /// fixme 增加参数
  BUser bUserFromJson(Map<String, dynamic> json) {
    if (json['avatar'] != null) {
      this.avatar = json['avatar'].toString();
    }
    if (json['device'] != null) {
      this.device = (json['device'] as List).map((v) => v.toString()).toList().cast<String>();
    }
    if (json['infor'] != null) {
      this.infor = json['infor'].toString();
    }
    if (json['nickname'] != null) {
      this.nickname = json['nickname'].toString();
    }
    if (json['pwd'] != null) {
      this.pwd = json['pwd'].toString();
    }
    if (json['registerWay'] != null) {
      this.registerWay = json['registerWay'].toString();
    }
    if (json['remark'] != null) {
      this.remark = json['remark'].toString();
    }
    if (json['state'] != null) {
      this.state = json['state'] is String ? int.tryParse(json['state']) : json['state'].toInt();
    }
    if (json['username'] != null) {
      this.username = json['username'].toString();
    }
    if (json['password'] != null) {
      this.password = json['password'].toString();
    }
    if (json['email'] != null) {
      this.email = json['email'].toString();
    }
    if (json['emailVerified'] != null) {
      this.emailVerified = json['emailVerified'];
    }
    if (json['mobilePhoneNumber'] != null) {
      this.mobilePhoneNumber = json['mobilePhoneNumber'].toString();
    }
    if (json['mobilePhoneNumberVerified'] != null) {
      this.mobilePhoneNumberVerified = json['mobilePhoneNumberVerified'];
    }
    if (json['sessionToken'] != null) {
      this.sessionToken = json['sessionToken'].toString();
    }

    //
    if (json['objectId'] != null) {
      this.objectId = json['objectId'].toString();
    }
    if (json['createdAt'] != null) {
      this.createdAt = json['createdAt'].toString();
    }
    if (json['updatedAt'] != null) {
      this.updatedAt = json['updatedAt'].toString();
    }
    if (json['ACL'] != null) {
      this.ACL = json['ACL'];
    }

    return this;
  }

  Map<String, dynamic> bUserToJson() {
    final entity = this;
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = entity.avatar;
    data['device'] = entity.device;
    data['infor'] = entity.infor;
    data['nickname'] = entity.nickname;
    data['pwd'] = entity.pwd;
    data['registerWay'] = entity.registerWay;
    data['remark'] = entity.remark;
    data['state'] = entity.state;
    data['username'] = entity.username;
    data['password'] = entity.password;
    data['email'] = entity.email;
    data['emailVerified'] = entity.emailVerified;
    data['mobilePhoneNumber'] = entity.mobilePhoneNumber;
    data['mobilePhoneNumberVerified'] = entity.mobilePhoneNumberVerified;
    data['sessionToken'] = entity.sessionToken;
    //
    data['objectId'] = entity.objectId;
    data['createdAt'] = entity.createdAt;
    data['updatedAt'] = entity.updatedAt;
    data['ACL'] = entity.ACL;
    return data;
  }

  @override
  Map<String, dynamic> getParams() {
    return removeMapNull(bUserToJson());
  }
}
