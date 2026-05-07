import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // General
      'app_name': 'CureConnect',
      'welcome': 'Welcome',
      'settings': 'Settings',
      'save': 'Save',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'delete': 'Delete',
      'edit': 'Edit',
      'add': 'Add',
      'search': 'Search',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'warning': 'Warning',
      
      // Navigation
      'home': 'Home',
      'schedule': 'Schedule',
      'device': 'Device',
      'reports': 'Reports',
      'pharmacy': 'Pharmacy',
      'drawers': 'Drawers',
      'emergency': 'Emergency',
      'profile': 'Profile',
      
      // Dashboard
      'good_morning': 'Good Morning',
      'good_afternoon': 'Good Afternoon',
      'good_evening': 'Good Evening',
      'esp32_connected': 'ESP32 Connected',
      'esp32_disconnected': 'ESP32 Disconnected',
      'heart_rate': 'Heart Rate',
      'body_temp': 'Body Temperature',
      'bpm': 'bpm',
      'sos_emergency': 'SOS Emergency',
      'press_hold_sos': 'Press and hold for emergency',
      'daily_summary': 'Daily Summary',
      'doses_taken': 'Doses Taken',
      'next_dose': 'Next Dose',
      'streak': 'Streak',
      
      // Pharmacy Locator
      'pharmacy_locator': 'Smart Pharmacy Locator',
      'nearby_pharmacies': 'Nearby Pharmacies',
      'refresh_location': 'Refresh Location',
      'location_permission': 'Location Permission Required',
      'location_permission_desc': 'Allow access to find pharmacies near you',
      'allow_location': 'Allow Location',
      'open_now': 'Open Now',
      'closed': 'Closed',
      'get_directions': 'Get Directions',
      'call': 'Call',
      'distance': 'Distance',
      'rating': 'Rating',
      
      // Drawer Management
      'drawer_management': 'Smart Drawer Management',
      'drawer': 'Drawer',
      'drawer_settings': 'Drawer Settings',
      'medicine_name': 'Medicine Name',
      'set_alarm': 'Set Alarm',
      'alarm_time': 'Alarm Time',
      'pill_count': 'Pill Count',
      'pills_remaining': 'pills remaining',
      'voice_reminder': 'Voice Reminder',
      'upload_voice': 'Upload Voice Sample',
      'text_to_speech': 'Text to Speech',
      'enter_reminder_text': 'Enter reminder text...',
      'generate_voice': 'Generate Voice',
      'hardware_sync': 'Hardware Sync',
      'wifi_status': 'WiFi Status',
      'esp32_status': 'ESP32 Status',
      'connected': 'Connected',
      'disconnected': 'Disconnected',
      'ir_sensor': 'IR Sensor',
      'dose_logged': 'Dose Logged',
      'confirm_dose': 'Confirm Dose',
      'mark_as_taken': 'Mark as Taken',
      
      // Emergency Hub
      'emergency_hub': 'Smart Emergency Hub',
      'emergency_guardian': 'Emergency Guardian',
      'select_guardian': 'Select Emergency Contact',
      'guardian_name': 'Guardian Name',
      'guardian_phone': 'Phone Number',
      'guardian_relation': 'Relationship',
      'automated_alerts': 'Automated Alerts',
      'alert_settings': 'Alert Settings',
      'hardware_error_alert': 'Hardware Error Alert',
      'missed_dose_alert': 'Missed Dose Alert',
      'low_inventory_alert': 'Low Inventory Alert',
      'test_alert': 'Test Alert',
      'send_test_alert': 'Send Test Alert',
      'alert_sent': 'Alert Sent Successfully',
      'contact_permissions': 'Contact Permissions Required',
      'contact_permissions_desc': 'Allow access to select emergency contacts',
      'allow_contacts': 'Allow Contacts',
      
      // Theme & Language
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'language': 'Language',
      'english': 'English',
      'arabic': 'Arabic',
    },
    'ar': {
      // General
      'app_name': 'كيور كونكت',
      'welcome': 'مرحباً',
      'settings': 'الإعدادات',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'confirm': 'تأكيد',
      'delete': 'حذف',
      'edit': 'تعديل',
      'add': 'إضافة',
      'search': 'بحث',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'success': 'نجاح',
      'warning': 'تحذير',
      
      // Navigation
      'home': 'الرئيسية',
      'schedule': 'الجدول',
      'device': 'الجهاز',
      'reports': 'التقارير',
      'pharmacy': 'الصيدلية',
      'drawers': 'الأدراج',
      'emergency': 'الطوارئ',
      'profile': 'الملف الشخصي',
      
      // Dashboard
      'good_morning': 'صباح الخير',
      'good_afternoon': 'مساء الخير',
      'good_evening': 'مساء الخير',
      'esp32_connected': 'ESP32 متصل',
      'esp32_disconnected': 'ESP32 غير متصل',
      'heart_rate': 'معدل ضربات القلب',
      'body_temp': 'درجة حرارة الجسم',
      'bpm': 'نبضة/د',
      'sos_emergency': 'طوارئ SOS',
      'press_hold_sos': 'اضغط مع الاستمرار للطوارئ',
      'daily_summary': 'ملخص اليوم',
      'doses_taken': 'الجرعات المأخوذة',
      'next_dose': 'الجرعة التالية',
      'streak': 'التسلسل',
      
      // Pharmacy Locator
      'pharmacy_locator': 'محدد الصيدليات الذكي',
      'nearby_pharmacies': 'الصيدليات القريبة',
      'refresh_location': 'تحديث الموقع',
      'location_permission': 'مطلوب إذن الموقع',
      'location_permission_desc': 'اسمح بالوصول للعثور على الصيدليات القريبة منك',
      'allow_location': 'السماح بالموقع',
      'open_now': 'مفتوح الآن',
      'closed': 'مغلق',
      'get_directions': 'احصل على الاتجاهات',
      'call': 'اتصال',
      'distance': 'المسافة',
      'rating': 'التقييم',
      
      // Drawer Management
      'drawer_management': 'إدارة الأدراج الذكية',
      'drawer': 'درج',
      'drawer_settings': 'إعدادات الدرج',
      'medicine_name': 'اسم الدواء',
      'set_alarm': 'ضبط المنبه',
      'alarm_time': 'وقت المنبه',
      'pill_count': 'عدد الحبوب',
      'pills_remaining': 'حبة متبقية',
      'voice_reminder': 'تذكير صوتي',
      'upload_voice': 'رفع عينة صوتية',
      'text_to_speech': 'تحويل النص إلى كلام',
      'enter_reminder_text': 'أدخل نص التذكير...',
      'generate_voice': 'إنشاء الصوت',
      'hardware_sync': 'مزامنة الأجهزة',
      'wifi_status': 'حالة الواي فاي',
      'esp32_status': 'حالة ESP32',
      'connected': 'متصل',
      'disconnected': 'غير متصل',
      'ir_sensor': 'مستشعر الأشعة تحت الحمراء',
      'dose_logged': 'تم تسجيل الجرعة',
      'confirm_dose': 'تأكيد الجرعة',
      'mark_as_taken': 'تحديد كمأخوذ',
      
      // Emergency Hub
      'emergency_hub': 'مركز الطوارئ الذكي',
      'emergency_guardian': 'وصي الطوارئ',
      'select_guardian': 'اختر جهة اتصال الطوارئ',
      'guardian_name': 'اسم الوصي',
      'guardian_phone': 'رقم الهاتف',
      'guardian_relation': 'العلاقة',
      'automated_alerts': 'التنبيهات التلقائية',
      'alert_settings': 'إعدادات التنبيه',
      'hardware_error_alert': 'تنبيه خطأ الأجهزة',
      'missed_dose_alert': 'تنبيه الجرعة الفائتة',
      'low_inventory_alert': 'تنبيه انخفاض المخزون',
      'test_alert': 'تنبيه تجريبي',
      'send_test_alert': 'إرسال تنبيه تجريبي',
      'alert_sent': 'تم إرسال التنبيه بنجاح',
      'contact_permissions': 'مطلوب إذن جهات الاتصال',
      'contact_permissions_desc': 'اسمح بالوصول لاختيار جهات اتصال الطوارئ',
      'allow_contacts': 'السماح بجهات الاتصال',
      
      // Theme & Language
      'dark_mode': 'الوضع الداكن',
      'light_mode': 'الوضع الفاتح',
      'language': 'اللغة',
      'english': 'الإنجليزية',
      'arabic': 'العربية',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? 
           _localizedValues['en']?[key] ?? 
           key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
