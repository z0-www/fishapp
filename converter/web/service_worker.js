'use strict';

const CACHE = 'fish-converter-v1.2.1-mobile';
const SHELL = [
  './',
  'index.html',
  'offline.html',
  'styles.css',
  'app.js',
  'manifest.json',
  'icon-192.png',
  'icon-512.png',
  'icon-180.png',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    (async () => {
      const cache = await caches.open(CACHE);
      await Promise.all(SHELL.map((url) => cache.add(url).catch(() => undefined)));
      await self.skipWaiting();
    })(),
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    (async () => {
      const keys = await caches.keys();
      await Promise.all(keys.filter((key) => key !== CACHE).map((key) => caches.delete(key)));
      await self.clients.claim();
    })(),
  );
});

self.addEventListener('message', (event) => {
  if (event.data === 'SKIP_WAITING') self.skipWaiting();
});

self.addEventListener('fetch', (event) => {
  const request = event.request;
  if (request.method !== 'GET') return;
  const url = new URL(request.url);
  if (url.origin !== self.location.origin) return;
  event.respondWith(
    (async () => {
      const cached = await caches.match(request);
      if (cached) return cached;
      try {
        const response = await fetch(request);
        if (response.ok) {
          const cache = await caches.open(CACHE);
          cache.put(request, response.clone()).catch(() => undefined);
        }
        return response;
      } catch (_) {
        if (request.mode === 'navigate') {
          return (await caches.match('index.html')) ??
            (await caches.match('offline.html')) ??
            new Response(
              '<!doctype html><html lang="zh-CN"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>离线资源已被清理</title><body style="font-family:-apple-system,Segoe UI,sans-serif;padding:28px;line-height:1.7;color:#202124;background:#f6f8fc"><h1 style="font-size:20px">离线资源已被清理</h1><p>浏览器存储被清理后，转换器无法从缓存打开。请联网重新访问一次，然后即可再次断网使用。</p><p style="color:#7b8493">鱼者文游 · 离线对话转换器</p></body></html>',
              { status: 503, headers: { 'content-type': 'text/html; charset=utf-8' } },
            );
        }
        return new Response('', { status: 504 });
      }
    })(),
  );
});
