import 'package:supabase_flutter/supabase_flutter.dart';

import 'user_service.dart';

class BoardService {
  final SupabaseClient _client;
  final UserService userRepository;

  final bucketName = "board";
  final tableName = "boards";

  BoardService(this._client, this.userRepository);

// // 프로필 업데이트
// Future<void> uploadUserProfile(String filePath) async {
//   try {
//     final uploadFile = File(filePath);
//     final now = DateTime.now();
//     final timestamp = '${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}';
//     final filename = '${timestamp}_${_client.auth.currentUser?.email}.txt';
//     final fullName = "image/$filename.png";
//     final String path = await _client.storage.from(bucketName).upload(
//       fullName,
//       uploadFile,
//       fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
//     );
//     final String imagePath = _client.storage.from(bucketName).getPublicUrl(fullName);
//     userRepository.updateProfile(imagePath);
//   } on PostgrestException catch (e) {
//     throw BoardFailure(
//       errorCode: e.code,
//       errorMessage: e.message,
//     );
//   } on ChipmunkFailure catch (e) {
//     rethrow;
//   }
// }
//
// // 내가 쓴 게시글 조회.
// Future<void> getMyBoards() async {
//   try {
//     // final List<dynamic> temp = await _client.from(tableName).select('*,user(email,profile)').match(
//     //   {"content": "내용1"},
//     // );
//     final temp = await _client.from(tableName).insert(
//         {
//           "user": _client.auth.currentUser?.email,
//           'content': "내용4"
//         }
//     );
//     ChipmunkLogger.debug("temp: ${temp.toString()}");
//   } on PostgrestException catch (e) {
//     throw BoardFailure(
//       errorCode: e.code,
//       errorMessage: e.message,
//     );
//   } on ChipmunkFailure catch (e) {
//     rethrow;
//   }
// }
}
