import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'http_request.dart';

class SearchFdaDrugsRequest extends HttpRequest {
  final String url;
  final String searchTerm;

  SearchFdaDrugsRequest({required this.url, required this.searchTerm});

  @override
  Future<dynamic> execute() async {
    final url = Uri.parse(
        '${this.url}?search=openfda.generic_name:$searchTerm*&limit=20');
    final response =
        await http.get(url, headers: {'content-type': 'application/json'});

    if (response.statusCode != 200) {
      return '';
    }

    return convert.jsonDecode(response.body);
  }
}
