
class RemoteConnections {
  static final String BASE_URL = "https://app.birungifinanceltd.com/api/";

  static final String CREATE_ACCOUNT_URL = BASE_URL + "register";

  static final String LOGIN_URL = BASE_URL + "login";

  static final String USER_PROFILE_URL = BASE_URL + "";

  static final String CHANGE_PASSWORD_URL = BASE_URL + "change-password";

  static final String FORGOT_PASSWORD_URL = BASE_URL + "users/forgot_password";

  static final String REST_PASSWORD_URL = BASE_URL + "users/reset_password";

  static final String GET_ALL_PROPERTIES_URL = BASE_URL + "property/all";

  static final String BOOK_REQUEST_URL = BASE_URL + "bookings/add";

  static final String GET_BOOKINGS_URL = BASE_URL + "bookings";

  static final String VERIFY_CODE_URL = BASE_URL + "validate-code";

  static final String PAYMENT_PROOF_URL = BASE_URL + "payments/proof";

  static final String PAY_RECEIPTS_URL = BASE_URL + "payments";

  static final String GET_ALL_PAYMENT_METHODS_URL = BASE_URL + "settings/payment_methods";

  static final String CALL_CENTER_URL = BASE_URL + "settings/detail";

  static final String CATEGORIES_URL = BASE_URL + "settings/categories";

  static final String SUBCATEGORIES_URL = BASE_URL + "settings/sub_categories";

  static final String NOTIFICATION_URL = BASE_URL + "notifications";
}