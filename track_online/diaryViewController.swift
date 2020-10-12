//
//  diaryViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2019/09/01.
//  Copyright © 2019年 刈田修平. All rights reserved.
//

import UIKit
import WebKit

//extension WKProcessPool {
//    static let shared = WKProcessPool()
//}

class diaryViewController: UIViewController, WKUIDelegate {
    @IBOutlet  var diaryWebView: WKWebView!
//    @IBOutlet weak var tabbarImage1: UIBarButtonItem!
    
//    @IBOutlet weak var diaryTopbarMessage: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://track-online.herokuapp.com/month")
        let request = URLRequest(url:  url!)
        diaryWebView.load(request)

//        self.diaryWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)

        // Do any additional setup after loading the view.
    }
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.processPool = WKProcessPool.shared
        diaryWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        diaryWebView.uiDelegate = self
        view = diaryWebView
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
