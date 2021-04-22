import 'package:flutter_bmob/bmob/bmob_query.dart';
import 'package:flutter_bmob/bmob/response/bmob_error.dart';
import 'package:flutter_bmob/entity/config_entity.dart';
import 'package:flutter_bmob/generated/json/base/json_convert_content.dart';

final configApi = ConfigApi();

class ConfigApi {
  /// 查询配置列表
  Future<List<Config>> getConfigList() async {
    BmobQuery query = BmobQuery();
    List r = await query.queryObjectsByTableName('Config');

    print('longer   >>> ${r}');

    var rr = JsonConvert.fromJsonAsT<List<Config>>(r);

    return rr;
  }

  /// 查询一条配置列表
  Future<Config> getConfig(String id) async {
    BmobQuery<Config> bmobQuery = BmobQuery();
    var r = await bmobQuery.queryObject(id);
    Config blog = Config().fromJson(r);

    return blog;

    //     .then((data) {
    //   Config blog = Config.fromJson(data);
    //   print('longer   查询一条数据成功 >>> ${blog.key}');
    //   return data;
    // }).catchError((e) {
    //   // showError(context, BmobError.convert(e).error);
    //   print('longer 出错  >>> ${BmobError.convert(e).error}');
    //   return BmobError.convert(e).error;
    // });
  }
}
