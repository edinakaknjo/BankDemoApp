import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'api_source.g.dart';

@RestApi(baseUrl: 'https://api.allorigins.win')
@lazySingleton
abstract class ApiDataSource {
  @factoryMethod
  factory ApiDataSource(Dio dio) = _ApiDataSource;
  @GET("/get?url=http://www.randomnumberapi.com/api/v1.0/random")
  Future<HttpResponse<String>> getRandomNumber(
      @Query('cacheBust') String cacheBust);
}
