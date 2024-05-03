import '../network/requests/search_fda_drugs_request.dart';

class FdaService {
  static const String _url = 'https://api.fda.gov/drug/drugsfda.json';

  Future<List<String>> searchDrugs(String genericName, bool isSearchTerm,
      String? dosageForm, String? strength) async {
    final request = SearchFdaDrugsRequest(
        url: _url,
        genericName: genericName,
        isSearchTerm: isSearchTerm,
        dosageForm: dosageForm,
        strength: strength);
    final response = await request.execute();
    if (response != null && isSearchTerm) {
      final limitCount = response['meta']['results']['limit'] as int;
      final totalCount = response['meta']['results']['total'] as int;
      final count = totalCount < limitCount ? totalCount : limitCount;
      return _genericNames(genericName, count, response['results']);
    }
    return [];
  }

  List<String> _genericNames(String genericName, int count, dynamic data) {
    final List<String> genericNameList = [];
    for (var i = 0; i < count; i++) {
      final result = data[i];
      final openFda = result['openfda'];
      openFda['generic_name'].forEach((element) {
        final r = element as String;
        if (r.toLowerCase().startsWith(genericName) &&
            !genericNameList.any((e) => e == r)) {
          genericNameList.add(r);
        }
      });
    }
    genericNameList.sort();
    return genericNameList;
  }
}
