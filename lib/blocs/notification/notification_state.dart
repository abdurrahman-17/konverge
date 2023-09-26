part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitialState extends NotificationState {}


class NotificationNotFound extends NotificationState {}

class NotificationDataSavedState extends NotificationState {}

class NotificationListState extends NotificationState {
  final ProviderStatus status;
  final List<NotificationModel> manualNotifications;
  final List<NotificationModel> algorithmicNotifications;
  final String error;
  const NotificationListState(
      {required this.status, required this.manualNotifications, required this.algorithmicNotifications,required this.error});

  @override
  List<Object> get props => [status];
}


