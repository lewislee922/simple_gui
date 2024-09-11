import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let pluginName: String = "simpleGUI"
    private let webViewType: String = "@views/native-webview"
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      weak var registrar = self.registrar(forPlugin: pluginName)
      
      let factory = FlutterWKWebViewFactory(messenger: registrar!.messenger())
      registrar?.register(
          factory,
          withId: webViewType)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
