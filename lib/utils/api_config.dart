import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  /// Base URL for the ambulance dispatch API
  static const String baseUrl = 'http://localhost:8080';

  /// WebSocket URL for real-time communication
  static const String webSocketUrl = 'ws://localhost:8080';

  /// Get OpenAI API key from environment variables
  static String? get openAIApiKey => dotenv.env['OPENAI_API_KEY'];

  /// Check if OpenAI API key is properly configured
  static bool get isOpenAIConfigured {
    final apiKey = openAIApiKey;
    return apiKey != null && apiKey.isNotEmpty && apiKey != 'your_openai_api_key_here';
  }

  /// Get Firebase API key (if needed in the future)
  static String? get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'];

  /// Get database URL (if needed in the future)
  static String? get databaseUrl => dotenv.env['DATABASE_URL'];

  /// API Endpoints
  static const String patientRegisterEndpoint = '/api/patient/register';
  static const String patientEmergencyEndpoint = '/api/patient/emergency';
  static String patientStatusEndpoint(String patientId) => '/api/patient/status/$patientId';
  static const String systemStatusEndpoint = '/api/system/status';

  /// Validate all required environment variables
  static List<String> getMissingKeys() {
    final missing = <String>[];

    if (!isOpenAIConfigured) {
      missing.add('OPENAI_API_KEY');
    }

    return missing;
  }
}
