class GoogleTokenRequest {
  GoogleTokenRequest({required this.tokenId});

  final String tokenId;

  Map<String, dynamic> toJson() {
    return {'tokenId': tokenId};
  }
}
