import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'transaction_source.g.dart';

@RestApi(baseUrl: 'https://api.allorigins.win')
@lazySingleton
abstract class ApiDataSource {
  @factoryMethod
  factory ApiDataSource() {
    final dio = Dio();
    return _ApiDataSource(dio);
  }
  @GET("/get?url=http://www.randomnumberapi.com/api/v1.0/random")
  Future<HttpResponse<String>> getRandomNumber(
      @Query('cacheBust') String cacheBust);
}
