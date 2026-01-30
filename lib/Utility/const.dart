import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static final baseUrl = dotenv.env['BASE_URL'];
}

class AppConstants {
  static final String appName = "Jio7"; //TODO: Change This
  static final String appLogo = "asset/icons/logo.png"; //TODO: Change This FILE
}


final String sharedPrefUserIdKey = 'user_id';
final String sharedPrefFCMTokenKey = 'fcm_token';
final String sharedPrefAPITokenKey = 'api_token';

const String appName = "Vip999";
const String appLogo = "asset/icons/logo.png";

final String url = dotenv.env['SHARE_URL'] ?? '';

///-----------------------------

String _full(String path) => '${Constants.baseUrl}$path';

final String loginApi = _full(dotenv.env['LOGIN_API'] ?? '');
final String logOutApi = _full(dotenv.env['LOGOUT_API'] ?? '');
final String checkUserExistApi = _full(dotenv.env['CHECK_USER_EXIST_API'] ?? '');
final String sendOtpApiUrl = _full(dotenv.env['SEND_OTP_API'] ?? '');
final String howToPlayApiUrl = _full(dotenv.env['HOW_TO_PLAY_API'] ?? '');
final String getLiveDataByMarketId = _full(dotenv.env['GET_LIVE_DATA_BY_MARKET_ID'] ?? '');
final String registerApi = _full(dotenv.env['REGISTER_API'] ?? '');
final String forgetPassApi = _full(dotenv.env['FORGET_PASS_API'] ?? '');
final String bannersApi = _full(dotenv.env['BANNERS_API'] ?? '');
final String popBannerApi = _full(dotenv.env['POP_BANNER_API'] ?? '');
final String marketApi = _full(dotenv.env['MARKET_API'] ?? '');
final String gameTypesApi = _full(dotenv.env['GAME_TYPES_API'] ?? '');
final String userProfileApi = _full(dotenv.env['USER_PROFILE_API'] ?? '');
final String editProfileApi = _full(dotenv.env['EDIT_PROFILE_API'] ?? '');
final String paymentReceiveNewApi = _full(dotenv.env['PAYMENT_RECEIVE_NEW_API'] ?? '');
final String getRefferalCodeApi = _full(dotenv.env['GET_REFERRAL_CODE_API'] ?? '');
final String getVersionNumberApi = _full(dotenv.env['GET_VERSION_NUMBER_API'] ?? '');
final String placeBidApi = _full(dotenv.env['PLACE_BID_API'] ?? '');
final String placeBidNewApi = _full(dotenv.env['PLACE_BID_NEW_API'] ?? '');
final String placeSPDPTPBidNewApi = _full(dotenv.env['PLACE_SPDPTP_BID_NEW_API'] ?? '');
final String winHistoryApi = _full(dotenv.env['WIN_HISTORY_API'] ?? '');
final String cancelBidApiUrl = _full(dotenv.env['CANCEL_BID_API'] ?? '');
final String getVideosApi = _full(dotenv.env['GET_VIDEOS_API'] ?? '');
final String bidHistoryApi = _full(dotenv.env['BID_HISTORY_API'] ?? '');
final String generateUpiPayment = _full(dotenv.env['GENERATE_UPI_PAYMENT_API'] ?? '');
final String addMoneyToWalletApi = _full(dotenv.env['ADD_MONEY_TO_WALLET_API'] ?? '');
final String panaByAnkApi = _full(dotenv.env['PANA_BY_ANK_API'] ?? '');
final String addMoneyLimitCheckAPi = _full(dotenv.env['ADD_MONEY_LIMIT_CHECK_API'] ?? '');
final String getAdminUpi = _full(dotenv.env['GET_ADMIN_UPI_API'] ?? '');
final String getwithdrawDetailsUpi = _full(dotenv.env['GET_WITHDRAW_DETAILS_UPI_API'] ?? '');
final String addAcountApi = _full(dotenv.env['ADD_ACCOUNT_API'] ?? '');
final String getBankDetailsApi = _full(dotenv.env['GET_BANK_DETAILS_API'] ?? '');
final String withdrawAmountApi = _full(dotenv.env['WITHDRAW_AMOUNT_API'] ?? '');
final String withdrawAmountApiForTime = _full(dotenv.env['WITHDRAW_AMOUNT_TIME_API'] ?? '');
final String referCodeApi = _full(dotenv.env['REFER_CODE_API'] ?? '');
final String sendOtpApi = _full(dotenv.env['SEND_OTP_ALT_API'] ?? '');
final String verifyOtpApi = _full(dotenv.env['VERIFY_OTP_API'] ?? '');
final String gameRateApi = _full(dotenv.env['GAME_RATE_API'] ?? '');
final String checkOpenCloseTimeApi = _full(dotenv.env['CHECK_OPEN_CLOSE_TIME_API'] ?? '');
final String settingApi = _full(dotenv.env['SETTING_API'] ?? '');
final String getPhoneNumberApi = _full(dotenv.env['GET_PHONE_NUMBER_API'] ?? '');
final String panaListApi = _full(dotenv.env['PANA_LIST_API'] ?? '');
final String searchDigitApi = _full(dotenv.env['SEARCH_DIGIT_API'] ?? '');
final String oddEvenApi = _full(dotenv.env['ODD_EVEN_API'] ?? '');
final String redJodiApi = _full(dotenv.env['RED_JODI_API'] ?? '');
final String suggestionListApi = _full(dotenv.env['SUGGESTION_LIST_API'] ?? '');
final String getpattiesApi = _full(dotenv.env['GET_PATTIES_API'] ?? '');
final String placeBidForPattiApi = _full(dotenv.env['PLACE_BID_FOR_PATTI_API'] ?? '');
final String getsuggestionApi = _full(dotenv.env['GET_SUGGESTION_API'] ?? '');
final String checkBankDetailApi = _full(dotenv.env['CHECK_BANK_DETAIL_API'] ?? '');
final String notificationApi = _full(dotenv.env['NOTIFICATION_API'] ?? '');
final String transactionHistoryApi = _full(dotenv.env['TRANSACTION_HISTORY_API'] ?? '');
final String instructionApi = _full(dotenv.env['INSTRUCTION_API'] ?? '');
final String depositListApi = _full(dotenv.env['DEPOSIT_LIST_API'] ?? '');
final String homeTextApi = _full(dotenv.env['HOME_TEXT_API'] ?? '');
final String getAllSubscriptionApiUrl = _full(dotenv.env['GET_ALL_SUBSCRIPTION_API'] ?? '');
final String assignSubscriptionApiUrl = _full(dotenv.env['ASSIGN_SUBSCRIPTION_API'] ?? '');
final String checkAppApiUrl = _full(dotenv.env['CHECK_APP_API'] ?? '');
final String changePassApi = _full(dotenv.env['CHANGE_PASS_API'] ?? '');
final String getAviApi = _full(dotenv.env['GET_AVI'] ?? '');
final String setAviApi = _full(dotenv.env['SET_AVI'] ?? '');
final String addGalleryImageApi = _full(dotenv.env['ADD_GALLERY_IMAGES'] ?? '');
final String getAllEaringApi = _full(dotenv.env['GET_ALL_EARING'] ?? '');






///-----------------------------
