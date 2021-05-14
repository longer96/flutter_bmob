import 'package:flutter/foundation.dart';
import 'package:flutter_bmob/bmob/bmob_sms.dart';
import 'package:flutter_bmob/bmob/response/bmob_error.dart';
import 'package:flutter_bmob/bmob/response/bmob_handled.dart';
import 'package:flutter_bmob/bmob/response/bmob_sent.dart';
import 'package:flutter_bmob/bmob/table/bmob_user.dart';
import 'package:flutter_bmob/entity/api_result.dart';

final userApi = UserApi();

class UserApi {
  /// username + 密码登录
  Future loginByPwd(String userName, String pwd) async {
    BmobUser bmobUserRegister = BmobUser();
    bmobUserRegister.username = userName;
    bmobUserRegister.password = pwd;

    BmobUser bmobUser;
    try {
      bmobUser = await bmobUserRegister.login();
      debugPrint('登录成功 id：${bmobUser.objectId} 用户名：${bmobUser.username}');
    } catch (e) {
      String error = BmobError.convert(e).error;

      debugPrint('longer   出错>>> $error  ${BmobError.convert(e).code}');
    }
  }

  /// 发送验证码
  Future<ApiResult> sendSmsCode(String _phoneNumber) async {
    BmobSms bmobSms = BmobSms();
    bmobSms.template = "";
    bmobSms.mobilePhoneNumber = _phoneNumber;
    try {
      final BmobSent bmobSent = await bmobSms.sendSms();
      debugPrint("发送成功:" + bmobSent.smsId.toString());
      return ApiResult.success(null);
    } catch (e, s) {
      print('longer   >>> $s');
      final r = BmobError.convert(e);
      debugPrint('longer   ${r.code}出错>>> ${r.error}');
      return ApiResult.failure(r.error);
    }
  }

  /// 手机号+验证码 登录
  /// todo 验证
  /// 如果没有注册过，那么会直接注册登录
  Future<ApiResult> loginBySms(String _phoneNumber, String _smsCode) async {
    BmobUser bmobUserRegister = BmobUser();
    bmobUserRegister.mobilePhoneNumber = _phoneNumber;

    try {
      BmobUser bmobUser = await bmobUserRegister.loginBySms(_smsCode);
      debugPrint('登录成功 id：${bmobUser.objectId} 用户名：${bmobUser.username}');
      return ApiResult.success(null);
    } catch (e) {
      final r = BmobError.convert(e);
      debugPrint('longer   ${r.code}出错>>> ${r.error}');
      return ApiResult.failure(r.error);
    }
  }
}
