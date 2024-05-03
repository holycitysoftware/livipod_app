import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'http_request.dart';

class SearchFdaDrugsRequest extends HttpRequest {
  final String url;
  final String genericName;
  final String? dosageForm;
  final String? strength;
  final bool isSearchTerm;

  SearchFdaDrugsRequest(
      {required this.url,
      required this.genericName,
      this.dosageForm,
      this.strength,
      required this.isSearchTerm});

  @override
  Future<dynamic> execute() async {
    var urlStr =
        '${this.url}?search=openfda.route:"ORAL"+AND+openfda.generic_name:';

    if (isSearchTerm) {
      urlStr += '$genericName*';
    } else {
      urlStr += '"$genericName"';
    }
    if (dosageForm != null) {
      urlStr += '+AND+products.dosage_form:"$dosageForm"';
    }
    if (strength != null) {
      urlStr +=
          '+AND+products.active_ingredients.name:"$genericName"+AND+products.active_ingredients.strength:"$strength"';
    }

    urlStr += '&limit=50';

    print(urlStr);

    final url = Uri.parse(urlStr);
    final response =
        await http.get(url, headers: {'content-type': 'application/json'});

    if (response.statusCode != 200) {
      return null;
    }

    return convert.jsonDecode(response.body);
  }
}
