import 'dart:html';
import 'dart:js' as js;

// Browser events for the server's access log: the page requests
// /_e/<event>[/<detail>...] and the web server answers 204 without content.
// Event names are fixed constants; details are levels, results and small
// numbers, never anything a visitor typed. At most 200 per page view, none
// from automated browsers.
int _sent = 0;
bool _automated;

void track(String path) {
  try {
    _automated ??= js.context['navigator']['webdriver'] == true;
    if (_automated || _sent >= 200) return;
    _sent++;
    window.navigator.sendBeacon('/_e/$path', '');
  } catch (_) {}
}

int _errors = 0;

// Uncaught script errors, at most five per page view so one broken loop does
// not flood the log.
void trackError(String kind) {
  if (_errors++ < 5) track('error/$kind');
}

void trackErrors() {
  window.onError.listen((_) => trackError('js'));
}
