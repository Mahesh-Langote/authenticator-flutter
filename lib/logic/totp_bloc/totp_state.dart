import 'package:equatable/equatable.dart';
import '../../data/models/totp_item.dart';

enum TotpStatus { initial, loading, loaded, error }

class TotpState extends Equatable {
  final TotpStatus status;
  final List<TotpItem> items;
  final double progress;
  final int remainingSeconds;
  final String? errorMessage;

  const TotpState({
    this.status = TotpStatus.initial,
    this.items = const [],
    this.progress = 1.0,
    this.remainingSeconds = 30,
    this.errorMessage,
  });

  TotpState copyWith({
    TotpStatus? status,
    List<TotpItem>? items,
    double? progress,
    int? remainingSeconds,
    String? errorMessage,
  }) {
    return TotpState(
      status: status ?? this.status,
      items: items ?? this.items,
      progress: progress ?? this.progress,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, progress, remainingSeconds, errorMessage];
}
