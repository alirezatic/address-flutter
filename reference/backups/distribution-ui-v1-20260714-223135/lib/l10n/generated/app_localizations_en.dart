// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Super App';

  @override
  String get home => 'Home';

  @override
  String get phoneNumber => 'Mobile number';

  @override
  String get continueLabel => 'Continue';

  @override
  String get retry => 'Retry';

  @override
  String get unknownError => 'An unknown error occurred';

  @override
  String get getStarted => 'Get started';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get onboardingSubtitle =>
      'Experience transportation, shopping, delivery, and everyday services more easily.';

  @override
  String get onboardingTitle => 'Every city service, in one Address';

  @override
  String get login => 'Login';

  @override
  String get welcome => 'Welcome';

  @override
  String get enteryourmobilenumber => 'Enter your mobile number';

  @override
  String get mobileNumber => 'Mobile number';

  @override
  String get enterMobileError => 'Please enter your mobile number';

  @override
  String get notDigits => 'Mobile number must contain only digits';

  @override
  String get invalidPrefix => 'Mobile number must start with \'09\' or \'9\'';

  @override
  String get enterMobileErrorWithZero =>
      'Mobile number must be 11 digits (with leading zero)';

  @override
  String get enterMobileErrorWithoutZero =>
      'Mobile number must be 10 digits (without leading zero)';

  @override
  String get tooShort => 'The entered number is too short';

  @override
  String get networkError => 'Network error, please check your connection';

  @override
  String enterOtpCode(Object phoneNumber) {
    return 'Enter the 5-digit code sent to $phoneNumber';
  }

  @override
  String didNotReceiveCode(Object seconds) {
    return 'I didn’t receive a code (00:$seconds)';
  }

  @override
  String get resendCode => 'Resend Code';

  @override
  String get changeNumber => 'Change number';

  @override
  String get or => 'Or';

  @override
  String get email => 'Email';

  @override
  String get enterFullOtpCode => 'Please enter the full 5-digit code';

  @override
  String get invalidOtpCode => 'The verification code is incorrect';

  @override
  String get expiredOtpCode =>
      'The verification code has expired. Request a new code';

  @override
  String get otpRequestTooSoon => 'Please wait before requesting another code';

  @override
  String get language => 'Language';

  @override
  String get logOut => 'Log out';

  @override
  String get services => 'Services';

  @override
  String get activity => 'Activity';

  @override
  String get messages => 'Messages';

  @override
  String get settings => 'Settings';

  @override
  String get sendGift => 'Send a gift';

  @override
  String get businessHub => 'Business hub';

  @override
  String get manageAddressAccount => 'Manage Address account';

  @override
  String get ride => 'Ride';

  @override
  String get deliver => 'Deliver';

  @override
  String get airport => 'Airport';

  @override
  String get bike => 'Bike';

  @override
  String get safeYourTrip => 'Travel safely';

  @override
  String get anywhereCityTrip => 'Anywhere in the city';

  @override
  String get cityOrIntercityTrip => 'City or intercity trip';

  @override
  String get fastAndSafe => 'Fast and safe';

  @override
  String get passengerServices => 'Passenger ';

  @override
  String get cargoServices => 'Cargo & Freight';

  @override
  String get foodServices => 'Food & Groceries';

  @override
  String get generalServices => 'General ';

  @override
  String get repairServices => 'Repair & Parts';

  @override
  String get insuranceServices => 'Insurance';

  @override
  String get comingSoon => 'This section is coming soon.';

  @override
  String get logoutConfirmTitle => 'Log out';

  @override
  String get logoutConfirmMessage => 'Do you want to log out of your account?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Log out';

  @override
  String get addressUser => 'Address user';
}
