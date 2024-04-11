import 'package:flutter/foundation.dart';

import '../network/requests/search_fda_drugs_request.dart';

class FdaService {
  static const String _url = 'https://api.fda.gov/drug/drugsfda.json';

  Future<String> searchDrugs(String searchTerm) async {
    final request = SearchFdaDrugsRequest(url: _url, searchTerm: searchTerm);
    final response = await request.execute();
    return response.toString();
  }
}
