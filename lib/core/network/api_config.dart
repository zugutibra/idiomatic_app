/// Base URL for the Idiomatic FastAPI backend.
///
/// Defaults to the live Render deployment. Override at build/run time with
/// `--dart-define=API_BASE_URL=...` when pointing at a local backend instead
/// (e.g. `http://localhost:8000` on iOS simulator/desktop/web, or
/// `http://10.0.2.2:8000` on the Android emulator, which doesn't resolve
/// `localhost` to the host machine).
class ApiConfig {
  const ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://idiomatic-backend-rnu3.onrender.com',
  );
}
