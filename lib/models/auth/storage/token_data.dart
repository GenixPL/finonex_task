class TokenData {
  final String token;
  final int expiresIn;
  final DateTime createdAt;

  TokenData({
    required this.token,
    required this.expiresIn,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isExpired => DateTime.now().isAfter(createdAt.add(Duration(seconds: expiresIn)));

  factory TokenData.fromJson(Map<String, dynamic> json) {
    return TokenData(
      token: json['token'] as String,
      expiresIn: json['expiresIn'] as int,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expiresIn': expiresIn,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
