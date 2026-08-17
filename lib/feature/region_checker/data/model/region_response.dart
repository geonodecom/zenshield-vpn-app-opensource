import 'package:freezed_annotation/freezed_annotation.dart';

part 'region_response.freezed.dart';
part 'region_response.g.dart';

@freezed
class RegionResponse with _$RegionResponse {
  const factory RegionResponse({
    required String countryCode,
    required String flagImage,
  }) = _RegionResponse;

  factory RegionResponse.fromJson(Map<String, dynamic> json) =>
      _$RegionResponseFromJson(json);
}
