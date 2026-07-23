// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '超级应用';

  @override
  String get home => '首页';

  @override
  String get phoneNumber => '手机号码';

  @override
  String get continueLabel => '继续';

  @override
  String get retry => '重试';

  @override
  String get unknownError => '发生未知错误';

  @override
  String get getStarted => '开始';

  @override
  String get changeLanguage => '更改语言';

  @override
  String get onboardingSubtitle => '更轻松地使用出行、购物、配送和日常服务。';

  @override
  String get onboardingTitle => '城市服务，尽在一个地址';

  @override
  String get login => '登录';

  @override
  String get welcome => '欢迎';

  @override
  String get enteryourmobilenumber => '请输入您的手机号码';

  @override
  String get mobileNumber => '手机号码';

  @override
  String get enterMobileError => '请输入手机号码';

  @override
  String get notDigits => '手机号码只能包含数字';

  @override
  String get invalidPrefix => '手机号码必须以“09”或“9”开头';

  @override
  String get enterMobileErrorWithZero => '手机号码应为11位（以0开头）';

  @override
  String get enterMobileErrorWithoutZero => '手机号码应为10位（不以0开头）';

  @override
  String get tooShort => '手机号码过短';

  @override
  String get networkError => '网络错误，请检查您的连接';

  @override
  String enterOtpCode(Object phoneNumber) {
    return '请输入发送到 $phoneNumber 的五位验证码';
  }

  @override
  String didNotReceiveCode(Object seconds) {
    return '未收到验证码 (00:$seconds)';
  }

  @override
  String get resendCode => '重新发送验证码';

  @override
  String get changeNumber => '更改号码';

  @override
  String get or => '或';

  @override
  String get email => '电子邮件';

  @override
  String get enterFullOtpCode => '请输入完整的5位数字代码';

  @override
  String get language => '语言';

  @override
  String get logOut => '注销';

  @override
  String get services => '服务';

  @override
  String get activity => '活动';

  @override
  String get messages => '消息';

  @override
  String get settings => '设置';

  @override
  String get sendGift => '发送礼物';

  @override
  String get businessHub => '商务中心';

  @override
  String get manageAddressAccount => '管理账户和地址';

  @override
  String get ride => '出行';

  @override
  String get deliver => '配送';

  @override
  String get airport => '机场';

  @override
  String get bike => '摩托车';

  @override
  String get safeYourTrip => '保障您的旅程';

  @override
  String get anywhereCityTrip => '市内任意地点';

  @override
  String get cityOrIntercityTrip => '市内或城际行程';

  @override
  String get fastAndSafe => '快速且安全';

  @override
  String get passengerServices => '乘客服务';

  @override
  String get cargoServices => '货运服务';

  @override
  String get foodServices => '餐饮服务';

  @override
  String get generalServices => '综合服务';

  @override
  String get repairServices => '维修与配件';

  @override
  String get insuranceServices => '保险服务';

  @override
  String get comingSoon => '此功能即将上线。';

  @override
  String get logoutConfirmTitle => '退出登录';

  @override
  String get logoutConfirmMessage => '确定要退出当前账户吗？';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '退出';

  @override
  String get addressUser => '地址用户';
}
