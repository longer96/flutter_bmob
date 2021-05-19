import 'dart:convert';

/// 业务层调用接口返回数据用这个包装，统一处理成功和失败
class ApiResult<T> {
  final T? data;
  final String? msg;
  final bool success;

  get failure => !success;

  ApiResult(
    this.success, {
    this.data,
    this.msg,
  });

  ApiResult.success(this.data, {this.msg}) : success = true;

  ApiResult.failure(this.msg)
      : success = false,
        data = null;

  ApiResult.failureWithRequestError()
      : success = false,
        data = null,
        msg = requestError;

  static String requestError = '请求出错';

  @override
  String toString() {
    return 'success: $success ，msg: $msg, data: ${jsonEncode(data)}';
  }
}
