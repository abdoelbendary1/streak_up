// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get todayHeading => 'لنبنِ سلسلة عاداتك';

  @override
  String get todayHabits => 'عادات اليوم';

  @override
  String get todayYesterday => 'أمس';

  @override
  String get todayNoHabits => 'لا توجد عادات بعد';

  @override
  String get todayNoHabitsHint => 'أنشئ عادتك الأولى وابدأ ببناء روتينك.';

  @override
  String get todayNothingDue => 'لا توجد عادات مقررة اليوم';

  @override
  String get todayNothingDueHint =>
      'عاداتك محفوظة. لا توجد عادات مقررة لهذا اليوم المحلي.';

  @override
  String get todayUnchecked => 'غير مكتملة';

  @override
  String get todayMissed => 'فاتت';

  @override
  String todayMinutes(int minutes) {
    return '$minutes دقيقة';
  }

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
  String get hostPlaceholderSubtitle => 'هذا القسم جاهز للمحتوى القادم.';

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
  String get authPasswordLabel => 'كلمة المرور';

  @override
  String get authConfirmPasswordLabel => 'تأكيد كلمة المرور';

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
  String get authSignOutAction => 'تسجيل الخروج';

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
  String get authErrorRateLimited =>
      'طلبات كثيرة جدًا. يرجى الانتظار قليلًا قبل المحاولة مجددًا.';

  @override
  String get authErrorNetworkOrBackend =>
      'تعذر الاتصال بالخادم. تحقق من اتصالك بالإنترنت وحاول مجددًا.';

  @override
  String get authErrorUnexpected => 'حدث خطأ غير متوقع. يرجى المحاولة مجددًا.';

  @override
  String get habitCreateTitle => 'إنشاء عادة';

  @override
  String get habitNew => 'عادة جديدة';

  @override
  String get habitListSubtitle => 'نظّم عاداتك وواصل تطوير نفسك.';

  @override
  String get habitActive => 'العادات النشطة';

  @override
  String get habitDetails => 'تفاصيل العادة';

  @override
  String get habitName => 'اسم العادة';

  @override
  String get habitDescription => 'الوصف (اختياري)';

  @override
  String get habitCategory => 'الأيقونة والفئة';

  @override
  String get habitSchedule => 'الجدول';

  @override
  String get habitDaily => 'كل يوم';

  @override
  String get habitSelectedDays => 'أيام محددة';

  @override
  String get habitTarget => 'الهدف بالدقائق (اختياري)';

  @override
  String get habitPrivate => 'خاصة';

  @override
  String get habitPrivateDescription => 'أنت فقط من يمكنه رؤية هذه العادة.';

  @override
  String get habitPending => 'بانتظار المزامنة';

  @override
  String get habitEmpty => 'لا توجد عادات بعد. أنشئ عادتك الأولى.';

  @override
  String get habitInvalidName => 'أدخل اسم العادة.';

  @override
  String get habitInvalidSchedule =>
      'اختر يومًا واحدًا على الأقل ومنطقة زمنية صالحة.';

  @override
  String get habitInvalidTarget => 'أدخل عددًا صحيحًا موجبًا من الدقائق.';

  @override
  String get habitStorageError =>
      'تعذّر حفظ عاداتك أو فتحها. تم الاحتفاظ بالتفاصيل التي أدخلتها.';

  @override
  String get habitAccountUnavailable => 'سجّل الدخول إلى حسابك لإنشاء عادة.';

  @override
  String get habitTimezoneError => 'تعذّرت قراءة منطقتك الزمنية. حاول مجددًا.';

  @override
  String get habitExercise => 'رياضة';

  @override
  String get habitWater => 'ماء';

  @override
  String get habitReading => 'قراءة';

  @override
  String get habitMindfulness => 'تأمل';

  @override
  String get habitSleep => 'نوم';

  @override
  String get habitFailed => 'فشلت المزامنة';

  @override
  String get habitRejectedEntity => 'توجد بالفعل عادة بهذا المعرّف.';

  @override
  String get habitSynced => 'تمت المزامنة';

  @override
  String get habitRejectedPayload => 'تعذر على الخادم قبول تفاصيل هذه العادة.';

  @override
  String get habitRejectedCommand => 'يتعارض أمر الإنشاء مع طلب سابق.';

  @override
  String get habitDeliveryPending =>
      'لم يكتمل الإرسال. عادتك محفوظة محليًا؛ أعد المحاولة بعد تسجيل الدخول والاتصال بالإنترنت.';

  @override
  String get todayCompleted => 'مكتملة';

  @override
  String get todaySaving => 'جارٍ حفظ الإكمال';

  @override
  String todayCompleteHabit(String name) {
    return 'أكمل $name';
  }

  @override
  String todayProgress(int completed, int total) {
    return 'اكتمل $completed من $total';
  }

  @override
  String get todayAllComplete => 'اكتملت جميع العادات المطلوبة اليوم.';

  @override
  String get todayEarlierCheckIns => 'عمليات إكمال سابقة — بانتظار المزامنة';

  @override
  String get todayCheckInStorageError =>
      'لم يُحفظ الإكمال. اضغط على زر الإكمال للمحاولة مجددًا.';

  @override
  String get todayCheckInAccountUnavailable =>
      'حسابك غير متاح. سجّل الدخول مجددًا لإكمال هذه العادة.';

  @override
  String get todayOccurrenceUnavailable =>
      'لم يعد هذا الموعد متاحًا للإكمال. تم تحديث اليوم.';
}
