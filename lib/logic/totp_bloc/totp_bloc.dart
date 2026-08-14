import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/totp_repository.dart';
import '../../core/utils/otp_util.dart';
import 'totp_event.dart';
import 'totp_state.dart';

class TotpBloc extends Bloc<TotpEvent, TotpState> {
  final TotpRepository _repository;
  Timer? _timer;

  TotpBloc(this._repository) : super(const TotpState()) {
    on<LoadTotpItems>(_onLoadTotpItems);
    on<AddTotpItem>(_onAddTotpItem);
    on<UpdateTotpItem>(_onUpdateTotpItem);
    on<DeleteTotpItem>(_onDeleteTotpItem);
    on<UpdateTotpTimer>(_onUpdateTotpTimer);

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final progress = OtpUtil.getProgressIndicatorValue();
      final remaining = OtpUtil.getRemainingSeconds();
      add(UpdateTotpTimer(progress, remaining));
    });
  }

  Future<void> _onLoadTotpItems(LoadTotpItems event, Emitter<TotpState> emit) async {
    emit(state.copyWith(status: TotpStatus.loading));
    try {
      final items = await _repository.getItems();
      emit(state.copyWith(status: TotpStatus.loaded, items: items));
    } catch (e) {
      emit(state.copyWith(status: TotpStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddTotpItem(AddTotpItem event, Emitter<TotpState> emit) async {
    try {
      await _repository.addItem(event.item);
      final items = await _repository.getItems();
      emit(state.copyWith(status: TotpStatus.loaded, items: items));
    } catch (e) {
      emit(state.copyWith(status: TotpStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateTotpItem(UpdateTotpItem event, Emitter<TotpState> emit) async {
    try {
      await _repository.updateItem(event.item);
      final items = await _repository.getItems();
      emit(state.copyWith(status: TotpStatus.loaded, items: items));
    } catch (e) {
      emit(state.copyWith(status: TotpStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteTotpItem(DeleteTotpItem event, Emitter<TotpState> emit) async {
    try {
      await _repository.deleteItem(event.id);
      final items = await _repository.getItems();
      emit(state.copyWith(status: TotpStatus.loaded, items: items));
    } catch (e) {
      emit(state.copyWith(status: TotpStatus.error, errorMessage: e.toString()));
    }
  }

  void _onUpdateTotpTimer(UpdateTotpTimer event, Emitter<TotpState> emit) {
    if (state.status == TotpStatus.loaded) {
      emit(state.copyWith(progress: event.progress, remainingSeconds: event.remainingSeconds));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
