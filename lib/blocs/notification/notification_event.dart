part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class NotificationInitialEvent extends NotificationEvent {}

class GetNotificationListEvent extends NotificationEvent {
  final String userId;
  const GetNotificationListEvent({required this.userId});
}




