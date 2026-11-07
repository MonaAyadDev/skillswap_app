import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillswap/core/models/request_model.dart';
import 'package:skillswap/features/requests/data/requests_repository.dart';
import 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  final RequestsRepository _repository;
  StreamSubscription? _subscription;

  RequestsCubit(this._repository) : super(const RequestsState()) {
    loadRequests();
  }

  void loadRequests() {
    emit(state.copyWith(status: RequestsStatus.loading));
    _subscription?.cancel();
    _subscription = _repository.getRequests().listen(
      (requests) {
        emit(state.copyWith(
          status: RequestsStatus.success,
          requests: requests,
        ));
      },
      onError: (err) {
        emit(state.copyWith(
          status: RequestsStatus.error,
          errorMessage: err.toString(),
        ));
      },
    );
  }

  void setTab(String tab) {
    emit(state.copyWith(activeTab: tab));
  }

  Future<void> acceptRequest(String requestId) async {
    await _repository.updateRequestStatus(requestId, RequestStatus.accepted);
  }

  Future<void> declineRequest(String requestId) async {
    await _repository.updateRequestStatus(requestId, RequestStatus.rejected);
  }

  Future<void> completeRequest(String requestId) async {
    await _repository.updateRequestStatus(requestId, RequestStatus.completed);
  }

  Future<void> sendRequest({
    required String toUserId,
    required String toUserName,
    required String skillToLearn,
    required String skillToTeach,
    required String message,
  }) async {
    await _repository.sendRequest(
      toUserId: toUserId,
      toUserName: toUserName,
      skillToLearn: skillToLearn,
      skillToTeach: skillToTeach,
      message: message,
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
