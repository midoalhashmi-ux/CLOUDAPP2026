import { getDoc, setDoc } from './firestore.js';

// ============================================================================
// بديل Firebase Cloud Functions لهذا المشروع — يعمل على Cloudflare Workers،
// بدون الحاجة لخطة Blaze أو حساب فوترة سعودي عبر CNTXT، وبنفس فكرة الحماية
// تماماً: كل سرّ (مفتاح API-Football، بيانات حساب خدمة Google) يبقى هنا
// فقط، ولا يصل إطلاقاً لكود الموبايل أو المتصفح.
//
// نقطتان يخدمهما هذا الملف:
//   1) POST /getStreamUrl   — يُستدعى من تطبيق المشغل، يرجّع رابط m3u8 الحقيقي.
//   2) POST /refreshMatches — يُستدعى من لوحة التحكم (زر "مزامنة الآن").
//   3) scheduled()          — Cron Trigger كل ساعة، نفس منطق refreshMatches.
// ============================================================================

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, x-admin-key',
};

function json(data, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { 'Content-Type': 'application/json', ...CORS_HEADERS },
  });
}

// ---------------------------------------------------------------------------
// 1) getStreamUrl — نفس منطق دالة Firebase الأصلية بالضبط.
// ---------------------------------------------------------------------------
async function handleGetStreamUrl(request, env) {
  let body;
  try {
    body = await request.json();
  } catch (_) {
    return json({ error: 'invalid-argument', message: 'body غير صالح.' }, 400);
  }

  const channelId = body && body.channelId;
  if (!channelId || typeof channelId !== 'string') {
    return json({ error: 'invalid-argument', message: 'channelId مطلوب.' }, 400);
  }

  const [streamDoc, channelDoc] = await Promise.all([
    getDoc(env, `privateStreams/${channelId}`),
    getDoc(env, `channels/${channelId}`),
  ]);

  if (channelDoc && channelDoc.status === 'disabled') {
    return json({ error: 'permission-denied', message: 'هذه القناة موقوفة مؤقتاً.' }, 403);
  }

  if (channelDoc && channelDoc.protected === false && channelDoc.directUrl) {
    return json({ url: channelDoc.directUrl, expiresIn: null });
  }

  if (!streamDoc) {
    return json({ error: 'not-found', message: 'لم يتم تسجيل مصدر بث لهذه القناة بعد.' }, 404);
  }

  const url = streamDoc.url;
  if (!url || typeof url !== 'string') {
    return json({ error: 'not-found', message: 'رابط البث لهذه القناة غير مضبوط.' }, 404);
  }

  return json({ url, expiresIn: 60 * 60 * 4 });
}

// ---------------------------------------------------------------------------
// 2) مباريات اليوم — API-Football
// ---------------------------------------------------------------------------
function mapFixtureStatus(shortStatus) {
  const s = (shortStatus || '').toString().toUpperCase();
  if (['1H', '2H', 'HT', 'ET', 'P', 'LIVE', 'BT'].includes(s)) return 'LIVE';
  if (['FT', 'AET', 'PEN'].includes(s)) return 'FT';
  if (['PST', 'CANC', 'ABD', 'SUSP', 'INT'].includes(s)) return 'PST';
  return 'NS';
}

function normalizeFixture(fx) {
  const fixture = fx.fixture || {};
  const league = fx.league || {};
  const teams = fx.teams || {};
  const goals = fx.goals || {};

  const dateIso = (fixture.date || '').toString();
  const dateEvent = dateIso.split('T')[0] || '';
  const timePart = dateIso.split('T')[1] || '00:00:00';
  const strTime = timePart.replace(/[+-]\d{2}:\d{2}$/, '').replace('Z', '');

  return {
    idEvent: String(fixture.id ?? ''),
    strLeague: league.name || '',
    strLeagueBadge: league.logo || null,
    strHomeTeam: (teams.home && teams.home.name) || '',
    strAwayTeam: (teams.away && teams.away.name) || '',
    strHomeTeamBadge: (teams.home && teams.home.logo) || null,
    strAwayTeamBadge: (teams.away && teams.away.logo) || null,
    dateEvent,
    strTime: strTime || '00:00:00',
    intHomeScore: goals.home ?? null,
    intAwayScore: goals.away ?? null,
    strStatus: mapFixtureStatus(fixture.status && fixture.status.short),
    strVenue: (fixture.venue && fixture.venue.name) || null,
  };
}

async function fetchAndStoreFixtures(env, dateStr) {
  const response = await fetch(
      `https://v3.football.api-sports.io/fixtures?date=${dateStr}`,
      { headers: { 'x-apisports-key': env.API_FOOTBALL_KEY } },
  );

  if (!response.ok) {
    throw new Error(`تعذر الاتصال بـ API-Football (${response.status}).`);
  }

  const body = await response.json();
  const events = (body.response || []).map(normalizeFixture);

  await setDoc(env, `matches_daily/${dateStr}`, {
    events,
    updatedAt: new Date(),
    source: 'api-football',
  });

  return events.length;
}

function todayDateKey() {
  const now = new Date();
  return `${now.getUTCFullYear()}-${String(now.getUTCMonth() + 1).padStart(2, '0')}-${String(now.getUTCDate()).padStart(2, '0')}`;
}

async function handleRefreshMatches(request, env) {
  const adminKey = request.headers.get('x-admin-key');
  if (!env.ADMIN_SYNC_SECRET || adminKey !== env.ADMIN_SYNC_SECRET) {
    return json({ error: 'permission-denied', message: 'غير مصرح.' }, 403);
  }

  let body = {};
  try {
    body = await request.json();
  } catch (_) {
    // body اختياري — لو ما أُرسل، نستخدم تاريخ اليوم.
  }

  const dateStr = body.date || todayDateKey();
  try {
    const count = await fetchAndStoreFixtures(env, dateStr);
    return json({ ok: true, count, date: dateStr });
  } catch (error) {
    return json({ ok: false, message: String(error && error.message || error) }, 500);
  }
}

// ---------------------------------------------------------------------------
// التوجيه (Routing)
// ---------------------------------------------------------------------------
export default {
  async fetch(request, env) {
    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: CORS_HEADERS });
    }

    const url = new URL(request.url);

    if (request.method === 'POST' && url.pathname === '/getStreamUrl') {
      return handleGetStreamUrl(request, env);
    }

    if (request.method === 'POST' && url.pathname === '/refreshMatches') {
      return handleRefreshMatches(request, env);
    }

    return json({ error: 'not-found', message: 'مسار غير معروف.' }, 404);
  },

  // Cron Trigger — مضبوط في wrangler.toml ليعمل كل ساعة تلقائياً.
  async scheduled(event, env, ctx) {
    ctx.waitUntil(fetchAndStoreFixtures(env, todayDateKey()));
  },
};
