# 0.2.1

- Added webview scrolling listener
- Added stopLoading() method

# 0.2.0

- update sdk
- prevent negative webview height in scaffold
- handle type error in getCookies
- Support file upload via WebView on Android
- fix WebviewScaffold crash on iOS
- Scrollbar functionality to Web view
- Add support of HTTP errors
- Add headers when loading url

# 0.1.6

- fix onStateChanged
- Taking safe areas into account for bottom bars
- iOS
    + withLocalUrl option for iOS > 9.0
- Android
    + add reload, goBack and foForward function

# 0.1.5

- iOS use WKWebView instead of UIWebView

# 0.1.4

- support localstorage for ANDROID

# 0.1.3

- support zoom in webview

# 0.1.2

- support bottomNavigationBar and persistentFooterButtons on webview scaffold

# 0.1.1
- support back button navigation for Android
    + if cannot go back, it will trigger onDestroy
- support preview dart2

# 0.1.0+1

- fix Android close webview

# 0.1.0

- iOS && Android:
    - get cookies
    - eval javascript
    - user agent setting
    - state change event
    - embed in rectangle or fullscreen if null
    - hidden webview
    
- Android
    - adding Activity in manifest is not needed anymore
    
- Add `WebviewScaffold`

# 0.0.9

- Android: remove the need to use FlutterActivity as base activity

# 0.0.5

- fix "onDestroy" event for iOS [#4](https://github.com/dart-flitter/flutter_webview_plugin/issues/4)
- fix fullscreen mode for iOS [#5](https://github.com/dart-flitter/flutter_webview_plugin/issues/5)

# 0.0.4

- IOS implementation
- Update to last version of Flutter

# 0.0.3

- Documentation

# 0.0.2

- Initial version for Android
