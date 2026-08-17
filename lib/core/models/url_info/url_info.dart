import 'package:freezed_annotation/freezed_annotation.dart';

part 'url_info.freezed.dart';
part 'url_info.g.dart';

@immutable
@freezed
class UrlInfo with _$UrlInfo {
  const factory UrlInfo({
    required String url,
    required String name,
    @Default(false) bool isUsersUrl,
    @Default(false) bool isActive,
  }) = _UrlInfo;
  const UrlInfo._();

  factory UrlInfo.fromJson(Map<String, dynamic> json) =>
      _$UrlInfoFromJson(json);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UrlInfo && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;
}
