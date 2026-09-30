// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get brandName => 'StreakUp';

  @override
  String get brandTagline => 'خطوات صغيرة اليوم من أجل غدٍ أفضل.';

  @override
  String get navToday => 'اليوم';

  @override
  String get navHabits => 'العادات';

  @override
  String get navChallenges => 'التحديات';

  @override
  String get navFriends => 'الأصدقاء';

  @override
  String navSemanticsSelected(String destination) {
    return '$destination، علامة التبويب المحددة';
  }

  @override
  String navSemanticsUnselected(String destination) {
    return 'علامة تبويب $destination';
  }

  @override
  String get actionInbox => 'الوارد';

  @override
  String get actionProfile => 'الملف الشخصي';

  @override
  String get actionReview => 'مراجعة';

  @override
  String get actionBack => 'رجوع';

  @override
  String get actionRetry => 'مراجعة وإعادة المحاولة';

  @override
  String get actionDismiss => 'إغلاق';

  @override
  String get actionAccountRecovery => 'مراجعة الحساب';

  @override
  String get screenInboxTitle => 'الوارد';

  @override
  String get screenInboxPlaceholderBody =>
      'ستتوفر الإشعارات والتحديثات الاجتماعية في شريحة الميزة المخصصة لها.';

  @override
  String get screenProfileTitle => 'الملف الشخصي';

  @override
  String get screenProfilePlaceholderBody =>
      'تتبع إعدادات الحساب وحفظ اللغة للشرائح القادمة.';

  @override
  String get screenSyncRecoveryTitle => 'المزامنة والاسترداد';

  @override
  String get screenSyncRecoveryPlaceholderBody =>
      'تتم هنا مراجعة التغييرات المعلقة وإجراءات استرداد المزامنة.';

  @override
  String hostPlaceholderTitle(String destination) {
    return 'قسم $destination';
  }

  @override
  String hostPlaceholderSubtitle(String sliceCode) {
    return 'مضيف الواجهة جاهز لمحتوى الشريحة $sliceCode.';
  }

  @override
  String get networkOnlineTitle => 'متصل';

  @override
  String get networkOnlineDescription => 'متصل بالخادم وجاهز للمزامنة.';

  @override
  String get networkOfflineTitle => 'أنت غير متصل بالإنترنت';

  @override
  String get networkOfflineDescription =>
      'تم حفظ تغييراتك على هذا الجهاز وستتم مزامنتها عند عودة الاتصال.';

  @override
  String get networkReconnectingTitle => 'جارٍ إعادة الاتصال';

  @override
  String get networkReconnectingDescription =>
      'تتم استعادة الاتصال بالخادم. التغييرات المعلقة محفوظة بأمان على جهازك.';

  @override
  String get networkSyncingTitle => 'جارٍ المزامنة';

  @override
  String get networkSyncingDescription =>
      'تتم الآن مزامنة تغييراتك المحفوظة مع الخادم.';

  @override
  String get networkSyncFailedTitle => 'مشكلة في المزامنة';

  @override
  String networkSyncFailedDescription(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'تعذرت مزامنة $count تغييرات. بياناتك محفوظة بأمان على هذا الجهاز.',
      one: 'تعذرت مزامنة تغيير واحد (1). بياناتك محفوظة بأمان على هذا الجهاز.',
    );
    return '$_temp0';
  }

  @override
  String networkSyncFailedCompactTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تعذرت مزامنة $count تغييرات',
      one: 'تعذرت مزامنة تغيير واحد (1)',
    );
    return '$_temp0';
  }

  @override
  String get networkSyncFailedCompactDescription =>
      'راجع النشاط المتأثر لمعالجة مشكلة المزامنة.';

  @override
  String networkPendingQueueBannerTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تغييرات في انتظار المزامنة',
      one: 'تغيير واحد (1) في انتظار المزامنة',
    );
    return '$_temp0';
  }

  @override
  String get networkPendingQueueBannerDescription =>
      'تم الحفظ على هذا الجهاز وبانتظار تأكيد الخادم.';

  @override
  String get networkAuthRequiredTitle => 'الحساب يتطلب انتباهك';

  @override
  String get networkAuthRequiredDescription =>
      'تحتاج جلستك إلى مراجعة قبل مزامنة التغييرات. بياناتك المحلية محفوظة بأمان.';

  @override
  String get actionStatusPending => 'في انتظار المزامنة';

  @override
  String get actionStatusSavedOffline => 'محفوظ دون اتصال';

  @override
  String get actionStatusSynced => 'تمت المزامنة';

  @override
  String get actionStatusFailed => 'فشلت المزامنة';

  @override
  String get actionLocalCompletedLabel => 'مكتمل محليًا';

  @override
  String actionSemanticsCombined(
    String actionLabel,
    String localStatus,
    String syncStatus,
  ) {
    return '$actionLabel: $localStatus، $syncStatus';
  }

  @override
  String get feedbackKindSuccess => 'نجاح';

  @override
  String get feedbackKindInfo => 'معلومة';

  @override
  String get feedbackKindWarning => 'تنبيه';

  @override
  String get feedbackKindError => 'خطأ';

  @override
  String get feedbackKindOffline => 'حالة عدم الاتصال';

  @override
  String get feedbackKindSync => 'حالة المزامنة';

  @override
  String get feedbackKindActionRequired => 'إجراء مطلوب';

  @override
  String get feedbackLocalSavePending =>
      'تم الحفظ على هذا الجهاز. في انتظار تأكيد الخادم.';

  @override
  String feedbackBackgroundSyncCoalesced(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تحديثات مزامنة في الخلفية',
      one: 'تحديث مزامنة واحد (1) في الخلفية',
    );
    return '$_temp0';
  }

  @override
  String get stateLoadingTitle => 'جارٍ التحميل';

  @override
  String get stateLoadingDescription => 'يتم تحضير المحتوى، يرجى الانتظار...';

  @override
  String get stateEmptyTitle => 'لا يوجد محتوى بعد';

  @override
  String get stateEmptyDescription =>
      'لا توجد عناصر لعرضها في هذا القسم حاليًا.';

  @override
  String get stateErrorTitle => 'تعذر تحميل المحتوى';

  @override
  String get stateErrorDescription =>
      'حدثت مشكلة أثناء تحميل هذا القسم. بياناتك المحلية المحفوظة لم تتأثر.';

  @override
  String get authRestoringTitle => 'جارٍ تجهيز كل شيء';

  @override
  String get authRestoringSubtitle => 'تتم استعادة جلستك بأمان...';

  @override
  String get authSignInTitle => 'مرحبًا بعودتك';

  @override
  String get authSignInSubtitle => 'سجّل الدخول لمتابعة سلاسل عاداتك.';

  @override
  String get authEmailLabel => 'البريد الإلكتروني';

  @override
  String get authEmailHint => 'name@example.com';

  @override
  String get authPasswordLabel => 'كلمة المرور';

  @override
  String get authPasswordHint => 'أدخل كلمة المرور';

  @override
  String get authConfirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get authConfirmPasswordHint => 'أعد إدخال كلمة المرور';

  @override
  String get authShowPasswordTooltip => 'إظهار كلمة المرور';

  @override
  String get authHidePasswordTooltip => 'إخفاء كلمة المرور';

  @override
  String get authSignInButton => 'تسجيل الدخول';

  @override
  String get authForgotPasswordButton => 'هل نسيت كلمة المرور؟';

  @override
  String get authOrDivider => 'أو';

  @override
  String get authNewToStreakUpPrompt => 'جديد في StreakUp؟';

  @override
  String get authCreateAccountLink => 'إنشاء حساب';

  @override
  String get authRegisterTitle => 'أنشئ حسابك';

  @override
  String get authRegisterSubtitle => 'ابدأ ببناء عادات أفضل، سلسلة تلو الأخرى.';

  @override
  String get authCreateAccountButton => 'إنشاء الحساب';

  @override
  String get authAlreadyHaveAccountPrompt => 'لديك حساب بالفعل؟';

  @override
  String get authSignInLink => 'تسجيل الدخول';

  @override
  String get authVerifyEmailTitle => 'تأكيد بريدك الإلكتروني';

  @override
  String get authVerifyEmailSentTo => 'أرسلنا رابط التأكيد إلى';

  @override
  String get authVerifyEmailBody =>
      'يرجى تأكيد بريدك الإلكتروني قبل المتابعة إلى StreakUp.';

  @override
  String get authVerifyEmailPrimaryButton => 'لقد أكدت بريدي الإلكتروني';

  @override
  String get authResendEmailButton => 'إعادة إرسال البريد';

  @override
  String get authBackToSignInButton => 'العودة إلى تسجيل الدخول';

  @override
  String get authVerificationResentBanner =>
      'تم إرسال رابط التأكيد. يرجى التحقق من بريدك الوارد.';

  @override
  String get authPasswordRecoveryTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get authPasswordRecoverySubtitle =>
      'أدخل بريدك الإلكتروني وسنرسل إليك رابطًا لإعادة تعيين كلمة المرور.';

  @override
  String get authSendResetLinkButton => 'إرسال رابط إعادة التعيين';

  @override
  String get authPasswordRecoverySentTitle => 'تحقق من بريدك الإلكتروني';

  @override
  String get authPasswordRecoverySentGenericBody =>
      'إذا كان هناك حساب مرتبط بهذا البريد الإلكتروني، فقد أرسلنا رابطًا لإعادة تعيين كلمة المرور.';

  @override
  String get authPasswordRecoverySentFollowUp =>
      'اتبع التعليمات الواردة في البريد الإلكتروني لإعادة تعيين كلمة المرور.';

  @override
  String get authSendAgainButton => 'إعادة الإرسال';

  @override
  String get authRecoveryResentBanner =>
      'إذا كان هناك حساب مرتبط بهذا البريد الإلكتروني، فقد تم إرسال رابط آخر.';

  @override
  String get authPasswordResetFormTitle => 'إنشاء كلمة مرور جديدة';

  @override
  String get authPasswordResetFormSubtitle =>
      'أدخل كلمة المرور الجديدة وأكدها لتأمين حسابك.';

  @override
  String get authNewPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get authSaveNewPasswordButton => 'تحديث كلمة المرور';

  @override
  String get authSessionExpiredTitle => 'انتهت صلاحية الجلسة';

  @override
  String get authSessionExpiredSubtitle =>
      'حفاظًا على أمانك، يرجى تسجيل الدخول مرة أخرى للمتابعة.';

  @override
  String get authSignInAgainButton => 'تسجيل الدخول مجددًا';

  @override
  String get authSessionDataProtectedNote => 'تظل بيانات حسابك محمية وآمنة.';

  @override
  String get authSignOutWarningTitle => 'تسجيل الخروج مع وجود تغييرات معلقة؟';

  @override
  String get authSignOutWarningLead => 'بعض التغييرات لم تتم مزامنتها بعد.';

  @override
  String get authSignOutWarningBody =>
      'ستبقى محفوظة بأمان على هذا الجهاز وتستأنف المزامنة عند تسجيل الدخول إلى هذا الحساب مجددًا.';

  @override
  String get authStaySignedInButton => 'البقاء قيد تسجيل الدخول';

  @override
  String get authSignOutAnywayButton => 'تسجيل الخروج على أي حال';

  @override
  String get authSwitchAccountWarningTitle => 'تبديل الحساب؟';

  @override
  String get authSwitchAccountWarningLead =>
      'لا تزال لديك تغييرات في انتظار المزامنة.';

  @override
  String get authSwitchAccountWarningBody =>
      'ستبقى مرتبطة بهذا الحساب على هذا الجهاز ولن تكون متاحة أثناء استخدامك لحساب آخر.';

  @override
  String get authStayOnThisAccountButton => 'البقاء في هذا الحساب';

  @override
  String get authSwitchAnywayButton => 'التبديل على أي حال';

  @override
  String get authSignOutAction => 'تسجيل الخروج';

  @override
  String get authSwitchAccountAction => 'تبديل الحساب';

  @override
  String get authErrorInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة. يرجى التحقق والمحاولة مجددًا.';

  @override
  String get authErrorEmailAlreadyInUse =>
      'تعذر إنشاء الحساب بهذا البريد الإلكتروني. جرب تسجيل الدخول أو استعادة كلمة المرور.';

  @override
  String get authErrorWeakPassword =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل.';

  @override
  String get authErrorPasswordMismatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get authErrorInvalidEmail => 'أدخل عنوان بريد إلكتروني صالحًا.';

  @override
  String get authErrorVerificationStillPending =>
      'لم يتم تأكيد بريدك الإلكتروني بعد. افتح الرابط المرسل إليك أو اطلب رسالة جديدة.';

  @override
  String get authErrorVerificationLinkExpired =>
      'رابط التأكيد غير صالح أو منتهي الصلاحية. اطلب رسالة تأكيد جديدة.';

  @override
  String get authErrorRecoveryLinkExpired =>
      'رابط إعادة تعيين كلمة المرور غير صالح أو منتهي الصلاحية. اطلب رابطًا جديدًا.';

  @override
  String get authErrorRateLimited =>
      'طلبات كثيرة جدًا. يرجى الانتظار قليلًا قبل المحاولة مجددًا.';

  @override
  String get authErrorNetworkOrBackend =>
      'تعذر الاتصال بالخادم. تحقق من اتصالك بالإنترنت وحاول مجددًا.';

  @override
  String get authErrorUnexpected => 'حدث خطأ غير متوقع. يرجى المحاولة مجددًا.';
}
