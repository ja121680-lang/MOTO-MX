/// Backend config for the real-time GPS tracking (and, once connected,
/// everything else in supabase/schema.sql). Values come from --dart-define
/// at build time; without them the app keeps working in local/demo mode
/// (see [DriverLocationService]) rather than silently pretending to be
/// connected to a backend that doesn't exist yet.
class AppConfig {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get isConfigured => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
