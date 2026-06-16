import 'package:flutter_clean_bloc_skeleton/data/datasource/country/country_cache_datasource_memory.dart';
import 'package:flutter_clean_bloc_skeleton/data/models/country/country_model.dart';
import 'package:flutter_clean_bloc_skeleton/data/models/country/country_name_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CountryCacheDatasourceMemory cache;

  CountryModel model(String name) =>
      CountryModel(name: CountryNameModel(common: name));

  setUp(() => cache = CountryCacheDatasourceMemory());

  test('read returns null before anything is written', () {
    expect(cache.read(), isNull);
  });

  test('read returns the written list', () {
    final models = [model('Vietnam'), model('Japan')];
    cache.write(models);
    expect(cache.read(), same(models));
  });

  test('write overwrites the previous list', () {
    cache.write([model('Vietnam')]);
    cache.write([model('Japan')]);
    expect(cache.read()!.map((c) => c.name?.common), equals(['Japan']));
  });

  test('clear resets the cache to null', () {
    cache.write([model('Vietnam')]);
    cache.clear();
    expect(cache.read(), isNull);
  });
}
