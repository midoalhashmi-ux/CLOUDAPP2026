# تطبيق البث الرياضي — إعادة بناء نظيفة

هذا الهيكل يحل مشكلة تكرار المسارات (`lib/lib/core/...`) التي كانت تحدث عند
إنشاء الملفات يدوياً من داخل GitHub.

## سبب المشكلة الأصلية
عند الضغط على مجلد فرعي (مثل `lib/core/models`) ثم الضغط على "Create new file"،
واجهة GitHub تضعك بالفعل داخل ذلك المسار. فإذا كتبت المسار الكامل مرة أخرى
(`lib/core/models/channel_model.dart`) يتكرر المسار ويصبح:
`lib/core/models/lib/core/models/channel_model.dart`

## الحل الموصى به: الرفع دفعة واحدة عبر "Upload files" بدل الإنشاء يدوياً
1. افتح صفحة المستودع الفارغة (أو احذف محتواه الحالي إن كان فيه فوضى).
2. اضغط **Add file → Upload files**.
3. اسحب مجلد المشروع كاملاً (بما فيه `lib/` وكل مجلداته الفرعية) دفعة واحدة —
   المتصفحات الحديثة تدعم سحب مجلد كامل والحفاظ على بنيته.
4. اكتب رسالة Commit مثل: `إعادة بناء نظيفة للمشروع` واضغط **Commit changes**.

بهذه الطريقة GitHub يحافظ تلقائياً على المسارات الصحيحة بدون أي تدخل يدوي،
ولن تتكرر مشكلة `lib/lib/...` نهائياً.

### إن أردت الاستمرار بالطريقة اليدوية (ملف واحد كل مرة)
- **قاعدة صارمة**: قبل كل "Create new file"، اضغط أولاً على **اسم المستودع**
  نفسه في أعلى الشريط (وليس أي مجلد فرعي) للعودة لجذر المشروع، ثم اكتب
  المسار الكامل مرة واحدة فقط، مثل:
  `lib/core/models/channel_model.dart`

## هيكل الملفات المُرفقة في هذا الحزمة
```
pubspec.yaml
lib/main.dart
lib/firebase_options.dart
lib/theme/app_theme.dart
lib/theme/dynamic_theme_service.dart
lib/core/models/category_model.dart
lib/core/models/channel_model.dart
lib/core/services/content_service.dart
lib/core/services/secure_stream_service.dart
lib/core/services/feature_flags_service.dart
android/  ← هيكل أندرويد الكامل جاهز ومربوط بـ Firebase الفعلي
```

## ربط Firebase — تم ✅
`lib/firebase_options.dart` و `android/app/google-services.json` مبنيان فعلياً
من مشروع Firebase الحقيقي (sports-stream-app-36a7a)، ومفعّلان في
`android/app/build.gradle` عبر إضافة `com.google.gms.google-services`.
لا حاجة لتشغيل أي أمر CLI — البناء يعمل مباشرة على Codemagic.

## هيكل بيانات Firestore المتوقع (لضبط اللوحة لاحقاً)
- `settings/theme` → `{ primaryColor: "#00C853", backgroundColor: "#0D0D0D", backgroundImageUrl: "" }`
- `settings/features` → `{ matchAlerts: bool, liveScoreTab: bool, backgroundAudio: bool, liveChat: bool }`
- `categories/{id}` → `{ title: string, order: number, iconUrl: string }`
- `channels/{id}` → `{ categoryId: string, title: string, subtitle: string, status: string, startTime: ISO string, logoUrl: string }`

## ما تم إنجازه في هذه الحزمة
- ✅ هيكل مشروع نظيف بدون تكرار مسارات
- ✅ نموذجا الأقسام والقنوات (Category / Channel)
- ✅ خدمة قراءة الأقسام والقنوات من Firestore لحظياً
- ✅ خدمة روابط البث المؤقتة (جاهزة لربطها بـ Cloud Function لاحقاً)
- ✅ خدمة أعلام الميزات (Feature Flags) لحظية من Firestore
- ✅ ثيم ديناميكي (ألوان وخلفية) يُقرأ من Firestore بدون تحديث للتطبيق
- ✅ شاشة رئيسية أولية تعرض الأقسام كنقطة انطلاق

## المتبقي (بالترتيب المقترح)
1. شاشة قنوات القسم + شاشة المشاهدة (مشغل HLS عبر `video_player` + `chewie`)
2. تبويب النتائج المباشرة (Live Score)
3. دمج Google AdMob (بانر + بينية + مكافأة)
4. لوحة تحكم ويب بسيطة لإدارة كل ما سبق بدون كود
5. الإشعارات (Push Notifications) لتنبيهات المباريات
6. المرحلة الأخيرة فقط: تفعيل Blaze Plan + Cloud Function لحماية روابط البث

أرسل لي "أكمل الخطوة رقم 1" (أو أي رقم) في أي وقت وسأبني الشاشة أو الميزة كاملة بنفس الأسلوب.
