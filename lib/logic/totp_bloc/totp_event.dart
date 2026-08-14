import 'package:equatable/equatable.dart';
import '../../data/models/totp_item.dart';

abstract class TotpEvent extends Equatable {
  const TotpEvent();

  @override
  List<Object> get props => [];
}

class LoadTotpItems extends TotpEvent {}

class AddTotpItem extends TotpEvent {
  final TotpItem item;

  const AddTotpItem(this.item);

  @override
  List<Object> get props => [item];
}

class DeleteTotpItem extends TotpEvent {
  final String id;

  const DeleteTotpItem(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateTotpItem extends TotpEvent {
  final TotpItem item;

  const UpdateTotpItem(this.item);

  @override
  List<Object> get props => [item];
}

class UpdateTotpTimer extends TotpEvent {
  final double progress;
  final int remainingSeconds;

  const UpdateTotpTimer(this.progress, this.remainingSeconds);

  @override
  List<Object> get props => [progress, remainingSeconds];
}
