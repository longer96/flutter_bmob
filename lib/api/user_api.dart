import 'package:flutter/foundation.dart';
import 'package:flutter_bmob/bmob/bmob_sms.dart';
import 'package:flutter_bmob/bmob/response/bmob_error.dart';
import 'package:flutter_bmob/bmob/response/bmob_sent.dart';
import 'package:flutter_bmob/entity/api_result.dart';
import 'package:flutter_bmob/entity/user.dart';

final userApi = UserApi();

class UserApi {
  /// username + 密码登录
  Future<ApiResult<BUser>> loginByPwd(String userName, String pwd) async {
    BUser cUser = BUser();
    cUser.username = userName;
    cUser.password = pwd;

    BUser user;
    try {
      user = await cUser.login();
      debugPrint('登录成功 id：${user.objectId} 用户名：${user.nickname}');
      return ApiResult.success(user);
    } catch (e) {
      final error = BmobError.convert(e);
      debugPrint('longer   出错 >>> $error');

      if (error.code == 101) {
        return ApiResult.failure('账号或密码错误');
      }

      return ApiResult.failure(error.error);
    }
  }

  /// 发送验证码
  Future<ApiResult> sendSmsCode(String _phoneNumber) async {
    BmobSms bmobSms = BmobSms();
    // todo
    // bmobSms.template = "a";
    bmobSms.mobilePhoneNumber = _phoneNumber;
    try {
      final BmobSent bmobSent = await bmobSms.sendSms();
      debugPrint("发送成功:" + bmobSent.smsId.toString());
      return ApiResult.success(null);
    } catch (e, s) {
      // print('longer   >>> $s');
      final r = BmobError.convert(e);
      debugPrint('longer   ${r.code}出错>>> ${r.error}');
      return ApiResult.failure(r.error);
    }
  }

  /// 手机号+验证码 登录
  /// 验证： 如果没有注册过，那么会直接注册登录  （结果：会注册登录）
  Future<ApiResult> loginBySms(String _phoneNumber, String _smsCode) async {
    BUser bmobUserRegister = BUser();
    bmobUserRegister.mobilePhoneNumber = _phoneNumber;

    try {
      BUser user = await bmobUserRegister.loginBySms(_smsCode);
      debugPrint('登录成功 id：${user.objectId} 用户名：${user.username}');
      return ApiResult.success(null);
    } catch (e) {
      final r = BmobError.convert(e);
      debugPrint('longer   ${r.code}出错>>> ${r.error}');
      if (r.code == 207) {
        return ApiResult.failure('请输入正确验证码');
      }

      return ApiResult.failure(r.error);
    }
  }
}
