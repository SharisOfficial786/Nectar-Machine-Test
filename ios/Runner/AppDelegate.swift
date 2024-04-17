import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

/**
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let fileOpenerChannel = FlutterMethodChannel(name: "file_opener", binaryMessenger: controller.binaryMessenger)
        fileOpenerChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            if call.method == "openFile" {
                guard let args = call.arguments as? [String: Any],
                      let filePath = args["filePath"] as? String else {
                    result(FlutterError(code: "INVALID_FILE_PATH", message: "File path is null.", details: nil))
                    return
                }
                self?.openFile(filePath: filePath)
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func openFile(filePath: String) {
        if let url = URL(string: filePath) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
*/