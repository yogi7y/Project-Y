import 'package:meta/meta.dart';

typedef Headers = Map<String, String>;
typedef QueryParameters = Map<String, String>;
typedef Payload = Map<String, Object?>;

@immutable
abstract class Request {
  Request({
    required this.baseUrl,
    required this.endpoint,
    this.headers = const {},
    this.queryParameters = const {},
    this.timeout = const Duration(seconds: 30),
  })  : assert(baseUrl.isNotEmpty, 'baseUrl must not be empty'),
        assert(Uri.parse(baseUrl).isAbsolute, 'baseUrl must be a valid absolute URL'),
        assert(endpoint.isNotEmpty, 'endpoint must not be empty'),
        assert(!endpoint.contains('?'), 'endpoint should not contain query parameters'),
        assert(timeout > Duration.zero, 'timeout must be positive');

  /// Eg. https://api.example.com
  final String baseUrl;

  /// Eg. /users
  final String endpoint;

  /// Headers to be sent with the request
  final Headers headers;

  /// Query parameters to be sent with the request
  /// Eg. {'page': '1', 'limit': '10'}
  /// will be converted to `?page=1&limit=10`
  final QueryParameters queryParameters;

  /// Timeout duration for the request
  final Duration timeout;

  /// Computed full URL including base URL, endpoint, and query parameters.
  /// Combines the path from baseUrl with the endpoint.
  String get url {
    final uri = Uri.parse(baseUrl);
    final basePath = uri.path.endsWith('/') ? uri.path.substring(0, uri.path.length - 1) : uri.path;
    final endpointPath = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    final combinedPath = '$basePath$endpointPath';

    return uri
        .replace(
          path: combinedPath,
          queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
        )
        .toString();
  }
}

abstract class GetRequest implements Request {}

abstract class PostRequest implements Request {
  Payload get body;
}

abstract class PatchRequest implements Request {
  Payload get body;
}
