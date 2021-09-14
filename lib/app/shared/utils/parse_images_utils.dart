import 'dart:io';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:strapen_app/app/shared/utils/parse_errors_utils.dart';

abstract class ParseImageUtils {
  static Future<List<ParseFileBase>> save(List<dynamic> images) async {
    final List<ParseFileBase> parseImages = <ParseFileBase>[];
    int count = 1;

    try {
      for (var foto in images) {
        if (foto is File) {
          ParseFile parseFile = ParseFile(foto, name: "image$count");

          ParseResponse response = await parseFile.save();
          if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));

          parseImages.add(parseFile);
        } else {
          final parseFile = ParseFile(null)
            ..name = "image$count"
            ..url = foto.toString();

          parseImages.add(parseFile);
        }

        count++;
      }

      return parseImages;
    } catch (e) {
      throw Exception(e);
    }
  }
}