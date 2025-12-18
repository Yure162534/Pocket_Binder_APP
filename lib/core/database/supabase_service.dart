import 'package:flutter/foundation.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://jzpwxdiuotspcmlkhgwa.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6cHd4ZGl1b3RzcGNtbGtoZ3dhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ5MjA1MTAsImV4cCI6MjA4MDQ5NjUxMH0.W73iZsm9xcZvgn6b8ikMpergVtzfRmSBKxmW2QjgOHk',
    );

    if (kDebugMode) {
      _diagnose();
    }
  }

  static Future<void> _diagnose() async {
    try {
      final res = await Supabase.instance.client
          .from('AEDatabase')
          .select();
      debugPrint('Supabase response: $res');
    } catch (e) {
      debugPrint('Supabase error: $e');
    }
  }
}