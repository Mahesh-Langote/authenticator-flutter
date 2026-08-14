import 'package:equatable/equatable.dart';

class TotpItem extends Equatable {
  final String id;
  final String issuer;
  final String accountName;
  final String secret;

  const TotpItem({
    required this.id,
    required this.issuer,
    required this.accountName,
    required this.secret,
  });

  TotpItem copyWith({
    String? id,
    String? issuer,
    String? accountName,
    String? secret,
  }) {
    return TotpItem(
      id: id ?? this.id,
      issuer: issuer ?? this.issuer,
      accountName: accountName ?? this.accountName,
      secret: secret ?? this.secret,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'issuer': issuer,
      'accountName': accountName,
      'secret': secret,
    };
  }

  factory TotpItem.fromJson(Map<String, dynamic> json) {
    return TotpItem(
      id: json['id'],
      issuer: json['issuer'],
      accountName: json['accountName'],
      secret: json['secret'],
    );
  }

  @override
  List<Object?> get props => [id, issuer, accountName, secret];
}
