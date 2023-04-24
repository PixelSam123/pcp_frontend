class AccessTokenResponse {
  const AccessTokenResponse({
    required this.accessToken,
    required this.tokenType,
  });

  final String accessToken;
  final String tokenType;

  factory AccessTokenResponse.fromJson(Map<String, dynamic> json) {
    return AccessTokenResponse(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }
}
