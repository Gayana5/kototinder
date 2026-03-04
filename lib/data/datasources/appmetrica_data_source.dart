import 'package:appmetrica_plugin/appmetrica_plugin.dart';

class AppMetricaDataSource {
  AppMetricaDataSource(this._apiKey);

  final String _apiKey;
  bool _isActive = false;

  Future<void> activate() async {
    if (_apiKey.isEmpty) {
      return;
    }
    try {
      await AppMetrica.activate(AppMetricaConfig(_apiKey));
      _isActive = true;
    } catch (_) {
      _isActive = false;
    }
  }

  Future<void> logEvent(String name, {Map<String, Object?> parameters = const {}}) async {
    if (!_isActive) {
      return;
    }
    try {
      final filtered = <String, Object>{};
      parameters.forEach((key, value) {
        if (value != null) {
          filtered[key] = value;
        }
      });
      await AppMetrica.reportEventWithMap(name, filtered);
    } catch (_) {
      // ignore analytics errors
    }
  }
}
