//
//  HomePageViewController.swift
//  SprintManager
//
//  Created by Kutkoski, Joseph Anthony on 12/3/16.
//  Copyright © 2016 A290 Fall 2016 - jakutkos, sylyon. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet var homePageLabel: UILabel!
    var homePageUrl: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        
        let myDefaults = NSUserDefaults.standardUserDefaults()
        var urlString = myDefaults.stringForKey("homePageUrl")
        if (urlString == nil) {
            urlString = "https://www.github.com"
        }
        self.homePageUrl = NSURL(string: urlString!)
        self.homePageLabel.text = urlString
        
        if let url = self.homePageUrl {
            webView.loadRequest(NSURLRequest(URL: url))
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        webView.loadHTMLString(
            "<html><body><p>An error occurred when loading your HomePage, please check the web URL entered in Settings. " +
            "Make sure to prefix the website with https://" +
            "</p></body></html>", baseURL: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        webView.stopLoading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
