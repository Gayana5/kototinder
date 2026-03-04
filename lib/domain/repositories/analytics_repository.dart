abstract class AnalyticsRepository {
  Future<void> initialize();
  Future<void> logEvent(String name, {Map<String, Object?> parameters = const {}});
}
