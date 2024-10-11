// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_source.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _ApiDataSource implements ApiDataSource {
  _ApiDataSource(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://api.allorigins.win';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<String>> getRandomNumber(cacheBust) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'cacheBust': cacheBust};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result =
        await _dio.fetch<String>(_setStreamType<HttpResponse<String>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/get?url=http://www.randomnumberapi.com/api/v1.0/random',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
