// Custom Flutter bootstrap.
//
// Flutter 3.50 generates a `flutter_service_worker.js` that only unregisters
// itself, so the app cannot cache assets offline. This bootstrap deliberately
// does not let the Flutter loader manage a service worker; `index.html` then
// registers `service_worker.js` (our basic offline cache) instead.
//
// The two Flutter template tokens below are replaced by the Flutter tool at
// build time; do not repeat those tokens in comments or strings.
{{flutter_js}}
{{flutter_build_config}}

(function () {
  var boot = window.fishBoot;
  function stage(name, note) {
    if (boot) boot.stage(name, note || '');
  }
  function fail(name, error) {
    if (boot) boot.fail(name, error && error.name ? error.name : '启动失败');
  }
  function withTimeout(promise, ms, label) {
    var timer;
    var timeout = new Promise(function (_, reject) {
      timer = setTimeout(function () {
        reject(new Error(label + ' 超过 ' + Math.round(ms / 1000) + ' 秒未完成'));
      }, ms);
    });
    return Promise.race([promise, timeout]).finally(function () {
      clearTimeout(timer);
    });
  }

  stage('bootstrap-load');
  _flutter.loader.load({
    onEntrypointLoaded: async function (engineInitializer) {
      try {
        stage('engine-init-start');
        var appRunner = await withTimeout(
          engineInitializer.initializeEngine(),
          45000,
          'Flutter 引擎初始化'
        );
        stage('engine-init-done');
        await withTimeout(appRunner.runApp(), 45000, 'Flutter 启动');
        stage('run-app-done');
      } catch (error) {
        fail('flutter', error);
        throw error;
      }
    },
  }).catch(function (error) {
    fail('loader', error);
  });
})();
