import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenshield/core/models/urls_list_view_type.dart';

part 'new_url_view_args.freezed.dart';

@freezed
class NewUrlViewArgs with _$NewUrlViewArgs {
  const factory NewUrlViewArgs({
    required String? name,
    required String? url,
    required UrlsListViewType urlType,
  }) = _NewUrlViewArgs;
}
