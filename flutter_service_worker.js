'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "906f5b51d4885cc89315f921036f65b2",
"assets/AssetManifest.bin.json": "bbc4a08e9a4f4c881400607d3305b96e",
"assets/AssetManifest.json": "b5097959c5464798be84080cb53e6f34",
"assets/assets/images/aaa.png": "3fff58f52029a9b74384cf3b0bf1a369",
"assets/assets/images/accessory.png": "d9359f86d3924d9e5226aa1cf1b62c5c",
"assets/assets/images/areas.png": "c9c881812d4666cdd6ab0762557c1789",
"assets/assets/images/artStyle.png": "a235885b1221c685a94a2688ce1ff651",
"assets/assets/images/atmosphere.png": "1b0664141c0cc3d4b4c68c8d5b4e3c19",
"assets/assets/images/badFun.png": "470bb4feae9da4bcefb61dbe706c9068",
"assets/assets/images/bestFranchise.png": "e5fcd06c598acea92ecc79dde9401acc",
"assets/assets/images/bestGame.png": "eb6610c08e196e3e5a435c2a474b1a9c",
"assets/assets/images/biggestPersonalImpact.png": "53263c3a923ed245e3f67b9dd52283fb",
"assets/assets/images/biggestRegret.png": "0a8a41aa6fb46b5b7543c806bcf61c0f",
"assets/assets/images/browser.png": "2c816eaedc22ab1afe846937811c9f39",
"assets/assets/images/childhood.png": "fac61f31ada56d337031e9d2592f7da4",
"assets/assets/images/collectathon.png": "300866c1dae71c96d03424f4ac849249",
"assets/assets/images/combat.png": "e7db0bdae216b410e29b2c78fabcbd25",
"assets/assets/images/competitive.png": "c577fe355b4b800b71ec32b8a3c3d786",
"assets/assets/images/coop.png": "ba1c40277e657a432bd4a6345af7fb9f",
"assets/assets/images/difficult.png": "c1169ded78c89e347a45c7dc37f3be1a",
"assets/assets/images/dlc.png": "752ee982c5f2380f4044cb232c9d0de4",
"assets/assets/images/farming.png": "0c3cf0d09abded5339c18300d13a6cf8",
"assets/assets/images/fighting.png": "7d27e7ca96c6dba4cfa3a4be6736dd5f",
"assets/assets/images/fps.png": "c08fd0e9a20f7a3c3f555534dfdafc61",
"assets/assets/images/freeSlot.png": "e65ce5e4181d184bb81b10fcaf4fd2a8",
"assets/assets/images/funniest.png": "fc0e7077016f94195b9915ba9966ad33",
"assets/assets/images/horror.png": "a807f739fc5f5055b2b19f02c3351b9a",
"assets/assets/images/iAlwaysComeBack.png": "1cf734814809ee64d37541a1f7ea67aa",
"assets/assets/images/indie.png": "0f602eb7bb10a33f0bcc2276751ef17e",
"assets/assets/images/iReallyWantToPlay.png": "c64d628a35ef242f4ff954610221f777",
"assets/assets/images/metroidvania.png": "7920fb43aa77beaecbd771f89d30b6a2",
"assets/assets/images/mmo.png": "63f0477aec61cef7de40f454452b742e",
"assets/assets/images/mobile.png": "e340b6f0567f587f7be62f61de9719a1",
"assets/assets/images/modFangame.png": "3d39d31c70c4046914816c0fd7be4fde",
"assets/assets/images/oneDayFinish.png": "d4beab69f96350cba1091da07ca68ea0",
"assets/assets/images/openWorld.png": "2957fcd0c48429c8be11d6130384a322",
"assets/assets/images/partner.png": "1cab5785291ef5e89165ea91b35424c7",
"assets/assets/images/party.png": "bfb3fa37b61b50b09dd1698bd641be6c",
"assets/assets/images/platforming.png": "6b0946ca2e52fb87e1493450847b6f52",
"assets/assets/images/protagonist.png": "b642e917a1becf60c314ec592d4e8a87",
"assets/assets/images/puzzle.png": "067a7311177b8c9f6235b0ef2b9bc5a2",
"assets/assets/images/racing.png": "7c59d2fe4109517f409d4db665d0f5b9",
"assets/assets/images/relaxing.png": "bf5f5ac1ec61512188da5e0553598678",
"assets/assets/images/rhythm.png": "d59fe41ce6eb037c8ca0f6b835e755f4",
"assets/assets/images/roguelike.png": "cee41661fa427acd0b7ae5c358d3e10d",
"assets/assets/images/rpg.png": "88161aac4f61e1146ef2c7c4e02d970d",
"assets/assets/images/soundtrack.png": "7127d4396c3cf81bf8af255825999e0c",
"assets/assets/images/sports.png": "16ebe3678059f26eb8c59584324ae059",
"assets/assets/images/story.png": "d9d529b4578eab5ea2a0e7e33685cecb",
"assets/assets/images/survival.png": "06bb519e33c330baea1b65fc39c08878",
"assets/assets/images/villian.png": "8c1fda5aad152487077631d96422f4f5",
"assets/assets/images/visualNovel.png": "4a29ebd663fd10266621ba82048c38ac",
"assets/assets/images/wh.png": "81f2a169d51c73887571cc515df0a4df",
"assets/assets/images/whyDoIPlayThis.png": "62de1101d6a895c78c48a394b71d6e1d",
"assets/assets/images/worstFranchise.png": "24ef3c046ef15c899d84c4e106898d93",
"assets/assets/images/worstGame.png": "183ea08e53890768028e88d87ed6dd94",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "8065c0fede275a3a2cfa8d655d012a86",
"assets/NOTICES": "569aa8eb7d5133ea6fd9c89e2ba57812",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "f808e333a52e6c3894ee86305c695fde",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "52093afc09d4b3d6f56ddf0dcff29ac2",
"/": "52093afc09d4b3d6f56ddf0dcff29ac2",
"main.dart.js": "77b86029f6ba1fc06f4dcf83cf4731a9",
"manifest.json": "0ec36fe45c130de2e5676884700cd466",
"version.json": "da645dd1431a74187f12b66573bcd78c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
