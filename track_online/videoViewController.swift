//
//  videoViewController.swift
//  FirebaseCore
//
//  Created by 刈田修平 on 2019/10/27.
//

import UIKit
import WebKit

extension WKProcessPool {
    static let shared = WKProcessPool()
}

class videoViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    @IBOutlet weak var videoToolbar: UIToolbar!
    @IBOutlet weak var videoWebView: WKWebView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // webサイトの読み込み開始時や完了時に処理をおこなうためのデリゲート
        videoWebView.navigationDelegate = self as? WKNavigationDelegate
        
        // target="_blank"で設定されているリンクに遷移するためのデリゲート
        videoWebView.uiDelegate = self
        
        let url = URL(string: "https://track-online.herokuapp.com/video/index")
        let request = URLRequest(url:  url!)
        videoWebView.load(request)

        backBtn.isEnabled = false
        nextBtn.isEnabled = false
        // Do any additional setup after loading the view.
    }
    

//    override func loadView() {
//        let webConfiguration = WKWebViewConfiguration()
//        webConfiguration.processPool = WKProcessPool.shared
//        self.videoWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: 500, height: 850), configuration: webConfiguration)
//    }
    
    
    @IBAction func backPage(_ sender: Any) {
        self.videoWebView.goBack()
    }
    @IBAction func nextPage(_ sender: Any) {
        self.videoWebView.goForward()
    }
    @IBAction func reloadPage(_ sender: Any) {
        self.videoWebView.reload()
    }

    // webサイトの読み込み開始時に起動
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        // インジケータ(実機の左上でグルグルするアニメーション)の表示を開始する
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // ボタンの有効性をチェック
        self.backBtn.isEnabled = self.videoWebView.canGoBack
        self.nextBtn.isEnabled = self.videoWebView.canGoForward
    }
    // webサイトの読み込み完了時に起動
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        // インジケータの表示を終了する
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // ボタンの有効性をチェック
        self.backBtn.isEnabled = self.videoWebView.canGoBack
        self.nextBtn.isEnabled = self.videoWebView.canGoForward
    }
   /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
