// import 'package:chopper/chopper.dart';
// import 'package:fortune/data/remote/api/request/request_nickname_check.dart';
// import 'package:fortune/data/remote/core/auth_helper_jwt.dart';
//
// part 'normal_user_service.chopper.dart';
//
// @ChopperApi(baseUrl: "/v1/user/")
// abstract class NormalUserService extends ChopperService {
//   static NormalUserService create([ChopperClient? client]) => _$NormalUserService(client);
//
//   @Get(path: 'country')
//   Future<Response> countryCode();
//
//   @Get(path: 'terms')
//   Future<Response> terms({
//     @Query('phoneNumber') required String phoneNumber,
//   });
//
//   @Post(path: 'nickname/check')
//   Future<Response> checkNickName(@Body() RequestNicknameCheck request);
//
//   @Post(path: 'token/refresh')
//   Future<Response> refreshToken(@Header(authHeaderKey) String token);
//
//   @Post(path: 'signup', headers: {contentType: 'multipart/form-data, application/json;'})
//   @multipart
//   Future<Response> signUp({
//     @Part('phoneNumber') required String phoneNumber,
//     @Part('countryCode') required String countryCode,
//     @Part('nickname') required String nickname,
//     @PartFile('profileImage') required String? profileImage,
//     @Part('pushToken') String? pushToken,
//   });
// }
