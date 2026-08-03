const CACHE_NAME = 'vygapps-offline-cache-v1';
const OFFLINE_URL = '../offline.jsp';

self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_NAME).then((cache) => {
            // Almacenar en caché la página offline y sus recursos asociados (rutas relativas a JS/sw.js)
            return cache.addAll([
                OFFLINE_URL,
                '../CSS/offline.css',
                'offline.js',
                '../images/vyg.svg'
            ]);
        })
    );
    self.skipWaiting();
});

self.addEventListener('activate', (event) => {
    event.waitUntil(self.clients.claim());
});

self.addEventListener('fetch', (event) => {
    // Interceptar solo peticiones de navegación
    if (event.request.mode === 'navigate') {
        event.respondWith(
            fetch(event.request).catch(() => {
                // Retornar la página offline guardada en el caché
                return caches.open(CACHE_NAME).then((cache) => {
                    return cache.match(OFFLINE_URL);
                });
            })
        );
    }
});
