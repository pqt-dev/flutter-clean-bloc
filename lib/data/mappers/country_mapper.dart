import 'package:flutter_clean_bloc_skeleton/data/models/country/country_flag_model.dart';
import 'package:flutter_clean_bloc_skeleton/data/models/country/country_model.dart';
import 'package:flutter_clean_bloc_skeleton/data/models/country/country_name_model.dart';
import 'package:flutter_clean_bloc_skeleton/domain/entities/country.dart';

extension CountryModelMapper on CountryModel {
  Country toEntity() {
    return Country(
      cca3: cca3,
      capital: capital,
      region: region,
      subregion: subregion,
      area: area,
      population: population,
      name: name?.toEntity(),
      flags: flags?.toEntity(),
    );
  }
}

extension CountryNameModelMapper on CountryNameModel {
  CountryName toEntity() {
    return CountryName(
      common: common,
      official: official,
    );
  }
}

extension CountryFlagModelMapper on CountryFlagModel {
  CountryFlag toEntity() {
    return CountryFlag(
      png: png,
      svg: svg,
      alt: alt,
    );
  }
}

extension CountryEntityMapper on Country {
  CountryModel toModel() {
    return CountryModel(
      cca3: cca3,
      capital: capital,
      region: region,
      subregion: subregion,
      area: area,
      population: population,
      name: name?.toModel(),
      flags: flags?.toModel(),
    );
  }
}

extension CountryNameEntityMapper on CountryName {
  CountryNameModel toModel() {
    return CountryNameModel(
      common: common,
      official: official,
    );
  }
}

extension CountryFlagEntityMapper on CountryFlag {
  CountryFlagModel toModel() {
    return CountryFlagModel(
      png: png,
      svg: svg,
      alt: alt,
    );
  }
}
