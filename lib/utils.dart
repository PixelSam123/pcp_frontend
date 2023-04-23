import 'package:http/http.dart' as http;

class FetchUtils {
  static Future<String> get(
    String url, {
    Map<String, String>? headers,
    String failMessage = 'Failed to load',
  }) async {
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
        '$failMessage: ${response.statusCode} ${response.reasonPhrase}\n'
        '${response.body}',
      );
    }
  }

  static Future<String> post(
    String url, {
    Map<String, String>? headers,
    String failMessage = 'Failed to post',
    Object? body,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
        '$failMessage: ${response.statusCode} ${response.reasonPhrase}\n'
        '${response.body}',
      );
    }
  }
}
