//
//  FlutterSafariView.swift
//  Runner
//
//  Created by Lewis Lee on 2024/6/6.
//

import Foundation
import SafariServices
import WebKit
import Flutter


class FlutterWKWebViewFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
            self.messenger = messenger
            super.init()
        }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        FLNativeView(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: messenger)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
              return FlutterStandardMessageCodec.sharedInstance()
        }
}


class FLNativeView: NSObject, FlutterPlatformView {
    private var wkViewController: UIViewController?
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        
    }

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        wkViewController = nil;
        if let dict = args as? [String: Any] {
            if let urlString = dict["initUrlString"] as? String {
                wkViewController = CustomWKWebViewController(initialUrl: urlString)
            }
        }
        
            
//        else {
//            _view = UIView()
//            safariViewController = SFSafariViewController(url: URL(string: "")!)
//            // iOS views can be created here
//            createNativeView(view: _view)
//        }
        super.init()
        
        
    }

    func view() -> UIView {
//        return safariViewController?.view ?? createNativeView()
        return wkViewController?.view ?? createNativeView()
    }

    func createNativeView() -> UIView {
        var _view = UIView()
        _view.backgroundColor = UIColor.clear
        let nativeLabel = UILabel()
        nativeLabel.text = "Can't open website"
        nativeLabel.textColor = UIColor.white
        nativeLabel.textAlignment = .center
        nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
        _view.addSubview(nativeLabel)
        return _view
    }
}
