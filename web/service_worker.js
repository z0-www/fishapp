/*
 * Basic offline cache for 鱼者文游.
 *
 * Design goals:
 *  - Offline app start after one online visit (shell + CanvasKit + fonts).
 *  - Never cache DeepSeek API traffic (keys/answers must not be persisted by us).
 *  - Static assets: stale-while-revalidate. Navigations: network-first with a
 *    cached shell fallback so a new deployment is picked up when online.
 *
 * When shipping a new build, bump CACHE_VERSION so old caches are removed.
 * (`tool/web/build_web.ps1` rewrites it with a per-build timestamp in the
 * packaged output; keep this source value for local `flutter build web` runs.)
 */
'use strict';

const CACHE_VERSION = 'fish-v0.5.8-1';
const FONT_HOSTS = new Set(['fonts.gstatic.com', 'fonts.googleapis.com']);
const SHELL = [
  './',
  'index.html',
  'diagnostics.html',
  'legacy.html',
  'flutter_bootstrap.js',
  'flutter.js',
  'main.dart.js',
  'manifest.json',
  'version.json',
  'sqlite3.wasm',
  'drift_worker.js',
  'favicon.png',
  'icons/Icon-180.png',
  'icons/Icon-192.png',
  'icons/Icon-512.png',
  'icons/Icon-maskable-192.png',
  'icons/Icon-maskable-512.png',
  'assets/AssetManifest.bin.json',
  'assets/FontManifest.json',
  'assets/fonts/MaterialIcons-Regular.otf',
  'assets/packages/cupertino_icons/assets/CupertinoIcons.ttf',
  'assets/assets/branding/fish_logo.png',
  'canvaskit/canvaskit.js',
  'canvaskit/canvaskit.wasm',
  'canvaskit/chromium/canvaskit.js',
  'canvaskit/chromium/canvaskit.wasm',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    (async () => {
      const cache = await caches.open(CACHE_VERSION);
      // One missing optional file (e.g. a CanvasKit variant) must not block the
      // whole install.
      await Promise.all(
        SHELL.map((url) => cache.add(url).catch(() => undefined)),
      );
      await self.skipWaiting();
    })(),
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    (async () => {
      const keys = await caches.keys();
      await Promise.all(
        keys.filter((key) => key !== CACHE_VERSION).map((key) => caches.delete(key)),
      );
      await self.clients.claim();
    })(),
  );
});

// The page sends every same-origin resource it actually loaded. This captures
// the exact CanvasKit variant and fonts the browser chose, which a fixed
// precache list cannot know in advance.
self.addEventListener('message', (event) => {
  const data = event.data || {};
  if (data.type !== 'cache-urls' || !Array.isArray(data.urls)) return;
  event.waitUntil(
    (async () => {
      const cache = await caches.open(CACHE_VERSION);
      for (const url of data.urls.slice(0, 120)) {
        try {
          const absolute = new URL(url, self.location.href);
          const sameOrigin = absolute.origin === self.location.origin;
          const font = FONT_HOSTS.has(absolute.hostname);
          if (!sameOrigin && !font) continue;
          if (absolute.pathname.includes('service_worker.js')) continue;
          const response = await fetch(absolute, { credentials: 'same-origin' });
          if (response.ok) await cache.put(absolute, response);
        } catch (_) {
          // Best-effort warmup; the shell cache still covers startup.
        }
      }
    })(),
  );
});

self.addEventListener('fetch', (event) => {
  const request = event.request;
  if (request.method !== 'GET') return;

  let url;
  try {
    url = new URL(request.url);
  } catch (_) {
    return;
  }
  const sameOrigin = url.origin === self.location.origin;
  const font = FONT_HOSTS.has(url.hostname);
  if (!sameOrigin && !font) return;
  // Never persist AI requests or anything with credentials in the URL.
  if (sameOrigin && (url.pathname.includes('/api/') || url.searchParams.has('key'))) {
    return;
  }

  if (sameOrigin && request.mode === 'navigate') {
    event.respondWith(
      (async () => {
        try {
          // Never let a previous deployment's HTML or JS be used for a new
          // visit. Cloudflare serves max-age=0, but Safari/HTTP caches and an
          // old worker can still return stale assets.
          const fresh = await fetch(request, { cache: 'no-store' });
          const cache = await caches.open(CACHE_VERSION);
          cache.put('index.html', fresh.clone()).catch(() => undefined);
          return fresh;
        } catch (_) {
          const cache = await caches.open(CACHE_VERSION);
          return (
            (await cache.match('index.html')) ||
            (await cache.match('./')) ||
            new Response('离线状态下没有可用缓存，请联网打开一次。', {
              status: 503,
              headers: { 'content-type': 'text/plain; charset=utf-8' },
            })
          );
        }
      })(),
    );
    return;
  }

  // Same-origin static assets are network-first. Cache-first caused an old
  // main.dart.js to be paired with a new index.html after a deployment, which
  // can leave Safari stuck on the splash forever. Offline still falls back to
  // the cached copy.
  if (sameOrigin) {
    event.respondWith(
      (async () => {
        const cache = await caches.open(CACHE_VERSION);
        try {
          const fresh = await fetch(request, { cache: 'no-store' });
          if (fresh.ok) {
            cache.put(request, fresh.clone()).catch(() => undefined);
          }
          return fresh;
        } catch (_) {
          const cached = await cache.match(request);
          if (cached) return cached;
          return new Response('', { status: 504 });
        }
      })(),
    );
    return;
  }

  // Third-party fonts can stay cache-first; they are static and not code.
  event.respondWith(
    (async () => {
      const cache = await caches.open(CACHE_VERSION);
      const cached = await cache.match(request);
      if (cached) {
        event.waitUntil(
          fetch(request)
            .then((response) => {
              if (response.ok) return cache.put(request, response);
            })
            .catch(() => undefined),
        );
        return cached;
      }
      try {
        const response = await fetch(request);
        if (response.ok && font) {
          cache.put(request, response.clone()).catch(() => undefined);
        }
        return response;
      } catch (_) {
        return new Response('', { status: 504 });
      }
    })(),
  );
});
