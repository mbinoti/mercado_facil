import Flutter
import UIKit

/// Entry point nativo do aplicativo no iOS.
///
/// Registra os plugins gerados pelo Flutter e delega o restante do ciclo de
/// vida para a implementacao padrao de `FlutterAppDelegate`.
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
