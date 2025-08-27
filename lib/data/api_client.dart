import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'https://rickandmortyapi.com/api')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/character')
  Future<HttpResponse<dynamic>> getCardsRaw(
    @Query("page") int page,
    @Query("count") int count
  );

  @GET('/character/{id}')
  Future<HttpResponse<dynamic>> getCardDetailsRaw(@Path("id") int id);
}