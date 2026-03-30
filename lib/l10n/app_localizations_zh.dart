// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '打卡提醒';

  @override
  String get home => '首页';

  @override
  String get records => '记录';

  @override
  String get statistics => '统计';

  @override
  String get settings => '设置';

  @override
  String get statusUnknown => '未知';

  @override
  String get statusInside => '在范围内';

  @override
  String get statusOutside => '在范围外';

  @override
  String get monitoring => '监控中';

  @override
  String get notMonitoring => '未启动';

  @override
  String get todayRecords => '今日记录';

  @override
  String get noRecordsToday => '今天还没有打卡记录';

  @override
  String get enterRange => '进入范围';

  @override
  String get exitRange => '离开范围';

  @override
  String get punched => '已打卡';

  @override
  String get noRecordsOnDate => '该日无打卡记录';

  @override
  String get weekView => '周';

  @override
  String get monthView => '月';

  @override
  String get weekArrival => '本周到达时间';

  @override
  String get monthArrival => '本月到达时间';

  @override
  String get lateThresholdHint => '9:30 以后到达标记为迟到';

  @override
  String get noData => '暂无数据';

  @override
  String get attendanceDays => '出勤天数';

  @override
  String get avgArrival => '平均到达';

  @override
  String get lateDays => '迟到';

  @override
  String get forgotPunch => '忘打卡';

  @override
  String get detail => '明细';

  @override
  String get settingsTitle => '设置';

  @override
  String get companyLocation => '公司位置';

  @override
  String get addLocation => '添加位置';

  @override
  String get addLocationSubtitle => '设置新的位置和围栏';

  @override
  String get deleteLocation => '删除位置';

  @override
  String deleteLocationConfirm(Object name) {
    return '确定要删除「$name」吗？';
  }

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get notificationSettings => '通知设置';

  @override
  String get notifyOnEnter => '进入时提醒';

  @override
  String get notifyOnEnterSub => '到达范围时推送通知';

  @override
  String get notifyOnExit => '离开时提醒';

  @override
  String get notifyOnExitSub => '离开范围时推送通知';

  @override
  String get cooldownTime => '通知冷却时间';

  @override
  String get cooldownTimeSub => '同类型通知的最小间隔';

  @override
  String get reRemindInterval => '重复提醒间隔';

  @override
  String get reRemindIntervalSub => '首次通知后每隔多久再次提醒';

  @override
  String get maxRemindCount => '最大提醒次数';

  @override
  String get maxRemindCountSub => '包含首次在内的总提醒次数';

  @override
  String minutes(Object count) {
    return '$count 分钟';
  }

  @override
  String times(Object count) {
    return '$count 次';
  }

  @override
  String get attendanceApp => '打卡应用';

  @override
  String get workDays => '工作日';

  @override
  String get monToFri => '周一至周五';

  @override
  String get monToSat => '周一至周六';

  @override
  String get silentPeriod => '静默时段';

  @override
  String get addSilentPeriod => '添加静默时段';

  @override
  String get silentStartHelp => '选择静默开始时间';

  @override
  String get silentEndHelp => '选择静默结束时间';

  @override
  String get appearance => '外观';

  @override
  String get themeMode => '主题模式';

  @override
  String get themeAuto => '自动';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get hapticFeedback => '震动反馈';

  @override
  String get hapticFeedbackSub => '收到提醒时触发震动';

  @override
  String get notificationSound => '提示音';

  @override
  String get soundDefault => '默认';

  @override
  String get soundGentle => '轻柔';

  @override
  String get soundUrgent => '紧急';

  @override
  String get soundSilent => '静音';

  @override
  String get keepAliveGuide => '后台保活指南';

  @override
  String get keepAliveGuideSub => '确保应用在后台正常运行';

  @override
  String get onboardingWelcome => '打卡提醒';

  @override
  String get onboardingWelcomeSub => '基于地理围栏的智能打卡提醒\n到达或离开公司时自动提醒您打卡';

  @override
  String get setupLocation => '设置公司位置';

  @override
  String get setupLocationSub => '在地图上选择您的公司位置\n并设置围栏半径';

  @override
  String get selectLocation => '选择位置';

  @override
  String get selectApp => '选择打卡应用';

  @override
  String get selectAppSub => '收到提醒后将一键跳转到该应用';

  @override
  String get permissionAuth => '权限授权';

  @override
  String get permissionAuthSub => '需要以下权限才能正常工作：';

  @override
  String get locationPermission => '位置权限（始终允许）';

  @override
  String get notificationPermission => '通知权限';

  @override
  String get grantPermission => '授予权限';

  @override
  String get requesting => '正在请求...';

  @override
  String get goToSettings => '前往系统设置';

  @override
  String get nextStep => '下一步';

  @override
  String get getStarted => '开始使用';

  @override
  String get editLocation => '编辑位置';

  @override
  String get locationName => '名称';

  @override
  String get locationNameHint => '例如：总部大楼';

  @override
  String get useCurrentLocation => '使用当前位置';

  @override
  String get gettingLocation => '正在获取位置...';

  @override
  String get manualInput => '手动输入坐标';

  @override
  String get latitude => '纬度';

  @override
  String get longitude => '经度';

  @override
  String get fenceRadius => '围栏半径';

  @override
  String get wifiAssist => 'Wi-Fi 辅助定位';

  @override
  String get bindCurrentWifi => '绑定当前 Wi-Fi';

  @override
  String get noWifiDetected => '未检测到 Wi-Fi 连接';

  @override
  String wifiAlreadyBound(Object ssid) {
    return '已绑定该 Wi-Fi: $ssid';
  }

  @override
  String get locationType => '位置类型';

  @override
  String get saveLocation => '保存位置';

  @override
  String get locationSaved => '位置已保存';

  @override
  String get locationUpdated => '位置已更新';

  @override
  String get noLocationSet => '尚未设置公司位置';

  @override
  String monitoringCount(Object count) {
    return '监控中: $count 个位置';
  }

  @override
  String get addLocationHint => '请先添加公司位置';

  @override
  String get recordsTitle => '打卡记录';

  @override
  String get enterRangeRecord => '进入公司范围';

  @override
  String get exitRangeRecord => '离开公司范围';

  @override
  String fenceRadiusValue(Object meters) {
    return '围栏半径：${meters}m';
  }

  @override
  String radiusLabel(Object meters) {
    return '半径: ${meters}m';
  }

  @override
  String get dayMon => '一';

  @override
  String get dayTue => '二';

  @override
  String get dayWed => '三';

  @override
  String get dayThu => '四';

  @override
  String get dayFri => '五';

  @override
  String get daySat => '六';

  @override
  String get daySun => '日';

  @override
  String get locationPermRequired => '需要位置权限';

  @override
  String get locationPermDesc => '获取当前位置需要位置权限。\n\n您可以前往系统设置授予权限，或使用手动输入坐标功能。';

  @override
  String get goToSettingsShort => '前往设置';

  @override
  String get invalidCoordinates => '请输入有效的坐标';

  @override
  String get enterName => '请输入名称';

  @override
  String get enterLatitude => '请输入纬度';

  @override
  String get enterLongitude => '请输入经度';

  @override
  String get latitudeRange => '纬度范围 -90 ~ 90';

  @override
  String get longitudeRange => '经度范围 -180 ~ 180';

  @override
  String getLocationFailed(Object error) {
    return '获取位置失败：$error';
  }

  @override
  String get noActiveLocations => '没有活跃的位置';

  @override
  String get simulateEnter => '模拟进入';

  @override
  String get simulateExit => '模拟离开';

  @override
  String simulatedEnter(Object name) {
    return '已模拟进入: $name';
  }

  @override
  String simulatedExit(Object name) {
    return '已模拟离开: $name';
  }

  @override
  String get debugTools => '调试工具';

  @override
  String get geofenceStatus => '围栏状态';

  @override
  String get monitorStatus => '监控状态';

  @override
  String get lastEnter => '上次进入';

  @override
  String get lastExit => '上次离开';

  @override
  String get notMonitored => '未监控';

  @override
  String get keepAliveWhyTitle => '为什么需要后台保活？';

  @override
  String get keepAliveWhyDesc =>
      '打卡提醒需要在后台持续监测您的位置变化。部分手机系统会限制后台应用运行，请按照以下步骤设置以确保正常工作。';

  @override
  String get resetOnboarding => '重置引导页';

  @override
  String get resetOnboardingDone => '已重置引导页';

  @override
  String get keepAliveAndroidStep1Title => '关闭电池优化';

  @override
  String get keepAliveAndroidStep1Desc => '设置 → 电池 → 更多电池设置 → 关闭「打卡提醒」的电池优化';

  @override
  String get keepAliveAndroidStep2Title => '允许自启动';

  @override
  String get keepAliveAndroidStep2Desc => '设置 → 应用管理 → 打卡提醒 → 权限 → 开启自启动';

  @override
  String get keepAliveAndroidStep3Title => '锁定后台';

  @override
  String get keepAliveAndroidStep3Desc => '在最近任务中下滑锁定「打卡提醒」，防止被系统清理';

  @override
  String get keepAliveiOSStep1Title => '允许后台刷新';

  @override
  String get keepAliveiOSStep1Desc => '设置 → 通用 → 后台App刷新 → 开启「打卡提醒」';

  @override
  String get keepAliveiOSStep2Title => '保持位置权限为「始终」';

  @override
  String get keepAliveiOSStep2Desc => '设置 → 隐私与安全性 → 定位服务 → 打卡提醒 → 始终';

  @override
  String get locationNameHintWork => '例如：总部大楼';

  @override
  String get locationNameHintSchool => '例如：北京大学';

  @override
  String get locationNameHintGym => '例如：健身工厂';

  @override
  String get locationNameHintCustom => '例如：咖啡馆';

  @override
  String get manageLocationTypes => '管理位置类型';

  @override
  String get locationTypesTitle => '位置类型';

  @override
  String get addLocationType => '添加位置类型';

  @override
  String get editLocationType => '编辑位置类型';

  @override
  String get typeLabel => '类型名称';

  @override
  String get typeLabelHint => '例如：医院';

  @override
  String get enterText => '进入提示文案';

  @override
  String get enterTextHint => '例如：到达医院';

  @override
  String get exitText => '离开提示文案';

  @override
  String get exitTextHint => '例如：离开医院';

  @override
  String get cannotDeleteBuiltin => '内置类型不可删除';

  @override
  String typeInUse(Object count) {
    return '该类型正在被 $count 个位置使用，无法删除';
  }

  @override
  String get save => '保存';

  @override
  String get labelRequired => '请输入名称';

  @override
  String get enterTextRequired => '请输入进入提示';

  @override
  String get exitTextRequired => '请输入离开提示';

  @override
  String get mapPicker => '地图选点';

  @override
  String get mapPickerTitle => '选择位置';

  @override
  String get confirmLocation => '确认此位置';

  @override
  String get tapToSelectLocation => '点击地图选择位置';

  @override
  String get manageAttendanceApps => '管理打卡应用';

  @override
  String get attendanceAppsTitle => '打卡应用';

  @override
  String get addAttendanceApp => '添加打卡应用';

  @override
  String get editAttendanceApp => '编辑打卡应用';

  @override
  String get appName => '应用名称';

  @override
  String get appNameHint => '例如：考勤助手';

  @override
  String get urlScheme => 'URL Scheme';

  @override
  String get urlSchemeHint => '例如：myapp://';

  @override
  String get cannotDeleteBuiltinApp => '内置应用不可删除';

  @override
  String get appNameRequired => '请输入应用名称';

  @override
  String get urlSchemeRequired => '请输入 URL Scheme';

  @override
  String get permissionStatusTitle => '权限状态';

  @override
  String get permLocation => '位置权限';

  @override
  String get permLocationWhenInUse => '使用时定位';

  @override
  String get permLocationAlways => '始终定位';

  @override
  String get permNotification => '通知权限';

  @override
  String get permGranted => '已授权';

  @override
  String get permDenied => '已拒绝';

  @override
  String get permNotRequested => '未请求';

  @override
  String get permLocationGrantedAlways => '始终允许';

  @override
  String get permLocationGrantedWhenInUse => '仅使用时允许';

  @override
  String get openSystemSettings => '打开系统设置';

  @override
  String get refreshPermissions => '刷新状态';

  @override
  String get permLocationHelpiOS => '请前往 系统设置 → 打卡提醒 → 位置 → 选择「始终」';

  @override
  String get permLocationHelpAndroid =>
      '请前往 系统设置 → 应用 → 打卡提醒 → 权限 → 位置 → 选择「始终允许」';

  @override
  String get permNotificationHelpiOS => '请前往 系统设置 → 打卡提醒 → 通知 → 开启「允许通知」';

  @override
  String get permNotificationHelpAndroid => '请前往 系统设置 → 应用 → 打卡提醒 → 通知 → 开启通知';
}
