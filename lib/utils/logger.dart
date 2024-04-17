import 'dart:developer' as developer;

void logger(String value, {bool isError = false}) {
  final message = isError ? '[ERROR]' : '';
  developer.log('$message $value', name: 'INDYGO');
}
