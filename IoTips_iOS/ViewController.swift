//
//  ViewController.swift
//  IoTips_iOS
//
//  Created by 유태우 on 20/11/2018.
//  Copyright © 2018 유태우. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {

    var webView: WKWebView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    
//    let denlBetaService : String = "DenlBetaService"
//    let accountID : String = "ID"
//    let accountPW : String = "PW"
//    var attemptLogin = false
    
    
    override func loadView() {
        super.loadView()
        
        let statusBarHeight : Int = Int(UIApplication.shared.statusBarFrame.height)
        print(statusBarHeight)
        
        //        webView = WKWebView(frame: self.view.frame)
        //        webView.uiDelegate = self
        //        webView.navigationDelegate = self
        //
        //        self.view = self.webView!
        
        let contentController = WKUserContentController()
        let webConfiguration = WKWebViewConfiguration()
        
        //        let userScript = WKUserScript(source: "redHeader()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        //        contentController.addUserScript(userScript)
        
        contentController.add(self, name: "checkWebkit")
        contentController.add(self, name: "changeStatusBarBGColor")
//        contentController.add(self, name: "savePassword")
//        contentController.add(self, name: "logout")
        webConfiguration.userContentController = contentController
        
        webView = WKWebView(frame:.zero , configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        //view = webView
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let wvf : String = "V:|-\(statusBarHeight)-[v0]|"
        print(wvf)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":webView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: wvf, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":webView]))
        
        
        //        let webConfiguration = WKWebViewConfiguration()
        //
        //        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        //        webView.uiDelegate = self
        //        webView.navigationDelegate = self
        //        self.view = webView
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url) {
            //            let path = webView.url?.lastPathComponent
            //            if(path=="/"){
            //                UIApplication.shared.statusBarView?.backgroundColor = .white
            //                UIApplication.shared.statusBarStyle = .default
            //            }else{
            //                UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(red: 216.0/255.0, green: 67.0/255.0, blue: 21.0/255.0, alpha: 1)
            //                UIApplication.shared.statusBarStyle = .lightContent
            //            }
            print("### URL:", self.webView.url!)
        }
        
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            // When page load finishes. Should work on each page reload.
            if (self.webView.estimatedProgress == 1) {
                activityIndicator.stopAnimating()
                refreshControl.endRefreshing()
                
                
//                if(!attemptLogin){
//
//                    let id = KeychainService.loadPassword(service: denlBetaService, account: accountID)
//                    let pw = KeychainService.loadPassword(service: denlBetaService, account: accountPW)
//                    if((id != nil) && (pw != nil)){
//                        //                        let idStr = id as! String
//                        //                        let pwStr = pw as! String
//                        let fun = "loginSejoingWithWebkit('\(id!)', '\(pw!)')"
//                        self.webView.evaluateJavaScript(fun, completionHandler: {
//                            (any, err) -> Void in
//                            print(err ?? "no error")
//                            self.attemptLogin = true
//                        })
//                    }else{
//                        print("Password does not exist")
//                    }
//                }
                
                let path = webView.url?.lastPathComponent
                if(path=="/"){
                    UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(red: 71.0/255.0, green: 70.0/255.0, blue: 69.0/255.0, alpha: 1)
                    UIApplication.shared.statusBarStyle = .lightContent
                }else{
                    UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(red: 71.0/255.0, green: 70.0/255.0, blue: 69.0/255.0, alpha: 1)
                    UIApplication.shared.statusBarStyle = .lightContent
                }
                print("### URL2:", self.webView.url!)
                print("### EP:", self.webView.estimatedProgress)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(red: 216.0/255.0, green: 67.0/255.0, blue: 21.0/255.0, alpha: 1)
        //        UIApplication.shared.statusBarStyle = .lightContent
        
        // Text (Pull to refresh) with format (Textcolor Black) for RefreshControl
        //        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [
        //            NSForegroundColorAttributeName: UIColor.blackColor()
        //            ])
        
        // #selector(refresh) = "refresh" function called
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        // TintColor - Color of Activity Indicator
        refreshControl.tintColor = UIColor.white
        
        // Add RefreshControl to WebView
        webView.scrollView.addSubview(refreshControl)
        
        // Do any additional setup after loading the view, typically from a nib.
        let myBlog = "https://iotips.xyz"
        let url = URL(string: myBlog)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    // Refresh the WebView
    @objc func refresh(sender:AnyObject) {
        webView.reload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme != "http" && url.scheme != "https" {
            //            UIApplication.shared.openURL(url)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default, handler: {action in completionHandler()})
        alert.addAction(otherAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void){
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: {(action) in completionHandler(false)})
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(action) in completionHandler(true)})
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.frame = CGRect(x: view.frame.midX-50, y: view.frame.midY-50, width: 100, height: 100)
        activityIndicator.color = UIColor.init(red: 45.0/255.0, green: 165.0/255.0, blue: 232.0/255.0, alpha: 1)// UIColor.red
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
    }
    
    
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        //activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
    }
    
    // JS -> Native CALL
    @available (iOS 8.0, *)
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "changeStatusBarBGColor") {
            let color :String = message.body as! String
            if(color == "white"){
                UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(red: 71.0/255.0, green: 70.0/255.0, blue: 69.0/255.0, alpha: 1)
                UIApplication.shared.statusBarStyle = .default
            }else if(color == "black"){
                UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(red: 71.0/255.0, green: 70.0/255.0, blue: 69.0/255.0, alpha: 1)
                UIApplication.shared.statusBarStyle = .lightContent
            }
            //            print("YOURMETHOD 호출 \(message.body)")
        }
//        else if(message.name == "savePassword"){
//            let values:[String:String] = message.body as! Dictionary
//            let id = values["id"]! // as! String
//            let pw = values["password"]! // as! String
//            KeychainService.savePassword(service: denlBetaService, account: accountID, data: id)
//            KeychainService.savePassword(service: denlBetaService, account: accountPW, data: pw)
//        }else if(message.name == "logout"){
//            KeychainService.removePassword(service: denlBetaService, account: accountID)
//            KeychainService.removePassword(service: denlBetaService, account: accountPW)
//        }
    }
    

}

