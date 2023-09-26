import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../core/locator.dart';
import '../../models/notification/notification_model.dart';
import '../../repository/graphql_repo.dart';
import '../../services/amplify/amplify_service.dart';
import '../../utilities/enums.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  // NotificationModel? currentNotification;

  AmplifyService amplifyService = AmplifyService();

  NotificationBloc() : super(NotificationInitialState()) {
    on<NotificationInitialEvent>((event, emit) {
      emit(NotificationInitialState());
    });

    /*fetch Notification event*/
    on<GetNotificationListEvent>((event, emit) async {
      List<NotificationModel> manualNotifications = [];
      List<NotificationModel> algorithmicNotifications = [];
      emit(
        NotificationListState(
          status: ProviderStatus.loading,
          error: "",
          manualNotifications: manualNotifications,
          algorithmicNotifications: algorithmicNotifications,
        ),
      );
      emit(NotificationInitialState());
      var manualResult =
          await Locator.instance.get<GraphqlRepo>().fetchNotificationList(
                userId: event.userId,
                matchType: 'manual_match',
              );

      manualResult.fold(
        (error) {
          log("error ${error.message}");
          emit(NotificationListState(
              status: ProviderStatus.error,
              error: error.message,
              manualNotifications: manualNotifications,
              algorithmicNotifications: algorithmicNotifications));
        },
        (success) {
          manualNotifications = success;
        },
      );
      var algorithm =
          await Locator.instance.get<GraphqlRepo>().fetchNotificationList(
                userId: event.userId,
                matchType: 'algorithmic_match',
              );

      algorithm.fold(
        (error) {
          log("error ${error.message}");
          emit(NotificationListState(
              status: ProviderStatus.error,
              error: error.message,
              manualNotifications: manualNotifications,
              algorithmicNotifications: algorithmicNotifications));
        },
        (success) {
          algorithmicNotifications = success;
          emit(NotificationListState(
              status: ProviderStatus.loaded,
              error: "",
              manualNotifications: manualNotifications,
              algorithmicNotifications: algorithmicNotifications));
        },
      );
    });
  }
}
