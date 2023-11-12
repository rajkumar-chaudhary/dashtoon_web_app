import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

Future<Uint8List?> query(Map<String, dynamic> data) async {
  Dio dio = Dio();
  dio.options.headers = {
    'Accept': 'image/png',
    'Authorization':
        'Bearer VknySbLLTUjbxXAXCjyfaFIPwUTCeRXbFSOjwRiCxsxFyhbnGjSFalPKrpvvDAaPVzWEevPljilLVDBiTzfIbWFdxOkYJxnOPoHhkkVGzAknaOulWggusSFewzpqsNWM',
    'Content-Type': 'application/json',
  };

  try {
    var response = await dio.post(
      'https://xdwvg9no7pefghrn.us-east-1.aws.endpoints.huggingface.cloud',
      data: jsonEncode(data),
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );

    if (response.statusCode == 200) {
      // print(response.data);
      return Uint8List.fromList(response.data);
    } else {
      print('Error - Status code: ${response.statusCode}');
      throw Error();
    }
  } catch (e) {
    print('Error - $e');
    throw e;
  }
}
