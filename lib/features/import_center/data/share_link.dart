/// Finds the link in Android's title/body wrappers without mistaking a
/// transcript that mentions a link for a link-only share.
abstract final class ShareLink {
  static final _role = RegExp(
    r'^\s*(?:#{1,6}\s*)?(?:\*{1,2})?(用户|玩家|提问|User|Human|助手|回答|AI|Assistant|DeepSeek)(?:\*{1,2})?\s*(?:[:：]|$)',
    multiLine: true,
    caseSensitive: false,
  );
  static final _url = RegExp(
    r'https?://[^\s<>"，。；、）】」]+',
    caseSensitive: false,
  );

  static String? canonicalDeepSeek(String value) {
    final input = value.trim();
    final uri = Uri.tryParse(input);
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host != 'chat.deepseek.com' ||
        uri.userInfo.isNotEmpty ||
        uri.hasPort && uri.port != 443 ||
        uri.hasQuery ||
        uri.hasFragment ||
        RegExp(r'[\s\\]').hasMatch(input)) {
      return null;
    }
    final match = RegExp(r'^/share/([A-Za-z0-9_-]{6,64})/?$')
        .firstMatch(uri.path);
    return match == null ? null : 'https://chat.deepseek.com/share/${match[1]}';
  }

  static String? inText(String value) {
    final text = value.trim();
    if (text.length > 720 || _role.allMatches(text).length >= 2) return null;
    final urls = _url.allMatches(text).toList();
    if (urls.length != 1) return null;
    final match = urls.single;
    final unwrapped = match[0]!.replaceFirst(RegExp(r'[)\]，。,；;]+$'), '');
    final canonical = canonicalDeepSeek(unwrapped);
    if (canonical != null && text.length - match[0]!.length <= 300) {
      return canonical;
    }
    return isUrl(text) ? text : null;
  }

  static bool isUrl(String value) {
    final text = value.trim();
    final uri = Uri.tryParse(text);
    return uri != null &&
        uri.host.isNotEmpty &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        !text.contains(RegExp(r'\s'));
  }
}
