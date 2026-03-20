part of 'authbloc_bloc.dart';

@freezed
class AuthblocState with _$AuthblocState {
  factory AuthblocState({
    required bool isLoading,
    required bool isError,
    required String successMessage,
    required bool isSuccess,
  }) = _AuthblocState;
  factory AuthblocState.initial() {
    return AuthblocState(
      isLoading: false,
      isError: false,
      successMessage: '',
      isSuccess: false,
    );
  }
}
