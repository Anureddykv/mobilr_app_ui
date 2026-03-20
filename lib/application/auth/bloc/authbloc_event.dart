part of 'authbloc_bloc.dart';

@freezed
class AuthblocEvent with _$AuthblocEvent {
  const factory AuthblocEvent.login({
    required AuthRequestModel authrequestmodel,
  }) = Login;
}