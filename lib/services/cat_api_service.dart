// Conditional export: use native implementation on IO platforms and web implementation on web
export 'cat_api_service_web.dart' if (dart.library.io) 'cat_api_service_io.dart';
