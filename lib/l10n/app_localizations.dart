import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'打卡提醒'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In zh, this message translates to:
  /// **'首页'**
  String get home;

  /// No description provided for @records.
  ///
  /// In zh, this message translates to:
  /// **'记录'**
  String get records;

  /// No description provided for @statistics.
  ///
  /// In zh, this message translates to:
  /// **'统计'**
  String get statistics;

  /// No description provided for @settings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settings;

  /// No description provided for @statusUnknown.
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get statusUnknown;

  /// No description provided for @statusInside.
  ///
  /// In zh, this message translates to:
  /// **'在范围内'**
  String get statusInside;

  /// No description provided for @statusOutside.
  ///
  /// In zh, this message translates to:
  /// **'在范围外'**
  String get statusOutside;

  /// No description provided for @monitoring.
  ///
  /// In zh, this message translates to:
  /// **'监控中'**
  String get monitoring;

  /// No description provided for @notMonitoring.
  ///
  /// In zh, this message translates to:
  /// **'未启动'**
  String get notMonitoring;

  /// No description provided for @todayRecords.
  ///
  /// In zh, this message translates to:
  /// **'今日记录'**
  String get todayRecords;

  /// No description provided for @noRecordsToday.
  ///
  /// In zh, this message translates to:
  /// **'今天还没有打卡记录'**
  String get noRecordsToday;

  /// No description provided for @enterRange.
  ///
  /// In zh, this message translates to:
  /// **'进入范围'**
  String get enterRange;

  /// No description provided for @exitRange.
  ///
  /// In zh, this message translates to:
  /// **'离开范围'**
  String get exitRange;

  /// No description provided for @punched.
  ///
  /// In zh, this message translates to:
  /// **'已打卡'**
  String get punched;

  /// No description provided for @noRecordsOnDate.
  ///
  /// In zh, this message translates to:
  /// **'该日无打卡记录'**
  String get noRecordsOnDate;

  /// No description provided for @weekView.
  ///
  /// In zh, this message translates to:
  /// **'周'**
  String get weekView;

  /// No description provided for @monthView.
  ///
  /// In zh, this message translates to:
  /// **'月'**
  String get monthView;

  /// No description provided for @weekArrival.
  ///
  /// In zh, this message translates to:
  /// **'本周到达时间'**
  String get weekArrival;

  /// No description provided for @monthArrival.
  ///
  /// In zh, this message translates to:
  /// **'本月到达时间'**
  String get monthArrival;

  /// No description provided for @lateThresholdHint.
  ///
  /// In zh, this message translates to:
  /// **'9:30 以后到达标记为迟到'**
  String get lateThresholdHint;

  /// No description provided for @noData.
  ///
  /// In zh, this message translates to:
  /// **'暂无数据'**
  String get noData;

  /// No description provided for @attendanceDays.
  ///
  /// In zh, this message translates to:
  /// **'出勤天数'**
  String get attendanceDays;

  /// No description provided for @avgArrival.
  ///
  /// In zh, this message translates to:
  /// **'平均到达'**
  String get avgArrival;

  /// No description provided for @lateDays.
  ///
  /// In zh, this message translates to:
  /// **'迟到'**
  String get lateDays;

  /// No description provided for @forgotPunch.
  ///
  /// In zh, this message translates to:
  /// **'忘打卡'**
  String get forgotPunch;

  /// No description provided for @detail.
  ///
  /// In zh, this message translates to:
  /// **'明细'**
  String get detail;

  /// No description provided for @settingsTitle.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settingsTitle;

  /// No description provided for @companyLocation.
  ///
  /// In zh, this message translates to:
  /// **'公司位置'**
  String get companyLocation;

  /// No description provided for @addLocation.
  ///
  /// In zh, this message translates to:
  /// **'添加位置'**
  String get addLocation;

  /// No description provided for @addLocationSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'设置新的位置和围栏'**
  String get addLocationSubtitle;

  /// No description provided for @deleteLocation.
  ///
  /// In zh, this message translates to:
  /// **'删除位置'**
  String get deleteLocation;

  /// No description provided for @deleteLocationConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除「{name}」吗？'**
  String deleteLocationConfirm(Object name);

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @notificationSettings.
  ///
  /// In zh, this message translates to:
  /// **'通知设置'**
  String get notificationSettings;

  /// No description provided for @notifyOnEnter.
  ///
  /// In zh, this message translates to:
  /// **'进入时提醒'**
  String get notifyOnEnter;

  /// No description provided for @notifyOnEnterSub.
  ///
  /// In zh, this message translates to:
  /// **'到达范围时推送通知'**
  String get notifyOnEnterSub;

  /// No description provided for @notifyOnExit.
  ///
  /// In zh, this message translates to:
  /// **'离开时提醒'**
  String get notifyOnExit;

  /// No description provided for @notifyOnExitSub.
  ///
  /// In zh, this message translates to:
  /// **'离开范围时推送通知'**
  String get notifyOnExitSub;

  /// No description provided for @cooldownTime.
  ///
  /// In zh, this message translates to:
  /// **'通知冷却时间'**
  String get cooldownTime;

  /// No description provided for @cooldownTimeSub.
  ///
  /// In zh, this message translates to:
  /// **'同类型通知的最小间隔'**
  String get cooldownTimeSub;

  /// No description provided for @reRemindInterval.
  ///
  /// In zh, this message translates to:
  /// **'重复提醒间隔'**
  String get reRemindInterval;

  /// No description provided for @reRemindIntervalSub.
  ///
  /// In zh, this message translates to:
  /// **'首次通知后每隔多久再次提醒'**
  String get reRemindIntervalSub;

  /// No description provided for @maxRemindCount.
  ///
  /// In zh, this message translates to:
  /// **'最大提醒次数'**
  String get maxRemindCount;

  /// No description provided for @maxRemindCountSub.
  ///
  /// In zh, this message translates to:
  /// **'包含首次在内的总提醒次数'**
  String get maxRemindCountSub;

  /// No description provided for @minutes.
  ///
  /// In zh, this message translates to:
  /// **'{count} 分钟'**
  String minutes(Object count);

  /// No description provided for @times.
  ///
  /// In zh, this message translates to:
  /// **'{count} 次'**
  String times(Object count);

  /// No description provided for @attendanceApp.
  ///
  /// In zh, this message translates to:
  /// **'打卡应用'**
  String get attendanceApp;

  /// No description provided for @workDays.
  ///
  /// In zh, this message translates to:
  /// **'工作日'**
  String get workDays;

  /// No description provided for @monToFri.
  ///
  /// In zh, this message translates to:
  /// **'周一至周五'**
  String get monToFri;

  /// No description provided for @monToSat.
  ///
  /// In zh, this message translates to:
  /// **'周一至周六'**
  String get monToSat;

  /// No description provided for @silentPeriod.
  ///
  /// In zh, this message translates to:
  /// **'静默时段'**
  String get silentPeriod;

  /// No description provided for @addSilentPeriod.
  ///
  /// In zh, this message translates to:
  /// **'添加静默时段'**
  String get addSilentPeriod;

  /// No description provided for @silentStartHelp.
  ///
  /// In zh, this message translates to:
  /// **'选择静默开始时间'**
  String get silentStartHelp;

  /// No description provided for @silentEndHelp.
  ///
  /// In zh, this message translates to:
  /// **'选择静默结束时间'**
  String get silentEndHelp;

  /// No description provided for @appearance.
  ///
  /// In zh, this message translates to:
  /// **'外观'**
  String get appearance;

  /// No description provided for @themeMode.
  ///
  /// In zh, this message translates to:
  /// **'主题模式'**
  String get themeMode;

  /// No description provided for @themeAuto.
  ///
  /// In zh, this message translates to:
  /// **'自动'**
  String get themeAuto;

  /// No description provided for @themeLight.
  ///
  /// In zh, this message translates to:
  /// **'浅色'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In zh, this message translates to:
  /// **'深色'**
  String get themeDark;

  /// No description provided for @hapticFeedback.
  ///
  /// In zh, this message translates to:
  /// **'震动反馈'**
  String get hapticFeedback;

  /// No description provided for @hapticFeedbackSub.
  ///
  /// In zh, this message translates to:
  /// **'收到提醒时触发震动'**
  String get hapticFeedbackSub;

  /// No description provided for @notificationSound.
  ///
  /// In zh, this message translates to:
  /// **'提示音'**
  String get notificationSound;

  /// No description provided for @soundDefault.
  ///
  /// In zh, this message translates to:
  /// **'默认'**
  String get soundDefault;

  /// No description provided for @soundGentle.
  ///
  /// In zh, this message translates to:
  /// **'轻柔'**
  String get soundGentle;

  /// No description provided for @soundUrgent.
  ///
  /// In zh, this message translates to:
  /// **'紧急'**
  String get soundUrgent;

  /// No description provided for @soundSilent.
  ///
  /// In zh, this message translates to:
  /// **'静音'**
  String get soundSilent;

  /// No description provided for @keepAliveGuide.
  ///
  /// In zh, this message translates to:
  /// **'后台保活指南'**
  String get keepAliveGuide;

  /// No description provided for @keepAliveGuideSub.
  ///
  /// In zh, this message translates to:
  /// **'确保应用在后台正常运行'**
  String get keepAliveGuideSub;

  /// No description provided for @onboardingWelcome.
  ///
  /// In zh, this message translates to:
  /// **'打卡提醒'**
  String get onboardingWelcome;

  /// No description provided for @onboardingWelcomeSub.
  ///
  /// In zh, this message translates to:
  /// **'基于地理围栏的智能打卡提醒\n到达或离开公司时自动提醒您打卡'**
  String get onboardingWelcomeSub;

  /// No description provided for @setupLocation.
  ///
  /// In zh, this message translates to:
  /// **'设置公司位置'**
  String get setupLocation;

  /// No description provided for @setupLocationSub.
  ///
  /// In zh, this message translates to:
  /// **'在地图上选择您的公司位置\n并设置围栏半径'**
  String get setupLocationSub;

  /// No description provided for @selectLocation.
  ///
  /// In zh, this message translates to:
  /// **'选择位置'**
  String get selectLocation;

  /// No description provided for @selectApp.
  ///
  /// In zh, this message translates to:
  /// **'选择打卡应用'**
  String get selectApp;

  /// No description provided for @selectAppSub.
  ///
  /// In zh, this message translates to:
  /// **'收到提醒后将一键跳转到该应用'**
  String get selectAppSub;

  /// No description provided for @permissionAuth.
  ///
  /// In zh, this message translates to:
  /// **'权限授权'**
  String get permissionAuth;

  /// No description provided for @permissionAuthSub.
  ///
  /// In zh, this message translates to:
  /// **'需要以下权限才能正常工作：'**
  String get permissionAuthSub;

  /// No description provided for @locationPermission.
  ///
  /// In zh, this message translates to:
  /// **'位置权限（始终允许）'**
  String get locationPermission;

  /// No description provided for @notificationPermission.
  ///
  /// In zh, this message translates to:
  /// **'通知权限'**
  String get notificationPermission;

  /// No description provided for @grantPermission.
  ///
  /// In zh, this message translates to:
  /// **'授予权限'**
  String get grantPermission;

  /// No description provided for @requesting.
  ///
  /// In zh, this message translates to:
  /// **'正在请求...'**
  String get requesting;

  /// No description provided for @goToSettings.
  ///
  /// In zh, this message translates to:
  /// **'前往系统设置'**
  String get goToSettings;

  /// No description provided for @nextStep.
  ///
  /// In zh, this message translates to:
  /// **'下一步'**
  String get nextStep;

  /// No description provided for @getStarted.
  ///
  /// In zh, this message translates to:
  /// **'开始使用'**
  String get getStarted;

  /// No description provided for @editLocation.
  ///
  /// In zh, this message translates to:
  /// **'编辑位置'**
  String get editLocation;

  /// No description provided for @locationName.
  ///
  /// In zh, this message translates to:
  /// **'名称'**
  String get locationName;

  /// No description provided for @locationNameHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：总部大楼'**
  String get locationNameHint;

  /// No description provided for @useCurrentLocation.
  ///
  /// In zh, this message translates to:
  /// **'使用当前位置'**
  String get useCurrentLocation;

  /// No description provided for @gettingLocation.
  ///
  /// In zh, this message translates to:
  /// **'正在获取位置...'**
  String get gettingLocation;

  /// No description provided for @manualInput.
  ///
  /// In zh, this message translates to:
  /// **'手动输入坐标'**
  String get manualInput;

  /// No description provided for @latitude.
  ///
  /// In zh, this message translates to:
  /// **'纬度'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In zh, this message translates to:
  /// **'经度'**
  String get longitude;

  /// No description provided for @fenceRadius.
  ///
  /// In zh, this message translates to:
  /// **'围栏半径'**
  String get fenceRadius;

  /// No description provided for @wifiAssist.
  ///
  /// In zh, this message translates to:
  /// **'Wi-Fi 辅助定位'**
  String get wifiAssist;

  /// No description provided for @bindCurrentWifi.
  ///
  /// In zh, this message translates to:
  /// **'绑定当前 Wi-Fi'**
  String get bindCurrentWifi;

  /// No description provided for @noWifiDetected.
  ///
  /// In zh, this message translates to:
  /// **'未检测到 Wi-Fi 连接'**
  String get noWifiDetected;

  /// No description provided for @wifiAlreadyBound.
  ///
  /// In zh, this message translates to:
  /// **'已绑定该 Wi-Fi: {ssid}'**
  String wifiAlreadyBound(Object ssid);

  /// No description provided for @locationType.
  ///
  /// In zh, this message translates to:
  /// **'位置类型'**
  String get locationType;

  /// No description provided for @saveLocation.
  ///
  /// In zh, this message translates to:
  /// **'保存位置'**
  String get saveLocation;

  /// No description provided for @locationSaved.
  ///
  /// In zh, this message translates to:
  /// **'位置已保存'**
  String get locationSaved;

  /// No description provided for @locationUpdated.
  ///
  /// In zh, this message translates to:
  /// **'位置已更新'**
  String get locationUpdated;

  /// No description provided for @noLocationSet.
  ///
  /// In zh, this message translates to:
  /// **'尚未设置公司位置'**
  String get noLocationSet;

  /// No description provided for @monitoringCount.
  ///
  /// In zh, this message translates to:
  /// **'监控中: {count} 个位置'**
  String monitoringCount(Object count);

  /// No description provided for @addLocationHint.
  ///
  /// In zh, this message translates to:
  /// **'请先添加公司位置'**
  String get addLocationHint;

  /// No description provided for @recordsTitle.
  ///
  /// In zh, this message translates to:
  /// **'打卡记录'**
  String get recordsTitle;

  /// No description provided for @enterRangeRecord.
  ///
  /// In zh, this message translates to:
  /// **'进入公司范围'**
  String get enterRangeRecord;

  /// No description provided for @exitRangeRecord.
  ///
  /// In zh, this message translates to:
  /// **'离开公司范围'**
  String get exitRangeRecord;

  /// No description provided for @fenceRadiusValue.
  ///
  /// In zh, this message translates to:
  /// **'围栏半径：{meters}m'**
  String fenceRadiusValue(Object meters);

  /// No description provided for @radiusLabel.
  ///
  /// In zh, this message translates to:
  /// **'半径: {meters}m'**
  String radiusLabel(Object meters);

  /// No description provided for @dayMon.
  ///
  /// In zh, this message translates to:
  /// **'一'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In zh, this message translates to:
  /// **'二'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In zh, this message translates to:
  /// **'三'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In zh, this message translates to:
  /// **'四'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In zh, this message translates to:
  /// **'五'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In zh, this message translates to:
  /// **'六'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In zh, this message translates to:
  /// **'日'**
  String get daySun;

  /// No description provided for @locationPermRequired.
  ///
  /// In zh, this message translates to:
  /// **'需要位置权限'**
  String get locationPermRequired;

  /// No description provided for @locationPermDesc.
  ///
  /// In zh, this message translates to:
  /// **'获取当前位置需要位置权限。\n\n您可以前往系统设置授予权限，或使用手动输入坐标功能。'**
  String get locationPermDesc;

  /// No description provided for @goToSettingsShort.
  ///
  /// In zh, this message translates to:
  /// **'前往设置'**
  String get goToSettingsShort;

  /// No description provided for @invalidCoordinates.
  ///
  /// In zh, this message translates to:
  /// **'请输入有效的坐标'**
  String get invalidCoordinates;

  /// No description provided for @enterName.
  ///
  /// In zh, this message translates to:
  /// **'请输入名称'**
  String get enterName;

  /// No description provided for @enterLatitude.
  ///
  /// In zh, this message translates to:
  /// **'请输入纬度'**
  String get enterLatitude;

  /// No description provided for @enterLongitude.
  ///
  /// In zh, this message translates to:
  /// **'请输入经度'**
  String get enterLongitude;

  /// No description provided for @latitudeRange.
  ///
  /// In zh, this message translates to:
  /// **'纬度范围 -90 ~ 90'**
  String get latitudeRange;

  /// No description provided for @longitudeRange.
  ///
  /// In zh, this message translates to:
  /// **'经度范围 -180 ~ 180'**
  String get longitudeRange;

  /// No description provided for @getLocationFailed.
  ///
  /// In zh, this message translates to:
  /// **'获取位置失败：{error}'**
  String getLocationFailed(Object error);

  /// No description provided for @noActiveLocations.
  ///
  /// In zh, this message translates to:
  /// **'没有活跃的位置'**
  String get noActiveLocations;

  /// No description provided for @simulateEnter.
  ///
  /// In zh, this message translates to:
  /// **'模拟进入'**
  String get simulateEnter;

  /// No description provided for @simulateExit.
  ///
  /// In zh, this message translates to:
  /// **'模拟离开'**
  String get simulateExit;

  /// No description provided for @simulatedEnter.
  ///
  /// In zh, this message translates to:
  /// **'已模拟进入: {name}'**
  String simulatedEnter(Object name);

  /// No description provided for @simulatedExit.
  ///
  /// In zh, this message translates to:
  /// **'已模拟离开: {name}'**
  String simulatedExit(Object name);

  /// No description provided for @debugTools.
  ///
  /// In zh, this message translates to:
  /// **'调试工具'**
  String get debugTools;

  /// No description provided for @geofenceStatus.
  ///
  /// In zh, this message translates to:
  /// **'围栏状态'**
  String get geofenceStatus;

  /// No description provided for @monitorStatus.
  ///
  /// In zh, this message translates to:
  /// **'监控状态'**
  String get monitorStatus;

  /// No description provided for @lastEnter.
  ///
  /// In zh, this message translates to:
  /// **'上次进入'**
  String get lastEnter;

  /// No description provided for @lastExit.
  ///
  /// In zh, this message translates to:
  /// **'上次离开'**
  String get lastExit;

  /// No description provided for @notMonitored.
  ///
  /// In zh, this message translates to:
  /// **'未监控'**
  String get notMonitored;

  /// No description provided for @keepAliveWhyTitle.
  ///
  /// In zh, this message translates to:
  /// **'为什么需要后台保活？'**
  String get keepAliveWhyTitle;

  /// No description provided for @keepAliveWhyDesc.
  ///
  /// In zh, this message translates to:
  /// **'打卡提醒需要在后台持续监测您的位置变化。部分手机系统会限制后台应用运行，请按照以下步骤设置以确保正常工作。'**
  String get keepAliveWhyDesc;

  /// No description provided for @resetOnboarding.
  ///
  /// In zh, this message translates to:
  /// **'重置引导页'**
  String get resetOnboarding;

  /// No description provided for @resetOnboardingDone.
  ///
  /// In zh, this message translates to:
  /// **'已重置引导页'**
  String get resetOnboardingDone;

  /// No description provided for @keepAliveAndroidStep1Title.
  ///
  /// In zh, this message translates to:
  /// **'关闭电池优化'**
  String get keepAliveAndroidStep1Title;

  /// No description provided for @keepAliveAndroidStep1Desc.
  ///
  /// In zh, this message translates to:
  /// **'设置 → 电池 → 更多电池设置 → 关闭「打卡提醒」的电池优化'**
  String get keepAliveAndroidStep1Desc;

  /// No description provided for @keepAliveAndroidStep2Title.
  ///
  /// In zh, this message translates to:
  /// **'允许自启动'**
  String get keepAliveAndroidStep2Title;

  /// No description provided for @keepAliveAndroidStep2Desc.
  ///
  /// In zh, this message translates to:
  /// **'设置 → 应用管理 → 打卡提醒 → 权限 → 开启自启动'**
  String get keepAliveAndroidStep2Desc;

  /// No description provided for @keepAliveAndroidStep3Title.
  ///
  /// In zh, this message translates to:
  /// **'锁定后台'**
  String get keepAliveAndroidStep3Title;

  /// No description provided for @keepAliveAndroidStep3Desc.
  ///
  /// In zh, this message translates to:
  /// **'在最近任务中下滑锁定「打卡提醒」，防止被系统清理'**
  String get keepAliveAndroidStep3Desc;

  /// No description provided for @keepAliveiOSStep1Title.
  ///
  /// In zh, this message translates to:
  /// **'允许后台刷新'**
  String get keepAliveiOSStep1Title;

  /// No description provided for @keepAliveiOSStep1Desc.
  ///
  /// In zh, this message translates to:
  /// **'设置 → 通用 → 后台App刷新 → 开启「打卡提醒」'**
  String get keepAliveiOSStep1Desc;

  /// No description provided for @keepAliveiOSStep2Title.
  ///
  /// In zh, this message translates to:
  /// **'保持位置权限为「始终」'**
  String get keepAliveiOSStep2Title;

  /// No description provided for @keepAliveiOSStep2Desc.
  ///
  /// In zh, this message translates to:
  /// **'设置 → 隐私与安全性 → 定位服务 → 打卡提醒 → 始终'**
  String get keepAliveiOSStep2Desc;

  /// No description provided for @locationNameHintWork.
  ///
  /// In zh, this message translates to:
  /// **'例如：总部大楼'**
  String get locationNameHintWork;

  /// No description provided for @locationNameHintSchool.
  ///
  /// In zh, this message translates to:
  /// **'例如：北京大学'**
  String get locationNameHintSchool;

  /// No description provided for @locationNameHintGym.
  ///
  /// In zh, this message translates to:
  /// **'例如：健身工厂'**
  String get locationNameHintGym;

  /// No description provided for @locationNameHintCustom.
  ///
  /// In zh, this message translates to:
  /// **'例如：咖啡馆'**
  String get locationNameHintCustom;

  /// No description provided for @manageLocationTypes.
  ///
  /// In zh, this message translates to:
  /// **'管理位置类型'**
  String get manageLocationTypes;

  /// No description provided for @locationTypesTitle.
  ///
  /// In zh, this message translates to:
  /// **'位置类型'**
  String get locationTypesTitle;

  /// No description provided for @addLocationType.
  ///
  /// In zh, this message translates to:
  /// **'添加位置类型'**
  String get addLocationType;

  /// No description provided for @editLocationType.
  ///
  /// In zh, this message translates to:
  /// **'编辑位置类型'**
  String get editLocationType;

  /// No description provided for @typeLabel.
  ///
  /// In zh, this message translates to:
  /// **'类型名称'**
  String get typeLabel;

  /// No description provided for @typeLabelHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：医院'**
  String get typeLabelHint;

  /// No description provided for @enterText.
  ///
  /// In zh, this message translates to:
  /// **'进入提示文案'**
  String get enterText;

  /// No description provided for @enterTextHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：到达医院'**
  String get enterTextHint;

  /// No description provided for @exitText.
  ///
  /// In zh, this message translates to:
  /// **'离开提示文案'**
  String get exitText;

  /// No description provided for @exitTextHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：离开医院'**
  String get exitTextHint;

  /// No description provided for @cannotDeleteBuiltin.
  ///
  /// In zh, this message translates to:
  /// **'内置类型不可删除'**
  String get cannotDeleteBuiltin;

  /// No description provided for @typeInUse.
  ///
  /// In zh, this message translates to:
  /// **'该类型正在被 {count} 个位置使用，无法删除'**
  String typeInUse(Object count);

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @labelRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入名称'**
  String get labelRequired;

  /// No description provided for @enterTextRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入进入提示'**
  String get enterTextRequired;

  /// No description provided for @exitTextRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入离开提示'**
  String get exitTextRequired;

  /// No description provided for @mapPicker.
  ///
  /// In zh, this message translates to:
  /// **'地图选点'**
  String get mapPicker;

  /// No description provided for @mapPickerTitle.
  ///
  /// In zh, this message translates to:
  /// **'选择位置'**
  String get mapPickerTitle;

  /// No description provided for @confirmLocation.
  ///
  /// In zh, this message translates to:
  /// **'确认此位置'**
  String get confirmLocation;

  /// No description provided for @tapToSelectLocation.
  ///
  /// In zh, this message translates to:
  /// **'点击地图选择位置'**
  String get tapToSelectLocation;

  /// No description provided for @manageAttendanceApps.
  ///
  /// In zh, this message translates to:
  /// **'管理打卡应用'**
  String get manageAttendanceApps;

  /// No description provided for @attendanceAppsTitle.
  ///
  /// In zh, this message translates to:
  /// **'打卡应用'**
  String get attendanceAppsTitle;

  /// No description provided for @addAttendanceApp.
  ///
  /// In zh, this message translates to:
  /// **'添加打卡应用'**
  String get addAttendanceApp;

  /// No description provided for @editAttendanceApp.
  ///
  /// In zh, this message translates to:
  /// **'编辑打卡应用'**
  String get editAttendanceApp;

  /// No description provided for @appName.
  ///
  /// In zh, this message translates to:
  /// **'应用名称'**
  String get appName;

  /// No description provided for @appNameHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：考勤助手'**
  String get appNameHint;

  /// No description provided for @urlScheme.
  ///
  /// In zh, this message translates to:
  /// **'URL Scheme'**
  String get urlScheme;

  /// No description provided for @urlSchemeHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：myapp://'**
  String get urlSchemeHint;

  /// No description provided for @cannotDeleteBuiltinApp.
  ///
  /// In zh, this message translates to:
  /// **'内置应用不可删除'**
  String get cannotDeleteBuiltinApp;

  /// No description provided for @appNameRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入应用名称'**
  String get appNameRequired;

  /// No description provided for @urlSchemeRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入 URL Scheme'**
  String get urlSchemeRequired;

  /// No description provided for @permissionStatusTitle.
  ///
  /// In zh, this message translates to:
  /// **'权限状态'**
  String get permissionStatusTitle;

  /// No description provided for @permLocation.
  ///
  /// In zh, this message translates to:
  /// **'位置权限'**
  String get permLocation;

  /// No description provided for @permLocationWhenInUse.
  ///
  /// In zh, this message translates to:
  /// **'使用时定位'**
  String get permLocationWhenInUse;

  /// No description provided for @permLocationAlways.
  ///
  /// In zh, this message translates to:
  /// **'始终定位'**
  String get permLocationAlways;

  /// No description provided for @permNotification.
  ///
  /// In zh, this message translates to:
  /// **'通知权限'**
  String get permNotification;

  /// No description provided for @permGranted.
  ///
  /// In zh, this message translates to:
  /// **'已授权'**
  String get permGranted;

  /// No description provided for @permDenied.
  ///
  /// In zh, this message translates to:
  /// **'已拒绝'**
  String get permDenied;

  /// No description provided for @permNotRequested.
  ///
  /// In zh, this message translates to:
  /// **'未请求'**
  String get permNotRequested;

  /// No description provided for @permLocationGrantedAlways.
  ///
  /// In zh, this message translates to:
  /// **'始终允许'**
  String get permLocationGrantedAlways;

  /// No description provided for @permLocationGrantedWhenInUse.
  ///
  /// In zh, this message translates to:
  /// **'仅使用时允许'**
  String get permLocationGrantedWhenInUse;

  /// No description provided for @openSystemSettings.
  ///
  /// In zh, this message translates to:
  /// **'打开系统设置'**
  String get openSystemSettings;

  /// No description provided for @refreshPermissions.
  ///
  /// In zh, this message translates to:
  /// **'刷新状态'**
  String get refreshPermissions;

  /// No description provided for @permLocationHelpiOS.
  ///
  /// In zh, this message translates to:
  /// **'请前往 系统设置 → 打卡提醒 → 位置 → 选择「始终」'**
  String get permLocationHelpiOS;

  /// No description provided for @permLocationHelpAndroid.
  ///
  /// In zh, this message translates to:
  /// **'请前往 系统设置 → 应用 → 打卡提醒 → 权限 → 位置 → 选择「始终允许」'**
  String get permLocationHelpAndroid;

  /// No description provided for @permNotificationHelpiOS.
  ///
  /// In zh, this message translates to:
  /// **'请前往 系统设置 → 打卡提醒 → 通知 → 开启「允许通知」'**
  String get permNotificationHelpiOS;

  /// No description provided for @permNotificationHelpAndroid.
  ///
  /// In zh, this message translates to:
  /// **'请前往 系统设置 → 应用 → 打卡提醒 → 通知 → 开启通知'**
  String get permNotificationHelpAndroid;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
