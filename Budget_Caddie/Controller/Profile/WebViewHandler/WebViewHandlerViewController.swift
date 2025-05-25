//
//  WebViewHandlerViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 31/01/25.
//

import UIKit
import WebKit
class WebViewHandlerViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: URL(string: "https://www.budgetcaddie.com/privacy-policy/")!))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickBackButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
extension WebViewHandlerViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.view.showBlurLoader()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.view.removeBluerLoader()
    }
}
