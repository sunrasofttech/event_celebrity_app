class Constants {
  static String baseUrl = "https://api.mobiii.shop";
}

class AppConstants {
  static final String appName = "Goa567"; //TODO: Change This
  static final String appLogo = "asset/icons/logo.png"; //TODO: Change This FILE
}

const String appName = "Goa567";
const String appLogo = "asset/icons/logo.png";
final String sharedPrefFCMTokenKey = 'fcm_token';
final String sharedPrefAPITokenKey = 'api_token';

final String url = 'https://mobisattaresult.com/';

final String loginApi = '${Constants.baseUrl}/app/user/login';
final String logOutApi = '${Constants.baseUrl}/app/user/logout';

final String checkUserExistApi = '${Constants.baseUrl}/app/user/check-user';
final String sendOtpApiUrl = "${Constants.baseUrl}/app/user/get-otp";

final String changePassApi = '${Constants.baseUrl}/app/user/changePassword';
final String registerApi = '${Constants.baseUrl}/app/user/createUser';

final String forgetPassApi = '${Constants.baseUrl}/api/forgetPass';

final String bannersApi = '${Constants.baseUrl}/app/banner/getAllBanner';
final String popBannerApi = '${Constants.baseUrl}/api/popBannerJ';

final String marketApi = '${Constants.baseUrl}/app/market/getAllActiveMarkets?market_type=';
final String gameTypesApi = '${Constants.baseUrl}/app/game/getAllGamesUser';
final String userProfileApi = '${Constants.baseUrl}/app/user/getProfile';

final String editProfileApi = '${Constants.baseUrl}/app/user/updateUser';
final String paymentReceiveNewApi = '${Constants.baseUrl}/app/deposit/paymentReceiveNew';

final String getRefferalCodeApi = '${Constants.baseUrl}/api/getRefferalCode';
final String getVersionNumberApi = '${Constants.baseUrl}/app/settings/getAllSettingsUser';

// Bids
final String placeBidApi = '${Constants.baseUrl}/app/bid/createBid';
final String placeBidNewApi = '${Constants.baseUrl}/app/bid/createBidNew';
final String placeSPDPTPBidNewApi = '${Constants.baseUrl}/app/bid/createBidSpDpTpNew';
final String winHistoryApi = '${Constants.baseUrl}/app/winners/getWinningHistoryByDate';

final String cancelBidApiUrl = "${Constants.baseUrl}/app/bid/bid_cancel";

final String getVideosApi = '${Constants.baseUrl}/api/videos';
final String bidHistoryApi = '${Constants.baseUrl}/app/bid/getAllBidByUserId';

final String generateUpiPayment = '${Constants.baseUrl}/app/deposit/createDeposit';

// Payments APIs
final String addMoneyToWalletApi = '${Constants.baseUrl}/app/deposit/paymentReceive';
final String panaByAnkApi = '${Constants.baseUrl}/api/getPanasbyank';

final String addMoneyLimitCheckAPi = '${Constants.baseUrl}/api/checkLimit';
final String getAdminUpi = '${Constants.baseUrl}/api/upis';
final String getwithdrawDetailsUpi = '${Constants.baseUrl}/api/withdrawDetails';

final String addAcountApi = '${Constants.baseUrl}/app/bankDetails/createBankDetails';
final String getBankDetailsApi = '${Constants.baseUrl}/app/bankDetails/getAllBankDetails';

final String withdrawAmountApi = '${Constants.baseUrl}/app/withdrawRequest/createWithdrawRequest';
final String withdrawAmountApiForTime = '${Constants.baseUrl}/api/getWithdrawTime';
final String referCodeApi = '${Constants.baseUrl}/api/getRefferalCode';
final String sendOtpApi = '${Constants.baseUrl}/api/sendOtp';
final String verifyOtpApi = '${Constants.baseUrl}/api/verifyOtp';

final String gameRateApi = '${Constants.baseUrl}/app/game/getAllGamesUser';
final String checkOpenCloseTimeApi = '${Constants.baseUrl}/app/market/getMarketStatusType';
final String settingApi = '${Constants.baseUrl}/app/settings/getAllSettingsUser';
final String getPhoneNumberApi = '${Constants.baseUrl}/app/settings/getPhoneNumber';
final String panaListApi = '${Constants.baseUrl}/app/game/getPanasbyank';
final String searchDigitApi = '${Constants.baseUrl}/app/bid/searchDigit';
final String oddEvenApi = '${Constants.baseUrl}/app/game/oddEven';
final String redJodiApi = '${Constants.baseUrl}/app/game/redJodi';

final String suggestionListApi = '${Constants.baseUrl}/app/bid/searchDigit';
final String getpattiesApi = '${Constants.baseUrl}/api/getpatties';
final String placeBidForPattiApi = '${Constants.baseUrl}/api/bidonPana';
final String getsuggestionApi = '${Constants.baseUrl}/app/game/suggestpanas';

final String checkBankDetailApi = '${Constants.baseUrl}/app/bankDetails/getAllBankDetails';
final String notificationApi = '${Constants.baseUrl}/app/notification/getAllNotificationByUserId';
final String transactionHistoryApi = '${Constants.baseUrl}/app/transaction/getAllTransactionByDate';

final String instructionApi = '${Constants.baseUrl}/app/instruction/getAllInstructions';
final String depositListApi = '${Constants.baseUrl}/app/deposit/getDepositValue';

final String homeTextApi = '${Constants.baseUrl}/app/dashboard/getHomeText';
final String getAllSubscriptionApiUrl = '${Constants.baseUrl}/app/subscription/get-all';
final String assignSubscriptionApiUrl = '${Constants.baseUrl}/app/subscription/user';
final String checkAppApiUrl = '${Constants.baseUrl}/app/user/get-alert';
