import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.exceedingLength({
    required T failedValue,
    required int max,
  }) = ExceedingLength<T>;
  const factory ValueFailure.subceedLength({
    required T failedValue,
    required int min,
  }) = SubceedLength<T>;
  const factory ValueFailure.empty({
    required T failedValue,
  }) = Empty<T>;
  const factory ValueFailure.multiline({
    required T failedValue,
  }) = Multiline<T>;
  const factory ValueFailure.invalidEmail({
    required T failedValue,
  }) = InvalidEmail<T>;
  const factory ValueFailure.passwordNotMatchRequirements({
    required T failedValue,
  }) = ShortPassword<T>;
  const factory ValueFailure.invalidJWT({
    required T failedValue,
  }) = InvalidJWT<T>;
  const factory ValueFailure.invalidJWTPayload({
    required T failedValue,
  }) = InvalidJWTPayload<T>;
  const factory ValueFailure.mustOneUpperCaseCharacter({
    required T failedValue,
  }) = OneUpperCase<T>;
  const factory ValueFailure.mustOneLowerCaseCharacter({
    required T failedValue,
  }) = OneLowerCase<T>;
  const factory ValueFailure.mustOneNumericCharacter({
    required T failedValue,
  }) = OneNumeric<T>;
  const factory ValueFailure.mustOneSpecialCharacter({
    required T failedValue,
  }) = OneSpecial<T>;
  const factory ValueFailure.mustNotContainUserName({
    required T failedValue,
  }) = NotContainUserName<T>;
  const factory ValueFailure.mustNotMatchOldPassword({
    required T failedValue,
  }) = NotMatchOldPassword<T>;
  const factory ValueFailure.mustMatchNewPassword({
    required T failedValue,
  }) = MatchNewPassword<T>;
  const factory ValueFailure.isEmpty({
    required T failedValue,
  }) = isEmpty<T>;
  const factory ValueFailure.numberMustBiggerThanZero({
    required T failedValue,
  }) = numberMustBiggerThanZero<T>;
}
