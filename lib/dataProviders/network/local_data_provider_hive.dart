import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';
import '../error/exceptions.dart';

class Local_data_provider_hive {
  Box box;
  Local_data_provider_hive({required this.box});

  Future<void> storageData({
    required String key,
    required retrievedDataType,
    required dynamic returnType,
    required data,
  }) async {
    // log("setting box");
    // log("key $key");
    // log('box data is $data');
    var dataStorage;
    if (!Hive.isBoxOpen(key)) {
      Hive.init((await getApplicationDocumentsDirectory()).path);
    }

    try {
      dataStorage = await getStorageData(
              key: key,
              retrievedDataType: retrievedDataType,
              returnType: returnType) ??
          [];
      log("dataStorage{{{{{{{{{{{{{{{{{{{{{" +
          dataStorage.toString() +
          "}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}");
      print("dataStorage");
    } catch (e) {
      print(e.toString());
    }

    try {
      if (returnType == List) {
        if (listEquals(data, dataStorage)) {
          print("data is the same");
        } else {
          log("dataStorage{{{{{{{{{{{{{{{{{{{{{" +
              dataStorage.toString() +
              "}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}");
          print("dataStorage");
          box.put(key, json.encode(data));
        }
      } else {
        if (data == dataStorage) {
          print("data is the same");
        } else {
          log("dataStorage{{{{{{{{{{{{{{{{{{{{{" +
              dataStorage.toString() +
              "}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}");
          print("dataStorage");
          box.put(key, json.encode(data));
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  dynamic getStorageData({
    required String key,
    required retrievedDataType,
    dynamic returnType,
  }) async {
    try {
      if (box.get(key) != null) {
        if (returnType == List) {
          final List<dynamic> data = json.decode(
            box.get(key) ?? '',
          );

          print(data);
          return retrievedDataType.fromJsonList(data);
        } else if (returnType == String) {
          final dynamic data = json.decode(
            box.get(key) ?? '',
          );

          return data;
        } else {
          final dynamic data = json.decode(
            box.get(key) ?? '',
          );

          try {
            return retrievedDataType.fromJson(data);
          } catch (e) {
            return data;
          }
        }
      } else {
        throw CacheException();
      }
    } catch (_) {
      print(_.toString());
      throw CacheException();
    }
  }

  Future<void> clearStorage({
    required List keys,
  }) {
    return box.deleteAll(keys);
  }
}
