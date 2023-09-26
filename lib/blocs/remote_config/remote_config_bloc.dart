import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../core/locator.dart';
import '../../models/remote_config_model.dart';
import '../../services/remote_config_service.dart';
import '../../utilities/enums.dart';

part 'remote_config_event.dart';
part 'remote_config_state.dart';

class RemoteConfigBloc extends Bloc<RemoteConfigEvent, RemoteConfigState> {
  RemoteConfigBloc() : super(RemoteConfigInitialState()) {
    on<RemoteConfigInitialEvent>((event, emit) {
      emit(RemoteConfigInitialState());
    });
    /* fetching remote config login types*/
    on<RemoteConfigLoginTypesEvent>((event, emit) async {
      emit(const RemoteConfigLoginTypeState(
        status: ProviderStatus.loading,
      ));
      RemoteConfigModel? remoteConfigModel =
          await Locator.instance.get<RemoteConfigService>().getLoginTypes();
      if (remoteConfigModel != null) {
        emit(
          RemoteConfigLoginTypeState(
            remoteConfigModel: remoteConfigModel,
            status: ProviderStatus.loaded,
          ),
        );
      } else {
        emit(const RemoteConfigLoginTypeState(
          status: ProviderStatus.error,
        ));
      }
    });
  }
}
