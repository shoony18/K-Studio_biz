//
//  premiumPracticeRegisterViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/10/13.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Firebase
import FirebaseStorage
import Photos
import MobileCoreServices
import AssetsLibrary

class premiumPracticeRegisterViewController: UIViewController {

    @IBOutlet var practice: UITextField!
    let Ref = Database.database().reference()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func inputPractice(_ sender: Any) {
        practice.text = (sender as AnyObject).text
    }
    
    @IBAction func register(_ sender: Any) {
        
        let now = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let timenow = formatter.string(from: now as Date)
        let date1 = Date()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        let date = formatter1.string(from: date1)
        let date2 = Date()
        let formatter2 = DateFormatter()
        formatter2.setLocalizedDateFormatFromTemplate("jm")
        let time = formatter2.string(from: date2)
        let alert: UIAlertController = UIAlertController(title: "確認", message: "この内容で送信します。一度送信すると内容を修正できません。よろしいですか？", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            let ref = self.Ref.child("purchase").child("premium").child("answer").child("parameter").child("practice").child("all").child("practice_"+"\(timenow)")
            let data = ["practiceID":"practice_"+"\(timenow)","practice":"\(self.practice.text!)"]
            ref.setValue(data)
            self.practice.text = ""
        })

        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })

            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        
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
