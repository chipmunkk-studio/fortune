import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/request/request_post.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/data/supabase/response/post/post_response.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/data/supabase/supabase_ext.dart';
import 'package:fortune/domain/supabase/entity/post/post_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostService {
  static const _postTableName = TableName.post;
  final SupabaseClient _client = Supabase.instance.client;

  PostService();

  // 게시물 모두 불러오기.
  Future<List<PostEntity>> findAllPost({
    List<PostColumn> columnsToSelect = const [],
  }) async {
    // 비어 있으면 기본적으로 모두 select 함.
    columnsToSelect = columnsToSelect.isEmpty
        ? [
            PostColumn.id,
            PostColumn.users,
            PostColumn.content,
            PostColumn.createdAt,
          ]
        : columnsToSelect;

    final selectColumns = columnsToSelect.map((column) {
      if (column == PostColumn.users) {
        return '${TableName.users}('
            '${UserColumn.email},'
            '${UserColumn.nickname},'
            '${UserColumn.profileImage},'
            '${UserColumn.level}'
            ')';
      }
      return column.name;
    }).toList();

    try {
      final List<dynamic> response = await _client
          .from(_postTableName)
          .select(selectColumns.join(","))
          .order(
            PostColumn.createdAt.name,
            ascending: false,
          )
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final posts = response.map((e) => PostResponse.fromJson(e)).toList();
        return posts;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 게시글 쓰기.
  Future<void> insert({
    required int users,
    required String content,
  }) async {
    try {
      await _client.from(_postTableName).insert(
            RequestPost.insert(
              users: users,
              content: content,
            ).toJson(),
          );
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
