import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Setup {
  Future<void> init() async {
    await dotenv.load(fileName: '.env');

    final url = dotenv.env['SUPABASE_URL']?.trim();
    final anonKey = dotenv.env['SUPABASE_ANON_KEY']?.trim();
    if (url == null || url.isEmpty) {
      throw StateError(
        'SUPABASE_URL is missing or empty. Copy .env.example to .env and set your Supabase values.',
      );
    }
    if (anonKey == null || anonKey.isEmpty) {
      throw StateError(
        'SUPABASE_ANON_KEY is missing or empty. Copy .env.example to .env and set your Supabase values.',
      );
    }

    await Supabase.initialize(url: url, anonKey: anonKey);
  }
}
