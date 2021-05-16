import 'package:flutter/foundation.dart';
import 'package:flutter_bmob/bmob/bmob_query.dart';
import 'package:flutter_bmob/bmob/response/bmob_error.dart';
import 'package:flutter_bmob/bmob/response/bmob_updated.dart';
import 'package:flutter_bmob/entity/config_entity.dart';
import 'package:flutter_bmob/generated/json/base/json_convert_content.dart';

final configApi = ConfigApi();

class ConfigApi {
  /// 查询配置列表
  Future<List<Config>> getConfigList() async {
    BmobQuery query = BmobQuery();
    List r = await query.queryObjectsByTableName('Config');

    debugPrint('longer   >>> $r');

    var rr = JsonConvert.fromJsonAsT<List<Config>>(r);

    return rr;
  }

  /// 查询一条配置列表
  Future<Config> getConfig(String id) async {
    BmobQuery<Config> bmobQuery = BmobQuery();
    var r = await bmobQuery.queryObject(id);
    Config blog = Config().fromJson(r);

    return blog;
  }

  /// 修改一条配置列表
  Future changeConfig() async {
    // BmobQuery<Config> bmobQuery = BmobQuery();
    // var r = await bmobQuery.queryObject();
    // Config blog = Config().fromJson(r);
    //
    // return blog;
    print('进来了');

    Config config = Config();
    config.objectId = '9f39b75874';
    // config.key = 'change';
    // config.value = 'by longer';
    // config.createdAt = DateTime.now().toString();
    // config.updatedAt = DateTime.now().toString();

    try {
      await config.update();
      debugPrint('成功');
      // return ApiResult.success(null);
    } catch (e) {
      final r = BmobError.convert(e);
      debugPrint('longer   ${r.code}出错>>> ${r.error}');
      // return ApiResult.failure(r.error);
    }
  }
}
