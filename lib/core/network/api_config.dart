/// Base URL for the Idiomatic FastAPI backend.
///
/// - Android emulator loopback is `10.0.2.2`, not `localhost`.
/// - iOS simulator and desktop/web can use `localhost` directly.
/// - Override at build/run time with `--dart-define=API_BASE_URL=...` when
///   pointing at a deployed backend (e.g. Render).
class ApiConfig {
  const ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );
}
