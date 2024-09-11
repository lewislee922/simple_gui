//
//  FlutterContainerViewController.swift
//  Runner
//
//  Created by Lewis Lee on 2024/6/6.
//

import Foundation
import WebKit

class CustomWKWebViewController: UIViewController, WKNavigationDelegate {
    let initialUrl: String
    
    @IBOutlet weak var WKView: WKWebView!
    @IBOutlet weak var BackwardButton: UIButton!
    @IBOutlet weak var ForwardButton: UIButton!
    @IBOutlet weak var ProgressView: UIProgressView!
    
    init?(initialUrl: String) {
        self.initialUrl = initialUrl
        super.init(nibName: "CustomWKWebView", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onTap(_ sender: UIButton) {
        if(sender == BackwardButton) {
            if(WKView.canGoBack) {
                WKView.goBack()
            }
        }
        
        if(sender == ForwardButton) {
            if(WKView.canGoForward) {
                WKView.goForward()
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: initialUrl) {
            let request = URLRequest(url: url)
            WKView.load(request)
        }
        BackwardButton.setTitle("", for: .normal)
        BackwardButton.setImage(.init(systemName: "arrow.uturn.backward"), for: .normal)
        ForwardButton.setTitle("", for: .normal)
        ForwardButton.setImage(.init(systemName: "arrow.uturn.forward"), for: .normal)
        BackwardButton.isEnabled = WKView.canGoBack
        ForwardButton.isEnabled = WKView.canGoForward
        
        WKView.navigationDelegate = self
        WKView.addObserver(self, forKeyPath:  #keyPath(WKWebView.estimatedProgress), options:  .new, context: nil)
    }
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        
//    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        BackwardButton.isEnabled = WKView.canGoBack
        ForwardButton.isEnabled = WKView.canGoForward
        ProgressView.alpha = 1.0
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressView.progress = 0.0
        ProgressView.alpha = 0.0
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            ProgressView.progress = Float(WKView.estimatedProgress)
        }
    }
}
//
//extension SFSafariViewController {
//    override open func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setNeedsStatusBarAppearanceUpdate()
//    }
//}
