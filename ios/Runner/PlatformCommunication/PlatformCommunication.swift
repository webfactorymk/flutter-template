//
//  PlatformCommunication.swift
//  Runner
//
//  Created by WF | Gordana Badarovska on 11.5.21.
//

import Foundation

class PlatformCommunication {
    static let shared = PlatformCommunication()
    final var methodChannel: FlutterMethodChannel
    
    init() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let window = appDelegate?.window
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        methodChannel = FlutterMethodChannel(name: Constants.Channel.name,
                                             binaryMessenger: controller.binaryMessenger)
        methodChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            switch call.method {
            case Constants.Method.platformTestMethod:
                self?.onTestMethod(call: call)
            case Constants.Method.platformTestMethod2:
                self?.onTestMethod2(call: call)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
    }
    
    func onTestMethod(call: FlutterMethodCall) {
        methodChannel.invokeMethod(Constants.Method.platformTestMethod, arguments: call.arguments)
    }
    
    func onTestMethod2(call: FlutterMethodCall) {
        methodChannel.invokeMethod(Constants.Method.platformTestMethod2, arguments: call.arguments)
    }
    
    func logUpdate(log: String) {
        methodChannel.invokeMethod(Constants.Method.nativeLogs, arguments: log)
    }
}
