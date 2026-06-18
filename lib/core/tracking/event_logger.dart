import 'dart:convert';
import 'dart:developer' as developer;

class EventLogger {
  static const String _tag = '🌟 StarNest Tracker';

  static void logCurl(
    String method,
    String url,
    Map<String, dynamic>? headers,
    dynamic body,
  ) {
    final curl = StringBuffer();

    curl.write('curl --location --request $method "$url"');

    headers?.forEach((key, value) {
      curl.write(" \\\n--header '$key: $value'");
    });

    if (body != null) {
      curl.write(" \\\n--data '${jsonEncode(body).replaceAll("'", "\\'")}'");
    }

    _log('''
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 API REQUEST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$curl

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
''');
  }

  static void logResponse(
    String endpoint,
    int? statusCode,
    dynamic responseBody,
  ) {
    String formattedResponse;

    try {
      formattedResponse = const JsonEncoder.withIndent(
        '  ',
      ).convert(responseBody);
    } catch (_) {
      formattedResponse = responseBody.toString();
    }

    _log('''
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ API RESPONSE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Endpoint : $endpoint
Status   : $statusCode

Response :
$formattedResponse

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
''');
  }

  static void logError(String endpoint, dynamic error, dynamic responseBody) {
    String formattedResponse;

    try {
      formattedResponse = const JsonEncoder.withIndent(
        '  ',
      ).convert(responseBody);
    } catch (_) {
      formattedResponse = responseBody.toString();
    }

    _log('''
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
❌ API ERROR
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Endpoint : $endpoint

Error :
$error

Response :
$formattedResponse

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
''');
  }

  static void logEvent(String eventType, Map<String, dynamic> payload) {
    _log('''
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 TRACK EVENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Event Type : $eventType

Payload :
${const JsonEncoder.withIndent('  ').convert(payload)}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
''');
  }

  static void _log(String message) {
    developer.log(message, name: 'starnest.tracker');
  }
}
