import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  late final String baseUrl;
  late final String googleServerClientId;

  static final AppConfig instance = AppConfig._();

  AppConfig._() {
    baseUrl = dotenv.env['BASE_URL'] ?? '';
    googleServerClientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'] ?? '';
  }
}
