// Service worker del Simulador de Jubilación: permite abrir la app sin conexión.
// Estrategia «primero la red»: con internet siempre se sirve la versión más reciente
// (y se guarda una copia); sin internet se usa la última copia guardada.
// version.json nunca se guarda, para que el aviso «Ha habido cambios» funcione siempre.

const CACHE = 'simjub-v1';
const CORE = ['./', 'index.html', 'manifest.webmanifest', 'favicon.svg', 'favicon-32.png',
              'apple-touch-icon.png', 'icon-192.png', 'icon-512.png'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(CORE)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(caches.keys()
    .then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
    .then(() => self.clients.claim()));
});

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);

  // Fuentes de Google: copia local y se refresca en segundo plano
  if (url.hostname === 'fonts.googleapis.com' || url.hostname === 'fonts.gstatic.com') {
    e.respondWith(caches.open(CACHE).then(async c => {
      const hit = await c.match(req);
      const net = fetch(req).then(r => { if (r.ok || r.type === 'opaque') c.put(req, r.clone()); return r; }).catch(() => hit);
      return hit || net;
    }));
    return;
  }
  if (url.origin !== location.origin || url.pathname.endsWith('version.json')) return;

  // Páginas y ficheros propios: primero la red, si falla la copia guardada
  const key = req.mode === 'navigate' ? 'index.html' : req;
  e.respondWith(
    fetch(req, { cache: 'no-cache' })
      .then(r => { if (r.ok) { const copy = r.clone(); caches.open(CACHE).then(c => c.put(key, copy)); } return r; })
      .catch(() => caches.match(key, { ignoreSearch: true }).then(r => r || caches.match('./')))
  );
});
