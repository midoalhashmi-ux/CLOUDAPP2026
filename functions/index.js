const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");

initializeApp();
const db = getFirestore();

/**
 * تُستدعى من تطبيق المشغل فقط. تستقبل channelId وتُرجع رابط m3u8 الحقيقي
 * المسجّل في مجموعة privateStreams (لا يقرأها تطبيق المحتوى ولا أي عميل آخر).
 *
 * تغيير رابط أي قناة يتم من لوحة التحكم مباشرة (لصق الرابط الجديد + حفظ)
 * ويعمل فوراً بدون أي حاجة لإعادة نشر هذه الدالة.
 */
exports.getStreamUrl = onCall(async (request) => {
  const channelId = request.data && request.data.channelId;
  if (!channelId || typeof channelId !== "string") {
    throw new HttpsError("invalid-argument", "channelId مطلوب.");
  }

  const [streamSnap, channelSnap] = await Promise.all([
    db.collection("privateStreams").doc(channelId).get(),
    db.collection("channels").doc(channelId).get(),
  ]);

  if (channelSnap.exists && channelSnap.data().status === "disabled") {
    throw new HttpsError("permission-denied", "هذه القناة موقوفة مؤقتاً.");
  }

  if (!streamSnap.exists) {
    throw new HttpsError(
        "not-found",
        "لم يتم تسجيل مصدر بث لهذه القناة بعد. أضفه من لوحة التحكم.",
    );
  }

  const url = streamSnap.data().url;
  if (!url || typeof url !== "string") {
    throw new HttpsError("not-found", "رابط البث لهذه القناة غير مضبوط.");
  }

  return {
    url,
    // مدة تقديرية للعرض في التطبيق فقط، وليست انتهاء صلاحية فعلي على الرابط نفسه
    // (الحماية الفعلية هي إخفاء privateStreams عن أي قراءة مباشرة من العملاء).
    expiresIn: 60 * 60 * 4,
  };
});
