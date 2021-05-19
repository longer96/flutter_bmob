import 'package:flutter/foundation.dart';
import 'package:flutter_bmob/bmob/bmob_sms.dart';
import 'package:flutter_bmob/bmob/response/bmob_error.dart';
import 'package:flutter_bmob/bmob/response/bmob_sent.dart';
import 'package:flutter_bmob/bmob/response/bmob_updated.dart';
import 'package:flutter_bmob/entity/api_result.dart';
import 'package:flutter_bmob/entity/user.dart';

final userApi = UserApi();

class UserApi {
  /// username + 密码登录
  Future<ApiResult<User>> loginByPwd(String userName, String pwd) async {
    User cUser = User();
    cUser.username = userName;
    cUser.password = pwd;

    User user;
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
    // 短信模板
    bmobSms.template = "shackLogin";
    bmobSms.mobilePhoneNumber = _phoneNumber;
    try {
      final BmobSent bmobSent = await bmobSms.sendSms();
      debugPrint("发送成功:" + bmobSent.smsId.toString());
      return ApiResult.success(null);
    } catch (e, s) {
      final r = BmobError.convert(e);
      debugPrint('longer   ${r.code}出错>>> ${r.error}');

      if (r.code == 10010) {
        return ApiResult.failure('发送太频繁啦');
      } else if (r.code == 10011) {
        return ApiResult.failure('短信被发完了，请提醒管理员');
      }

      return ApiResult.failure(r.error);
    }
  }

  /// 手机号+验证码 登录
  /// 验证： 如果没有注册过，那么会直接注册登录  （结果：会注册登录）
  Future<ApiResult<User>> loginBySms(User bUser, String _smsCode) async {
    try {
      User r = await bUser.loginBySms(_smsCode);
      debugPrint('登录成功 id：${r.objectId} 用户名：${r.username}');
      return ApiResult.success(r);
    } catch (e) {
      final r = BmobError.convert(e);
      debugPrint('longer   ${r.code}出错>>> ${r.error}');
      if (r.code == 207) {
        return ApiResult.failure('请输入正确验证码');
      }

      return ApiResult.failure(r.error);
    }
  }

  /// 更新用户数据
  Future<ApiResult> upDate(User bUser) async {
    try {
      // User r = await bUser.loginBySms(_smsCode);

      BmobUpdated r = await bUser.update();
      debugPrint('更新成功 id：$r');
      return ApiResult.success(null);
    } catch (e) {
      final r = BmobError.convert(e);
      debugPrint('longer   ${r.code}出错>>> ${r.error}');
      return ApiResult.failure(r.error);
    }
  }
}
