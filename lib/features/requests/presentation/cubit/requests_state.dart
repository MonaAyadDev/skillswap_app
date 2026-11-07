import 'package:equatable/equatable.dart';
import 'package:skillswap/core/models/request_model.dart';

enum RequestsStatus { initial, loading, success, error }

class RequestsState extends Equatable {
  final RequestsStatus status;
  final List<RequestModel> requests;
  final String? errorMessage;
  final String activeTab; // 'pending', 'sent', 'accepted', 'completed'

  const RequestsState({
    this.status = RequestsStatus.initial,
    this.requests = const [],
    this.errorMessage,
    this.activeTab = 'pending',
  });

  List<RequestModel> get pendingRequests =>
      requests.where((r) => r.status == RequestStatus.pending && r.fromUserId != 'current_user').toList();

  List<RequestModel> get sentRequests =>
      requests.where((r) => r.status == RequestStatus.pending && r.fromUserId == 'current_user').toList();

  List<RequestModel> get acceptedRequests =>
      requests.where((r) => r.status == RequestStatus.accepted).toList();

  List<RequestModel> get completedRequests =>
      requests.where((r) => r.status == RequestStatus.completed).toList();

  RequestsState copyWith({
    RequestsStatus? status,
    List<RequestModel>? requests,
    String? errorMessage,
    String? activeTab,
  }) {
    return RequestsState(
      status: status ?? this.status,
      requests: requests ?? this.requests,
      errorMessage: errorMessage ?? this.errorMessage,
      activeTab: activeTab ?? this.activeTab,
    );
  }

  @override
  List<Object?> get props => [status, requests, errorMessage, activeTab];
}
