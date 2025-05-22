// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ApiFailure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) other,
    required TResult Function(String message) serverError,
    required TResult Function() poorConnection,
    required TResult Function() serverTimeout,
    required TResult Function() userNotFound,
    required TResult Function() invalidEmailAndPasswordCombination,
    required TResult Function() accountLocked,
    required TResult Function() accountExpired,
    required TResult Function() tokenExpired,
    required TResult Function() authenticationFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? other,
    TResult? Function(String message)? serverError,
    TResult? Function()? poorConnection,
    TResult? Function()? serverTimeout,
    TResult? Function()? userNotFound,
    TResult? Function()? invalidEmailAndPasswordCombination,
    TResult? Function()? accountLocked,
    TResult? Function()? accountExpired,
    TResult? Function()? tokenExpired,
    TResult? Function()? authenticationFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? other,
    TResult Function(String message)? serverError,
    TResult Function()? poorConnection,
    TResult Function()? serverTimeout,
    TResult Function()? userNotFound,
    TResult Function()? invalidEmailAndPasswordCombination,
    TResult Function()? accountLocked,
    TResult Function()? accountExpired,
    TResult Function()? tokenExpired,
    TResult Function()? authenticationFailed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Other value) other,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_PoorConnection value) poorConnection,
    required TResult Function(_ServerTimeout value) serverTimeout,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_InvalidEmailAndPasswordCombination value)
        invalidEmailAndPasswordCombination,
    required TResult Function(_AccountLocked value) accountLocked,
    required TResult Function(_AccountExpired value) accountExpired,
    required TResult Function(_TokenExpired value) tokenExpired,
    required TResult Function(_AuthenticationFailed value) authenticationFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Other value)? other,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_PoorConnection value)? poorConnection,
    TResult? Function(_ServerTimeout value)? serverTimeout,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult? Function(_AccountLocked value)? accountLocked,
    TResult? Function(_AccountExpired value)? accountExpired,
    TResult? Function(_TokenExpired value)? tokenExpired,
    TResult? Function(_AuthenticationFailed value)? authenticationFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Other value)? other,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_PoorConnection value)? poorConnection,
    TResult Function(_ServerTimeout value)? serverTimeout,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult Function(_AccountLocked value)? accountLocked,
    TResult Function(_AccountExpired value)? accountExpired,
    TResult Function(_TokenExpired value)? tokenExpired,
    TResult Function(_AuthenticationFailed value)? authenticationFailed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiFailureCopyWith<$Res> {
  factory $ApiFailureCopyWith(
          ApiFailure value, $Res Function(ApiFailure) then) =
      _$ApiFailureCopyWithImpl<$Res, ApiFailure>;
}

/// @nodoc
class _$ApiFailureCopyWithImpl<$Res, $Val extends ApiFailure>
    implements $ApiFailureCopyWith<$Res> {
  _$ApiFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_OtherCopyWith<$Res> {
  factory _$$_OtherCopyWith(_$_Other value, $Res Function(_$_Other) then) =
      __$$_OtherCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$_OtherCopyWithImpl<$Res>
    extends _$ApiFailureCopyWithImpl<$Res, _$_Other>
    implements _$$_OtherCopyWith<$Res> {
  __$$_OtherCopyWithImpl(_$_Other _value, $Res Function(_$_Other) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$_Other(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_Other implements _Other {
  const _$_Other(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ApiFailure.other(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Other &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_OtherCopyWith<_$_Other> get copyWith =>
      __$$_OtherCopyWithImpl<_$_Other>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) other,
    required TResult Function(String message) serverError,
    required TResult Function() poorConnection,
    required TResult Function() serverTimeout,
    required TResult Function() userNotFound,
    required TResult Function() invalidEmailAndPasswordCombination,
    required TResult Function() accountLocked,
    required TResult Function() accountExpired,
    required TResult Function() tokenExpired,
    required TResult Function() authenticationFailed,
  }) {
    return other(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? other,
    TResult? Function(String message)? serverError,
    TResult? Function()? poorConnection,
    TResult? Function()? serverTimeout,
    TResult? Function()? userNotFound,
    TResult? Function()? invalidEmailAndPasswordCombination,
    TResult? Function()? accountLocked,
    TResult? Function()? accountExpired,
    TResult? Function()? tokenExpired,
    TResult? Function()? authenticationFailed,
  }) {
    return other?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? other,
    TResult Function(String message)? serverError,
    TResult Function()? poorConnection,
    TResult Function()? serverTimeout,
    TResult Function()? userNotFound,
    TResult Function()? invalidEmailAndPasswordCombination,
    TResult Function()? accountLocked,
    TResult Function()? accountExpired,
    TResult Function()? tokenExpired,
    TResult Function()? authenticationFailed,
    required TResult orElse(),
  }) {
    if (other != null) {
      return other(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Other value) other,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_PoorConnection value) poorConnection,
    required TResult Function(_ServerTimeout value) serverTimeout,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_InvalidEmailAndPasswordCombination value)
        invalidEmailAndPasswordCombination,
    required TResult Function(_AccountLocked value) accountLocked,
    required TResult Function(_AccountExpired value) accountExpired,
    required TResult Function(_TokenExpired value) tokenExpired,
    required TResult Function(_AuthenticationFailed value) authenticationFailed,
  }) {
    return other(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Other value)? other,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_PoorConnection value)? poorConnection,
    TResult? Function(_ServerTimeout value)? serverTimeout,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult? Function(_AccountLocked value)? accountLocked,
    TResult? Function(_AccountExpired value)? accountExpired,
    TResult? Function(_TokenExpired value)? tokenExpired,
    TResult? Function(_AuthenticationFailed value)? authenticationFailed,
  }) {
    return other?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Other value)? other,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_PoorConnection value)? poorConnection,
    TResult Function(_ServerTimeout value)? serverTimeout,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult Function(_AccountLocked value)? accountLocked,
    TResult Function(_AccountExpired value)? accountExpired,
    TResult Function(_TokenExpired value)? tokenExpired,
    TResult Function(_AuthenticationFailed value)? authenticationFailed,
    required TResult orElse(),
  }) {
    if (other != null) {
      return other(this);
    }
    return orElse();
  }
}

abstract class _Other implements ApiFailure {
  const factory _Other(final String message) = _$_Other;

  String get message;
  @JsonKey(ignore: true)
  _$$_OtherCopyWith<_$_Other> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_ServerErrorCopyWith<$Res> {
  factory _$$_ServerErrorCopyWith(
          _$_ServerError value, $Res Function(_$_ServerError) then) =
      __$$_ServerErrorCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$_ServerErrorCopyWithImpl<$Res>
    extends _$ApiFailureCopyWithImpl<$Res, _$_ServerError>
    implements _$$_ServerErrorCopyWith<$Res> {
  __$$_ServerErrorCopyWithImpl(
      _$_ServerError _value, $Res Function(_$_ServerError) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$_ServerError(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ServerError implements _ServerError {
  const _$_ServerError(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ApiFailure.serverError(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ServerError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ServerErrorCopyWith<_$_ServerError> get copyWith =>
      __$$_ServerErrorCopyWithImpl<_$_ServerError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) other,
    required TResult Function(String message) serverError,
    required TResult Function() poorConnection,
    required TResult Function() serverTimeout,
    required TResult Function() userNotFound,
    required TResult Function() invalidEmailAndPasswordCombination,
    required TResult Function() accountLocked,
    required TResult Function() accountExpired,
    required TResult Function() tokenExpired,
    required TResult Function() authenticationFailed,
  }) {
    return serverError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? other,
    TResult? Function(String message)? serverError,
    TResult? Function()? poorConnection,
    TResult? Function()? serverTimeout,
    TResult? Function()? userNotFound,
    TResult? Function()? invalidEmailAndPasswordCombination,
    TResult? Function()? accountLocked,
    TResult? Function()? accountExpired,
    TResult? Function()? tokenExpired,
    TResult? Function()? authenticationFailed,
  }) {
    return serverError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? other,
    TResult Function(String message)? serverError,
    TResult Function()? poorConnection,
    TResult Function()? serverTimeout,
    TResult Function()? userNotFound,
    TResult Function()? invalidEmailAndPasswordCombination,
    TResult Function()? accountLocked,
    TResult Function()? accountExpired,
    TResult Function()? tokenExpired,
    TResult Function()? authenticationFailed,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Other value) other,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_PoorConnection value) poorConnection,
    required TResult Function(_ServerTimeout value) serverTimeout,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_InvalidEmailAndPasswordCombination value)
        invalidEmailAndPasswordCombination,
    required TResult Function(_AccountLocked value) accountLocked,
    required TResult Function(_AccountExpired value) accountExpired,
    required TResult Function(_TokenExpired value) tokenExpired,
    required TResult Function(_AuthenticationFailed value) authenticationFailed,
  }) {
    return serverError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Other value)? other,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_PoorConnection value)? poorConnection,
    TResult? Function(_ServerTimeout value)? serverTimeout,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult? Function(_AccountLocked value)? accountLocked,
    TResult? Function(_AccountExpired value)? accountExpired,
    TResult? Function(_TokenExpired value)? tokenExpired,
    TResult? Function(_AuthenticationFailed value)? authenticationFailed,
  }) {
    return serverError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Other value)? other,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_PoorConnection value)? poorConnection,
    TResult Function(_ServerTimeout value)? serverTimeout,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult Function(_AccountLocked value)? accountLocked,
    TResult Function(_AccountExpired value)? accountExpired,
    TResult Function(_TokenExpired value)? tokenExpired,
    TResult Function(_AuthenticationFailed value)? authenticationFailed,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(this);
    }
    return orElse();
  }
}

abstract class _ServerError implements ApiFailure {
  const factory _ServerError(final String message) = _$_ServerError;

  String get message;
  @JsonKey(ignore: true)
  _$$_ServerErrorCopyWith<_$_ServerError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_PoorConnectionCopyWith<$Res> {
  factory _$$_PoorConnectionCopyWith(
          _$_PoorConnection value, $Res Function(_$_PoorConnection) then) =
      __$$_PoorConnectionCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_PoorConnectionCopyWithImpl<$Res>
    extends _$ApiFailureCopyWithImpl<$Res, _$_PoorConnection>
    implements _$$_PoorConnectionCopyWith<$Res> {
  __$$_PoorConnectionCopyWithImpl(
      _$_PoorConnection _value, $Res Function(_$_PoorConnection) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_PoorConnection implements _PoorConnection {
  const _$_PoorConnection();

  @override
  String toString() {
    return 'ApiFailure.poorConnection()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_PoorConnection);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) other,
    required TResult Function(String message) serverError,
    required TResult Function() poorConnection,
    required TResult Function() serverTimeout,
    required TResult Function() userNotFound,
    required TResult Function() invalidEmailAndPasswordCombination,
    required TResult Function() accountLocked,
    required TResult Function() accountExpired,
    required TResult Function() tokenExpired,
    required TResult Function() authenticationFailed,
  }) {
    return poorConnection();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? other,
    TResult? Function(String message)? serverError,
    TResult? Function()? poorConnection,
    TResult? Function()? serverTimeout,
    TResult? Function()? userNotFound,
    TResult? Function()? invalidEmailAndPasswordCombination,
    TResult? Function()? accountLocked,
    TResult? Function()? accountExpired,
    TResult? Function()? tokenExpired,
    TResult? Function()? authenticationFailed,
  }) {
    return poorConnection?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? other,
    TResult Function(String message)? serverError,
    TResult Function()? poorConnection,
    TResult Function()? serverTimeout,
    TResult Function()? userNotFound,
    TResult Function()? invalidEmailAndPasswordCombination,
    TResult Function()? accountLocked,
    TResult Function()? accountExpired,
    TResult Function()? tokenExpired,
    TResult Function()? authenticationFailed,
    required TResult orElse(),
  }) {
    if (poorConnection != null) {
      return poorConnection();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Other value) other,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_PoorConnection value) poorConnection,
    required TResult Function(_ServerTimeout value) serverTimeout,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_InvalidEmailAndPasswordCombination value)
        invalidEmailAndPasswordCombination,
    required TResult Function(_AccountLocked value) accountLocked,
    required TResult Function(_AccountExpired value) accountExpired,
    required TResult Function(_TokenExpired value) tokenExpired,
    required TResult Function(_AuthenticationFailed value) authenticationFailed,
  }) {
    return poorConnection(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Other value)? other,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_PoorConnection value)? poorConnection,
    TResult? Function(_ServerTimeout value)? serverTimeout,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult? Function(_AccountLocked value)? accountLocked,
    TResult? Function(_AccountExpired value)? accountExpired,
    TResult? Function(_TokenExpired value)? tokenExpired,
    TResult? Function(_AuthenticationFailed value)? authenticationFailed,
  }) {
    return poorConnection?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Other value)? other,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_PoorConnection value)? poorConnection,
    TResult Function(_ServerTimeout value)? serverTimeout,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult Function(_AccountLocked value)? accountLocked,
    TResult Function(_AccountExpired value)? accountExpired,
    TResult Function(_TokenExpired value)? tokenExpired,
    TResult Function(_AuthenticationFailed value)? authenticationFailed,
    required TResult orElse(),
  }) {
    if (poorConnection != null) {
      return poorConnection(this);
    }
    return orElse();
  }
}

abstract class _PoorConnection implements ApiFailure {
  const factory _PoorConnection() = _$_PoorConnection;
}

/// @nodoc
abstract class _$$_ServerTimeoutCopyWith<$Res> {
  factory _$$_ServerTimeoutCopyWith(
          _$_ServerTimeout value, $Res Function(_$_ServerTimeout) then) =
      __$$_ServerTimeoutCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ServerTimeoutCopyWithImpl<$Res>
    extends _$ApiFailureCopyWithImpl<$Res, _$_ServerTimeout>
    implements _$$_ServerTimeoutCopyWith<$Res> {
  __$$_ServerTimeoutCopyWithImpl(
      _$_ServerTimeout _value, $Res Function(_$_ServerTimeout) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ServerTimeout implements _ServerTimeout {
  const _$_ServerTimeout();

  @override
  String toString() {
    return 'ApiFailure.serverTimeout()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_ServerTimeout);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) other,
    required TResult Function(String message) serverError,
    required TResult Function() poorConnection,
    required TResult Function() serverTimeout,
    required TResult Function() userNotFound,
    required TResult Function() invalidEmailAndPasswordCombination,
    required TResult Function() accountLocked,
    required TResult Function() accountExpired,
    required TResult Function() tokenExpired,
    required TResult Function() authenticationFailed,
  }) {
    return serverTimeout();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? other,
    TResult? Function(String message)? serverError,
    TResult? Function()? poorConnection,
    TResult? Function()? serverTimeout,
    TResult? Function()? userNotFound,
    TResult? Function()? invalidEmailAndPasswordCombination,
    TResult? Function()? accountLocked,
    TResult? Function()? accountExpired,
    TResult? Function()? tokenExpired,
    TResult? Function()? authenticationFailed,
  }) {
    return serverTimeout?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? other,
    TResult Function(String message)? serverError,
    TResult Function()? poorConnection,
    TResult Function()? serverTimeout,
    TResult Function()? userNotFound,
    TResult Function()? invalidEmailAndPasswordCombination,
    TResult Function()? accountLocked,
    TResult Function()? accountExpired,
    TResult Function()? tokenExpired,
    TResult Function()? authenticationFailed,
    required TResult orElse(),
  }) {
    if (serverTimeout != null) {
      return serverTimeout();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Other value) other,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_PoorConnection value) poorConnection,
    required TResult Function(_ServerTimeout value) serverTimeout,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_InvalidEmailAndPasswordCombination value)
        invalidEmailAndPasswordCombination,
    required TResult Function(_AccountLocked value) accountLocked,
    required TResult Function(_AccountExpired value) accountExpired,
    required TResult Function(_TokenExpired value) tokenExpired,
    required TResult Function(_AuthenticationFailed value) authenticationFailed,
  }) {
    return serverTimeout(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Other value)? other,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_PoorConnection value)? poorConnection,
    TResult? Function(_ServerTimeout value)? serverTimeout,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult? Function(_AccountLocked value)? accountLocked,
    TResult? Function(_AccountExpired value)? accountExpired,
    TResult? Function(_TokenExpired value)? tokenExpired,
    TResult? Function(_AuthenticationFailed value)? authenticationFailed,
  }) {
    return serverTimeout?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Other value)? other,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_PoorConnection value)? poorConnection,
    TResult Function(_ServerTimeout value)? serverTimeout,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult Function(_AccountLocked value)? accountLocked,
    TResult Function(_AccountExpired value)? accountExpired,
    TResult Function(_TokenExpired value)? tokenExpired,
    TResult Function(_AuthenticationFailed value)? authenticationFailed,
    required TResult orElse(),
  }) {
    if (serverTimeout != null) {
      return serverTimeout(this);
    }
    return orElse();
  }
}

abstract class _ServerTimeout implements ApiFailure {
  const factory _ServerTimeout() = _$_ServerTimeout;
}

/// @nodoc
abstract class _$$_UserNotFoundCopyWith<$Res> {
  factory _$$_UserNotFoundCopyWith(
          _$_UserNotFound value, $Res Function(_$_UserNotFound) then) =
      __$$_UserNotFoundCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_UserNotFoundCopyWithImpl<$Res>
    extends _$ApiFailureCopyWithImpl<$Res, _$_UserNotFound>
    implements _$$_UserNotFoundCopyWith<$Res> {
  __$$_UserNotFoundCopyWithImpl(
      _$_UserNotFound _value, $Res Function(_$_UserNotFound) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_UserNotFound implements _UserNotFound {
  const _$_UserNotFound();

  @override
  String toString() {
    return 'ApiFailure.userNotFound()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_UserNotFound);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) other,
    required TResult Function(String message) serverError,
    required TResult Function() poorConnection,
    required TResult Function() serverTimeout,
    required TResult Function() userNotFound,
    required TResult Function() invalidEmailAndPasswordCombination,
    required TResult Function() accountLocked,
    required TResult Function() accountExpired,
    required TResult Function() tokenExpired,
    required TResult Function() authenticationFailed,
  }) {
    return userNotFound();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? other,
    TResult? Function(String message)? serverError,
    TResult? Function()? poorConnection,
    TResult? Function()? serverTimeout,
    TResult? Function()? userNotFound,
    TResult? Function()? invalidEmailAndPasswordCombination,
    TResult? Function()? accountLocked,
    TResult? Function()? accountExpired,
    TResult? Function()? tokenExpired,
    TResult? Function()? authenticationFailed,
  }) {
    return userNotFound?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? other,
    TResult Function(String message)? serverError,
    TResult Function()? poorConnection,
    TResult Function()? serverTimeout,
    TResult Function()? userNotFound,
    TResult Function()? invalidEmailAndPasswordCombination,
    TResult Function()? accountLocked,
    TResult Function()? accountExpired,
    TResult Function()? tokenExpired,
    TResult Function()? authenticationFailed,
    required TResult orElse(),
  }) {
    if (userNotFound != null) {
      return userNotFound();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Other value) other,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_PoorConnection value) poorConnection,
    required TResult Function(_ServerTimeout value) serverTimeout,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_InvalidEmailAndPasswordCombination value)
        invalidEmailAndPasswordCombination,
    required TResult Function(_AccountLocked value) accountLocked,
    required TResult Function(_AccountExpired value) accountExpired,
    required TResult Function(_TokenExpired value) tokenExpired,
    required TResult Function(_AuthenticationFailed value) authenticationFailed,
  }) {
    return userNotFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Other value)? other,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_PoorConnection value)? poorConnection,
    TResult? Function(_ServerTimeout value)? serverTimeout,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult? Function(_AccountLocked value)? accountLocked,
    TResult? Function(_AccountExpired value)? accountExpired,
    TResult? Function(_TokenExpired value)? tokenExpired,
    TResult? Function(_AuthenticationFailed value)? authenticationFailed,
  }) {
    return userNotFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Other value)? other,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_PoorConnection value)? poorConnection,
    TResult Function(_ServerTimeout value)? serverTimeout,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult Function(_AccountLocked value)? accountLocked,
    TResult Function(_AccountExpired value)? accountExpired,
    TResult Function(_TokenExpired value)? tokenExpired,
    TResult Function(_AuthenticationFailed value)? authenticationFailed,
    required TResult orElse(),
  }) {
    if (userNotFound != null) {
      return userNotFound(this);
    }
    return orElse();
  }
}

abstract class _UserNotFound implements ApiFailure {
  const factory _UserNotFound() = _$_UserNotFound;
}

/// @nodoc
abstract class _$$_InvalidEmailAndPasswordCombinationCopyWith<$Res> {
  factory _$$_InvalidEmailAndPasswordCombinationCopyWith(
          _$_InvalidEmailAndPasswordCombination value,
          $Res Function(_$_InvalidEmailAndPasswordCombination) then) =
      __$$_InvalidEmailAndPasswordCombinationCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_InvalidEmailAndPasswordCombinationCopyWithImpl<$Res>
    extends _$ApiFailureCopyWithImpl<$Res,
        _$_InvalidEmailAndPasswordCombination>
    implements _$$_InvalidEmailAndPasswordCombinationCopyWith<$Res> {
  __$$_InvalidEmailAndPasswordCombinationCopyWithImpl(
      _$_InvalidEmailAndPasswordCombination _value,
      $Res Function(_$_InvalidEmailAndPasswordCombination) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_InvalidEmailAndPasswordCombination
    implements _InvalidEmailAndPasswordCombination {
  const _$_InvalidEmailAndPasswordCombination();

  @override
  String toString() {
    return 'ApiFailure.invalidEmailAndPasswordCombination()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_InvalidEmailAndPasswordCombination);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) other,
    required TResult Function(String message) serverError,
    required TResult Function() poorConnection,
    required TResult Function() serverTimeout,
    required TResult Function() userNotFound,
    required TResult Function() invalidEmailAndPasswordCombination,
    required TResult Function() accountLocked,
    required TResult Function() accountExpired,
    required TResult Function() tokenExpired,
    required TResult Function() authenticationFailed,
  }) {
    return invalidEmailAndPasswordCombination();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? other,
    TResult? Function(String message)? serverError,
    TResult? Function()? poorConnection,
    TResult? Function()? serverTimeout,
    TResult? Function()? userNotFound,
    TResult? Function()? invalidEmailAndPasswordCombination,
    TResult? Function()? accountLocked,
    TResult? Function()? accountExpired,
    TResult? Function()? tokenExpired,
    TResult? Function()? authenticationFailed,
  }) {
    return invalidEmailAndPasswordCombination?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? other,
    TResult Function(String message)? serverError,
    TResult Function()? poorConnection,
    TResult Function()? serverTimeout,
    TResult Function()? userNotFound,
    TResult Function()? invalidEmailAndPasswordCombination,
    TResult Function()? accountLocked,
    TResult Function()? accountExpired,
    TResult Function()? tokenExpired,
    TResult Function()? authenticationFailed,
    required TResult orElse(),
  }) {
    if (invalidEmailAndPasswordCombination != null) {
      return invalidEmailAndPasswordCombination();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Other value) other,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_PoorConnection value) poorConnection,
    required TResult Function(_ServerTimeout value) serverTimeout,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_InvalidEmailAndPasswordCombination value)
        invalidEmailAndPasswordCombination,
    required TResult Function(_AccountLocked value) accountLocked,
    required TResult Function(_AccountExpired value) accountExpired,
    required TResult Function(_TokenExpired value) tokenExpired,
    required TResult Function(_AuthenticationFailed value) authenticationFailed,
  }) {
    return invalidEmailAndPasswordCombination(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Other value)? other,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_PoorConnection value)? poorConnection,
    TResult? Function(_ServerTimeout value)? serverTimeout,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult? Function(_AccountLocked value)? accountLocked,
    TResult? Function(_AccountExpired value)? accountExpired,
    TResult? Function(_TokenExpired value)? tokenExpired,
    TResult? Function(_AuthenticationFailed value)? authenticationFailed,
  }) {
    return invalidEmailAndPasswordCombination?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Other value)? other,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_PoorConnection value)? poorConnection,
    TResult Function(_ServerTimeout value)? serverTimeout,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult Function(_AccountLocked value)? accountLocked,
    TResult Function(_AccountExpired value)? accountExpired,
    TResult Function(_TokenExpired value)? tokenExpired,
    TResult Function(_AuthenticationFailed value)? authenticationFailed,
    required TResult orElse(),
  }) {
    if (invalidEmailAndPasswordCombination != null) {
      return invalidEmailAndPasswordCombination(this);
    }
    return orElse();
  }
}

abstract class _InvalidEmailAndPasswordCombination implements ApiFailure {
  const factory _InvalidEmailAndPasswordCombination() =
      _$_InvalidEmailAndPasswordCombination;
}

/// @nodoc
abstract class _$$_AccountLockedCopyWith<$Res> {
  factory _$$_AccountLockedCopyWith(
          _$_AccountLocked value, $Res Function(_$_AccountLocked) then) =
      __$$_AccountLockedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_AccountLockedCopyWithImpl<$Res>
    extends _$ApiFailureCopyWithImpl<$Res, _$_AccountLocked>
    implements _$$_AccountLockedCopyWith<$Res> {
  __$$_AccountLockedCopyWithImpl(
      _$_AccountLocked _value, $Res Function(_$_AccountLocked) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_AccountLocked implements _AccountLocked {
  const _$_AccountLocked();

  @override
  String toString() {
    return 'ApiFailure.accountLocked()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_AccountLocked);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) other,
    required TResult Function(String message) serverError,
    required TResult Function() poorConnection,
    required TResult Function() serverTimeout,
    required TResult Function() userNotFound,
    required TResult Function() invalidEmailAndPasswordCombination,
    required TResult Function() accountLocked,
    required TResult Function() accountExpired,
    required TResult Function() tokenExpired,
    required TResult Function() authenticationFailed,
  }) {
    return accountLocked();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? other,
    TResult? Function(String message)? serverError,
    TResult? Function()? poorConnection,
    TResult? Function()? serverTimeout,
    TResult? Function()? userNotFound,
    TResult? Function()? invalidEmailAndPasswordCombination,
    TResult? Function()? accountLocked,
    TResult? Function()? accountExpired,
    TResult? Function()? tokenExpired,
    TResult? Function()? authenticationFailed,
  }) {
    return accountLocked?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? other,
    TResult Function(String message)? serverError,
    TResult Function()? poorConnection,
    TResult Function()? serverTimeout,
    TResult Function()? userNotFound,
    TResult Function()? invalidEmailAndPasswordCombination,
    TResult Function()? accountLocked,
    TResult Function()? accountExpired,
    TResult Function()? tokenExpired,
    TResult Function()? authenticationFailed,
    required TResult orElse(),
  }) {
    if (accountLocked != null) {
      return accountLocked();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Other value) other,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_PoorConnection value) poorConnection,
    required TResult Function(_ServerTimeout value) serverTimeout,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_InvalidEmailAndPasswordCombination value)
        invalidEmailAndPasswordCombination,
    required TResult Function(_AccountLocked value) accountLocked,
    required TResult Function(_AccountExpired value) accountExpired,
    required TResult Function(_TokenExpired value) tokenExpired,
    required TResult Function(_AuthenticationFailed value) authenticationFailed,
  }) {
    return accountLocked(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Other value)? other,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_PoorConnection value)? poorConnection,
    TResult? Function(_ServerTimeout value)? serverTimeout,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult? Function(_AccountLocked value)? accountLocked,
    TResult? Function(_AccountExpired value)? accountExpired,
    TResult? Function(_TokenExpired value)? tokenExpired,
    TResult? Function(_AuthenticationFailed value)? authenticationFailed,
  }) {
    return accountLocked?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Other value)? other,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_PoorConnection value)? poorConnection,
    TResult Function(_ServerTimeout value)? serverTimeout,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult Function(_AccountLocked value)? accountLocked,
    TResult Function(_AccountExpired value)? accountExpired,
    TResult Function(_TokenExpired value)? tokenExpired,
    TResult Function(_AuthenticationFailed value)? authenticationFailed,
    required TResult orElse(),
  }) {
    if (accountLocked != null) {
      return accountLocked(this);
    }
    return orElse();
  }
}

abstract class _AccountLocked implements ApiFailure {
  const factory _AccountLocked() = _$_AccountLocked;
}

/// @nodoc
abstract class _$$_AccountExpiredCopyWith<$Res> {
  factory _$$_AccountExpiredCopyWith(
          _$_AccountExpired value, $Res Function(_$_AccountExpired) then) =
      __$$_AccountExpiredCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_AccountExpiredCopyWithImpl<$Res>
    extends _$ApiFailureCopyWithImpl<$Res, _$_AccountExpired>
    implements _$$_AccountExpiredCopyWith<$Res> {
  __$$_AccountExpiredCopyWithImpl(
      _$_AccountExpired _value, $Res Function(_$_AccountExpired) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_AccountExpired implements _AccountExpired {
  const _$_AccountExpired();

  @override
  String toString() {
    return 'ApiFailure.accountExpired()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_AccountExpired);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) other,
    required TResult Function(String message) serverError,
    required TResult Function() poorConnection,
    required TResult Function() serverTimeout,
    required TResult Function() userNotFound,
    required TResult Function() invalidEmailAndPasswordCombination,
    required TResult Function() accountLocked,
    required TResult Function() accountExpired,
    required TResult Function() tokenExpired,
    required TResult Function() authenticationFailed,
  }) {
    return accountExpired();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? other,
    TResult? Function(String message)? serverError,
    TResult? Function()? poorConnection,
    TResult? Function()? serverTimeout,
    TResult? Function()? userNotFound,
    TResult? Function()? invalidEmailAndPasswordCombination,
    TResult? Function()? accountLocked,
    TResult? Function()? accountExpired,
    TResult? Function()? tokenExpired,
    TResult? Function()? authenticationFailed,
  }) {
    return accountExpired?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? other,
    TResult Function(String message)? serverError,
    TResult Function()? poorConnection,
    TResult Function()? serverTimeout,
    TResult Function()? userNotFound,
    TResult Function()? invalidEmailAndPasswordCombination,
    TResult Function()? accountLocked,
    TResult Function()? accountExpired,
    TResult Function()? tokenExpired,
    TResult Function()? authenticationFailed,
    required TResult orElse(),
  }) {
    if (accountExpired != null) {
      return accountExpired();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Other value) other,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_PoorConnection value) poorConnection,
    required TResult Function(_ServerTimeout value) serverTimeout,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_InvalidEmailAndPasswordCombination value)
        invalidEmailAndPasswordCombination,
    required TResult Function(_AccountLocked value) accountLocked,
    required TResult Function(_AccountExpired value) accountExpired,
    required TResult Function(_TokenExpired value) tokenExpired,
    required TResult Function(_AuthenticationFailed value) authenticationFailed,
  }) {
    return accountExpired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Other value)? other,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_PoorConnection value)? poorConnection,
    TResult? Function(_ServerTimeout value)? serverTimeout,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult? Function(_AccountLocked value)? accountLocked,
    TResult? Function(_AccountExpired value)? accountExpired,
    TResult? Function(_TokenExpired value)? tokenExpired,
    TResult? Function(_AuthenticationFailed value)? authenticationFailed,
  }) {
    return accountExpired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Other value)? other,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_PoorConnection value)? poorConnection,
    TResult Function(_ServerTimeout value)? serverTimeout,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult Function(_AccountLocked value)? accountLocked,
    TResult Function(_AccountExpired value)? accountExpired,
    TResult Function(_TokenExpired value)? tokenExpired,
    TResult Function(_AuthenticationFailed value)? authenticationFailed,
    required TResult orElse(),
  }) {
    if (accountExpired != null) {
      return accountExpired(this);
    }
    return orElse();
  }
}

abstract class _AccountExpired implements ApiFailure {
  const factory _AccountExpired() = _$_AccountExpired;
}

/// @nodoc
abstract class _$$_TokenExpiredCopyWith<$Res> {
  factory _$$_TokenExpiredCopyWith(
          _$_TokenExpired value, $Res Function(_$_TokenExpired) then) =
      __$$_TokenExpiredCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_TokenExpiredCopyWithImpl<$Res>
    extends _$ApiFailureCopyWithImpl<$Res, _$_TokenExpired>
    implements _$$_TokenExpiredCopyWith<$Res> {
  __$$_TokenExpiredCopyWithImpl(
      _$_TokenExpired _value, $Res Function(_$_TokenExpired) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_TokenExpired implements _TokenExpired {
  const _$_TokenExpired();

  @override
  String toString() {
    return 'ApiFailure.tokenExpired()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_TokenExpired);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) other,
    required TResult Function(String message) serverError,
    required TResult Function() poorConnection,
    required TResult Function() serverTimeout,
    required TResult Function() userNotFound,
    required TResult Function() invalidEmailAndPasswordCombination,
    required TResult Function() accountLocked,
    required TResult Function() accountExpired,
    required TResult Function() tokenExpired,
    required TResult Function() authenticationFailed,
  }) {
    return tokenExpired();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? other,
    TResult? Function(String message)? serverError,
    TResult? Function()? poorConnection,
    TResult? Function()? serverTimeout,
    TResult? Function()? userNotFound,
    TResult? Function()? invalidEmailAndPasswordCombination,
    TResult? Function()? accountLocked,
    TResult? Function()? accountExpired,
    TResult? Function()? tokenExpired,
    TResult? Function()? authenticationFailed,
  }) {
    return tokenExpired?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? other,
    TResult Function(String message)? serverError,
    TResult Function()? poorConnection,
    TResult Function()? serverTimeout,
    TResult Function()? userNotFound,
    TResult Function()? invalidEmailAndPasswordCombination,
    TResult Function()? accountLocked,
    TResult Function()? accountExpired,
    TResult Function()? tokenExpired,
    TResult Function()? authenticationFailed,
    required TResult orElse(),
  }) {
    if (tokenExpired != null) {
      return tokenExpired();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Other value) other,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_PoorConnection value) poorConnection,
    required TResult Function(_ServerTimeout value) serverTimeout,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_InvalidEmailAndPasswordCombination value)
        invalidEmailAndPasswordCombination,
    required TResult Function(_AccountLocked value) accountLocked,
    required TResult Function(_AccountExpired value) accountExpired,
    required TResult Function(_TokenExpired value) tokenExpired,
    required TResult Function(_AuthenticationFailed value) authenticationFailed,
  }) {
    return tokenExpired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Other value)? other,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_PoorConnection value)? poorConnection,
    TResult? Function(_ServerTimeout value)? serverTimeout,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult? Function(_AccountLocked value)? accountLocked,
    TResult? Function(_AccountExpired value)? accountExpired,
    TResult? Function(_TokenExpired value)? tokenExpired,
    TResult? Function(_AuthenticationFailed value)? authenticationFailed,
  }) {
    return tokenExpired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Other value)? other,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_PoorConnection value)? poorConnection,
    TResult Function(_ServerTimeout value)? serverTimeout,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult Function(_AccountLocked value)? accountLocked,
    TResult Function(_AccountExpired value)? accountExpired,
    TResult Function(_TokenExpired value)? tokenExpired,
    TResult Function(_AuthenticationFailed value)? authenticationFailed,
    required TResult orElse(),
  }) {
    if (tokenExpired != null) {
      return tokenExpired(this);
    }
    return orElse();
  }
}

abstract class _TokenExpired implements ApiFailure {
  const factory _TokenExpired() = _$_TokenExpired;
}

/// @nodoc
abstract class _$$_AuthenticationFailedCopyWith<$Res> {
  factory _$$_AuthenticationFailedCopyWith(_$_AuthenticationFailed value,
          $Res Function(_$_AuthenticationFailed) then) =
      __$$_AuthenticationFailedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_AuthenticationFailedCopyWithImpl<$Res>
    extends _$ApiFailureCopyWithImpl<$Res, _$_AuthenticationFailed>
    implements _$$_AuthenticationFailedCopyWith<$Res> {
  __$$_AuthenticationFailedCopyWithImpl(_$_AuthenticationFailed _value,
      $Res Function(_$_AuthenticationFailed) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_AuthenticationFailed implements _AuthenticationFailed {
  const _$_AuthenticationFailed();

  @override
  String toString() {
    return 'ApiFailure.authenticationFailed()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_AuthenticationFailed);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) other,
    required TResult Function(String message) serverError,
    required TResult Function() poorConnection,
    required TResult Function() serverTimeout,
    required TResult Function() userNotFound,
    required TResult Function() invalidEmailAndPasswordCombination,
    required TResult Function() accountLocked,
    required TResult Function() accountExpired,
    required TResult Function() tokenExpired,
    required TResult Function() authenticationFailed,
  }) {
    return authenticationFailed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? other,
    TResult? Function(String message)? serverError,
    TResult? Function()? poorConnection,
    TResult? Function()? serverTimeout,
    TResult? Function()? userNotFound,
    TResult? Function()? invalidEmailAndPasswordCombination,
    TResult? Function()? accountLocked,
    TResult? Function()? accountExpired,
    TResult? Function()? tokenExpired,
    TResult? Function()? authenticationFailed,
  }) {
    return authenticationFailed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? other,
    TResult Function(String message)? serverError,
    TResult Function()? poorConnection,
    TResult Function()? serverTimeout,
    TResult Function()? userNotFound,
    TResult Function()? invalidEmailAndPasswordCombination,
    TResult Function()? accountLocked,
    TResult Function()? accountExpired,
    TResult Function()? tokenExpired,
    TResult Function()? authenticationFailed,
    required TResult orElse(),
  }) {
    if (authenticationFailed != null) {
      return authenticationFailed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Other value) other,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_PoorConnection value) poorConnection,
    required TResult Function(_ServerTimeout value) serverTimeout,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_InvalidEmailAndPasswordCombination value)
        invalidEmailAndPasswordCombination,
    required TResult Function(_AccountLocked value) accountLocked,
    required TResult Function(_AccountExpired value) accountExpired,
    required TResult Function(_TokenExpired value) tokenExpired,
    required TResult Function(_AuthenticationFailed value) authenticationFailed,
  }) {
    return authenticationFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Other value)? other,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_PoorConnection value)? poorConnection,
    TResult? Function(_ServerTimeout value)? serverTimeout,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult? Function(_AccountLocked value)? accountLocked,
    TResult? Function(_AccountExpired value)? accountExpired,
    TResult? Function(_TokenExpired value)? tokenExpired,
    TResult? Function(_AuthenticationFailed value)? authenticationFailed,
  }) {
    return authenticationFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Other value)? other,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_PoorConnection value)? poorConnection,
    TResult Function(_ServerTimeout value)? serverTimeout,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_InvalidEmailAndPasswordCombination value)?
        invalidEmailAndPasswordCombination,
    TResult Function(_AccountLocked value)? accountLocked,
    TResult Function(_AccountExpired value)? accountExpired,
    TResult Function(_TokenExpired value)? tokenExpired,
    TResult Function(_AuthenticationFailed value)? authenticationFailed,
    required TResult orElse(),
  }) {
    if (authenticationFailed != null) {
      return authenticationFailed(this);
    }
    return orElse();
  }
}

abstract class _AuthenticationFailed implements ApiFailure {
  const factory _AuthenticationFailed() = _$_AuthenticationFailed;
}
