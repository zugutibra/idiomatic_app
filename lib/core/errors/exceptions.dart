/// Thrown by data sources; caught by repository implementations and
/// converted into a [Failure] before crossing into the domain layer.
class ServerException implements Exception {
  const ServerException([this.message = 'Server error']);
  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Cache error']);
  final String message;
}
