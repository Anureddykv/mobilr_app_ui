// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authbloc_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthblocEvent {
  AuthRequestModel get authrequestmodel => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AuthRequestModel authrequestmodel) login,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthRequestModel authrequestmodel)? login,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthRequestModel authrequestmodel)? login,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthblocEventCopyWith<AuthblocEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthblocEventCopyWith<$Res> {
  factory $AuthblocEventCopyWith(
          AuthblocEvent value, $Res Function(AuthblocEvent) then) =
      _$AuthblocEventCopyWithImpl<$Res, AuthblocEvent>;
  @useResult
  $Res call({AuthRequestModel authrequestmodel});
}

/// @nodoc
class _$AuthblocEventCopyWithImpl<$Res, $Val extends AuthblocEvent>
    implements $AuthblocEventCopyWith<$Res> {
  _$AuthblocEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authrequestmodel = null,
  }) {
    return _then(_value.copyWith(
      authrequestmodel: null == authrequestmodel
          ? _value.authrequestmodel
          : authrequestmodel // ignore: cast_nullable_to_non_nullable
              as AuthRequestModel,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginImplCopyWith<$Res>
    implements $AuthblocEventCopyWith<$Res> {
  factory _$$LoginImplCopyWith(
          _$LoginImpl value, $Res Function(_$LoginImpl) then) =
      __$$LoginImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AuthRequestModel authrequestmodel});
}

/// @nodoc
class __$$LoginImplCopyWithImpl<$Res>
    extends _$AuthblocEventCopyWithImpl<$Res, _$LoginImpl>
    implements _$$LoginImplCopyWith<$Res> {
  __$$LoginImplCopyWithImpl(
      _$LoginImpl _value, $Res Function(_$LoginImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authrequestmodel = null,
  }) {
    return _then(_$LoginImpl(
      authrequestmodel: null == authrequestmodel
          ? _value.authrequestmodel
          : authrequestmodel // ignore: cast_nullable_to_non_nullable
              as AuthRequestModel,
    ));
  }
}

/// @nodoc

class _$LoginImpl implements Login {
  const _$LoginImpl({required this.authrequestmodel});

  @override
  final AuthRequestModel authrequestmodel;

  @override
  String toString() {
    return 'AuthblocEvent.login(authrequestmodel: $authrequestmodel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginImpl &&
            (identical(other.authrequestmodel, authrequestmodel) ||
                other.authrequestmodel == authrequestmodel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, authrequestmodel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginImplCopyWith<_$LoginImpl> get copyWith =>
      __$$LoginImplCopyWithImpl<_$LoginImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AuthRequestModel authrequestmodel) login,
  }) {
    return login(authrequestmodel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthRequestModel authrequestmodel)? login,
  }) {
    return login?.call(authrequestmodel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthRequestModel authrequestmodel)? login,
    required TResult orElse(),
  }) {
    if (login != null) {
      return login(authrequestmodel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
  }) {
    return login(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
  }) {
    return login?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    required TResult orElse(),
  }) {
    if (login != null) {
      return login(this);
    }
    return orElse();
  }
}

abstract class Login implements AuthblocEvent {
  const factory Login({required final AuthRequestModel authrequestmodel}) =
      _$LoginImpl;

  @override
  AuthRequestModel get authrequestmodel;
  @override
  @JsonKey(ignore: true)
  _$$LoginImplCopyWith<_$LoginImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AuthblocState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isError => throw _privateConstructorUsedError;
  String get successMessage => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthblocStateCopyWith<AuthblocState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthblocStateCopyWith<$Res> {
  factory $AuthblocStateCopyWith(
          AuthblocState value, $Res Function(AuthblocState) then) =
      _$AuthblocStateCopyWithImpl<$Res, AuthblocState>;
  @useResult
  $Res call(
      {bool isLoading, bool isError, String successMessage, bool isSuccess});
}

/// @nodoc
class _$AuthblocStateCopyWithImpl<$Res, $Val extends AuthblocState>
    implements $AuthblocStateCopyWith<$Res> {
  _$AuthblocStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isError = null,
    Object? successMessage = null,
    Object? isSuccess = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
      successMessage: null == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String,
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthblocStateImplCopyWith<$Res>
    implements $AuthblocStateCopyWith<$Res> {
  factory _$$AuthblocStateImplCopyWith(
          _$AuthblocStateImpl value, $Res Function(_$AuthblocStateImpl) then) =
      __$$AuthblocStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading, bool isError, String successMessage, bool isSuccess});
}

/// @nodoc
class __$$AuthblocStateImplCopyWithImpl<$Res>
    extends _$AuthblocStateCopyWithImpl<$Res, _$AuthblocStateImpl>
    implements _$$AuthblocStateImplCopyWith<$Res> {
  __$$AuthblocStateImplCopyWithImpl(
      _$AuthblocStateImpl _value, $Res Function(_$AuthblocStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isError = null,
    Object? successMessage = null,
    Object? isSuccess = null,
  }) {
    return _then(_$AuthblocStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
      successMessage: null == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String,
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AuthblocStateImpl implements _AuthblocState {
  _$AuthblocStateImpl(
      {required this.isLoading,
      required this.isError,
      required this.successMessage,
      required this.isSuccess});

  @override
  final bool isLoading;
  @override
  final bool isError;
  @override
  final String successMessage;
  @override
  final bool isSuccess;

  @override
  String toString() {
    return 'AuthblocState(isLoading: $isLoading, isError: $isError, successMessage: $successMessage, isSuccess: $isSuccess)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthblocStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isError, isError) || other.isError == isError) &&
            (identical(other.successMessage, successMessage) ||
                other.successMessage == successMessage) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, isError, successMessage, isSuccess);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthblocStateImplCopyWith<_$AuthblocStateImpl> get copyWith =>
      __$$AuthblocStateImplCopyWithImpl<_$AuthblocStateImpl>(this, _$identity);
}

abstract class _AuthblocState implements AuthblocState {
  factory _AuthblocState(
      {required final bool isLoading,
      required final bool isError,
      required final String successMessage,
      required final bool isSuccess}) = _$AuthblocStateImpl;

  @override
  bool get isLoading;
  @override
  bool get isError;
  @override
  String get successMessage;
  @override
  bool get isSuccess;
  @override
  @JsonKey(ignore: true)
  _$$AuthblocStateImplCopyWith<_$AuthblocStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
