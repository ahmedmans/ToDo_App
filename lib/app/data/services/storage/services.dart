import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app/app/core/utils/keys.dart';

class StorageServices extends GetxService {
  late GetStorage _box;

  // check data Storage if has data i can read if i hasn't return empty list

  Future<StorageServices> init() async {
    _box = GetStorage();
    await _box.writeIfNull(taskKey, []);
    //await _box.write(taskKey, []);
    return this;
  }

  // Read data
  // using T type becuse we dont know what is the data type storage in list
  T read<T>(String key) {
    return _box.read(key);
  }

  // write data
  void write(String key, dynamic value) async {
    await _box.write(key, value);
  }
}
