//
//  ViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2019/08/31.
//  Copyright © 2019年 刈田修平. All rights reserved.
//

import UIKit
import WebKit


class mypageViewController: UIViewController, WKUIDelegate{
    @IBOutlet var mypageWebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://track-online.herokuapp.com/mypage/home")
        let request = URLRequest(url:  url!)
        mypageWebView.load(request)
        //        self.diaryWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
        
        // Do any additional setup after loading the view.
        
    }
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.processPool = WKProcessPool.shared
        mypageWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        mypageWebView.uiDelegate = self
        view = mypageWebView
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
