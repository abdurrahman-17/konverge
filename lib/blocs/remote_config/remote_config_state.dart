part of 'remote_config_bloc.dart';

abstract class RemoteConfigState extends Equatable {
  const RemoteConfigState();

  @override
  List<Object> get props => [];
}

class RemoteConfigInitialState extends RemoteConfigState {}

class RemoteConfigLoginTypeState extends RemoteConfigState {
  final RemoteConfigModel? remoteConfigModel;
  final ProviderStatus status;

  const RemoteConfigLoginTypeState(
      {this.remoteConfigModel, this.status = ProviderStatus.idle});

  @override
  List<Object> get props => [status];
}
