const CACHE = "vacatory-v7-20260904-maintenance-notice";
const CORE_ASSETS = [
  "/",
  "/index.html",
  "/manifest.json",
  "/styles.css",
  "/site-shell.js?v=20260904-maintenance4",
  "/supabase.js?v=2",
  "/app.js?v=20260904-fast-assets1"
];

self.addEventListener("install", event => {
  event.waitUntil(
    caches.open(CACHE).then(cache => cache.addAll(CORE_ASSETS))
  );
  self.skipWaiting();
});

self.addEventListener("activate", event => {
  event.waitUntil(
    caches.keys().then(names =>
      Promise.all(
        names
          .filter(name => name !== CACHE)
          .map(name => caches.delete(name))
      )
    )
  );
  self.clients.claim();
});

self.addEventListener("fetch", event => {
  const request = event.request;
  if (request.method !== "GET") return;

  const url = new URL(request.url);

  if (request.mode === "navigate") {
    event.respondWith(networkFirst(request));
    return;
  }

  const isLocalStaticAsset =
    url.origin === self.location.origin &&
    ["script", "style", "image", "font"].includes(request.destination);

  const isSupabaseLibrary =
    url.hostname === "cdn.jsdelivr.net" &&
    url.pathname.includes("/@supabase/supabase-js@");

  if (isLocalStaticAsset || isSupabaseLibrary) {
    event.respondWith(staleWhileRevalidate(request, event));
  }
});

async function networkFirst(request) {
  try {
    const response = await fetch(request);
    if (response.ok) {
      const cache = await caches.open(CACHE);
      await cache.put(request, response.clone());
    }
    return response;
  } catch {
    return (await caches.match(request)) || caches.match("/index.html");
  }
}

async function staleWhileRevalidate(request, event) {
  const cached = await caches.match(request);
  const refresh = fetch(request)
    .then(async response => {
      if (response.ok || response.type === "opaque") {
        const cache = await caches.open(CACHE);
        await cache.put(request, response.clone());
      }
      return response;
    })
    .catch(() => cached || Response.error());

  if (cached) {
    event.waitUntil(refresh);
    return cached;
  }

  return refresh;
}
