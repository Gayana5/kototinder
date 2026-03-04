import '../../domain/repositories/analytics_repository.dart';
import '../datasources/appmetrica_data_source.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  AnalyticsRepositoryImpl(this._dataSource);

  final AppMetricaDataSource _dataSource;

  @override
  Future<void> initialize() => _dataSource.activate();

  @override
  Future<void> logEvent(String name, {Map<String, Object?> parameters = const {}}) {
    return _dataSource.logEvent(name, parameters: parameters);
  }
}
