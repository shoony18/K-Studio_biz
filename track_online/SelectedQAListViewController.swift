//
//  SelectedQAListViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/02/27.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import AVKit
import Firebase
import FirebaseStorage
import AVFoundation
import MobileCoreServices
import AssetsLibrary

class SelectedQAListViewController: UIViewController ,UITextViewDelegate, UIScrollViewDelegate{
    
    @IBOutlet weak var selectedText: UILabel!
    @IBOutlet weak var TextFieldGenre: UILabel!
    @IBOutlet weak var sc: UIScrollView!
    @IBOutlet weak var userQAText: UILabel!
    @IBOutlet weak var UIimageView: UIImageView!
    @IBOutlet weak var trackAnswer: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shadowView1: UIView!
    @IBOutlet weak var shadowView2: UIView!
    @IBOutlet weak var shadowView3: UIView!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var sankouURL: UITextView!
    @IBOutlet weak var sankouURLTextview: UITextView!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    
    var text0: String?
    var uuidSelectedText: String?
    var text1: String?
    var roomArray = [String]()
    var uuidQAStatusArray = [String]()
    //    var player: AVPlayer?
    let bundleDataType: String = "mp4"
    var playUrl:NSURL?
    var attachedUrl:NSURL?
    var txtActiveView = UITextView()
    var goodButtonValue:String?
    var badButtonValue:String?

    override func viewDidLoad() {
        selectedText.text = text0
        uuidSelectedText = text1
        let data = ["date":"-","time":"-","QATitle":"\(text0!)"]
        let ref0 = Database.database().reference().child("QA").child("\(uuidSelectedText!)").child("\(text0!)")
        ref0.updateChildValues(data)
        ref0.observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let key = value?["TextFieldGenre"] as? String ?? ""
            if key.isEmpty{
                let data1 = ["TextFieldGenre":"-"]
                ref0.updateChildValues(data1)
            }
          // ...
          }) { (error) in
            print(error.localizedDescription)
        }

        userQA()
        download()

        // 影の方向（width=右方向、height=下方向、CGSize.zero=方向指定なし）
////        shadowView1.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        shadowView2.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        shadowView3.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        // 影の色
////        shadowView1.layer.shadowColor = UIColor.black.cgColor
//        shadowView2.layer.shadowColor = UIColor.black.cgColor
//        shadowView3.layer.shadowColor = UIColor.black.cgColor
//        // 影の濃さ
////        shadowView1.layer.shadowOpacity = 0.3
//        shadowView2.layer.shadowOpacity = 0.3
//        shadowView3.layer.shadowOpacity = 0.3
//        // 影をぼかし
////        shadowView1.layer.shadowRadius = 4
//        shadowView2.layer.shadowRadius = 4
//        shadowView3.layer.shadowRadius = 4

        let toolbar0 = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spacelItem0 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem0 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done0))
        toolbar0.setItems([spacelItem0, doneItem0], animated: true)

        answerTextView.inputAccessoryView = toolbar0
        sankouURLTextview.inputAccessoryView = toolbar0
        
        self.playButton.isHidden = true
        
//        let label = UILabel(frame: .zero)
//        label.lineBreakMode = .byWordWrapping
 
        answerTextView.delegate = self
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(SelectedQAListViewController.handleKeyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(SelectedQAListViewController.handleKeyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func done0() {
        self.view.endEditing(true)
    }

    func download(){
        let textVideo:String = text0!+".mp4"
        let textImage:String = text0!+".png"
        let refVideo = Storage.storage().reference().child("QA").child(text1!).child(text0!).child("\(textVideo)")
        print("\(refVideo)")
        refVideo.downloadURL{ url, error in
            if (error != nil) {
                print("QA添付動画なし")
                let imageView: UIImageView = self.UIimageView
                // Placeholder image
                let placeholderImage = UIImage(named: "rikujou_track_top.png")
                imageView.image = placeholderImage
            } else {
                self.playUrl = url as NSURL?
                print("download success!! URL:", url!)
                print("QA添付動画あり")
                self.playButton.isHidden = false
            }
        }
        let refImage = Storage.storage().reference().child("QA").child(text1!).child(text0!).child("\(textImage)")
        if UIimageView != nil {
            let imageView: UIImageView = self.UIimageView
            let placeholderImage = UIImage(named: "placeholder.png")
            imageView.sd_setImage(with: refImage, placeholderImage: placeholderImage)
        }
    }

    func userQA(){
        let good_picture0 = UIImage(named: "hand.thumbsup")
        self.goodButton.setImage(good_picture0, for: .normal)
        let bad_picture0 = UIImage(named: "hand.thumbsdown")
        self.badButton.setImage(bad_picture0, for: .normal)
        
        let ref0 = Database.database().reference().child("QA").child("\(uuidSelectedText!)").child("\(text0!)")
        ref0.observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let key = value?["TextFieldGenre"] as? String ?? ""
          self.TextFieldGenre.text = key

          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
        ref0.observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let key = value?["TextViewQAcontent"] as? String ?? ""
          self.userQAText.text = key

          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
        ref0.observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let key = value?["trackAnswer"] as? String ?? ""
          self.trackAnswer.text = key
          self.answerTextView.text = key
            print("track回答")

          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
        ref0.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let key = value?["sankouURL"] as? String ?? ""
        //          self.trackAnswer.text = key
        //            let baseString = "これは設定アプリへのリンクを含む文章です。\n\nこちらのリンクはGoogle検索です"
            let attributedString = NSMutableAttributedString(string: key)
            attributedString.addAttribute(.link,
                                                  value: key,
                                                  range: NSString(string: key).range(of: key))
            self.sankouURL.attributedText = attributedString
                    // isSelectableをtrue、isEditableをfalseにする必要がある
                    // （isSelectableはデフォルトtrueだが説明のため記述）
            self.sankouURL.isSelectable = true
            self.sankouURL.isEditable = false
            self.sankouURL.delegate = self as UITextViewDelegate
                    print("sankouURL")

            self.sankouURLTextview.text = key
                  // ...
        }) { (error) in
            print(error.localizedDescription)
        }

        ref0.observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let key = value?["goodButton"] as? String ?? ""
            self.goodButtonValue = key
            print("\(self.goodButtonValue!)")
            if self.goodButtonValue == "1"{
                print("\(key)")
                let picture1 = UIImage(named: "hand.thumbsup.fill")
                self.goodButton.setImage(picture1, for: .normal)
                let picture0 = UIImage(named: "hand.thumbsdown")
                self.badButton.setImage(picture0, for: .normal)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        ref0.observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let key = value?["badButton"] as? String ?? ""
            self.badButtonValue = key
            print("\(self.badButtonValue!)")
            if self.badButtonValue == "1"{
                print("badButton == 1")
                let picture1 = UIImage(named: "hand.thumbsdown.fill")
                self.goodButton.setImage(picture1, for: .normal)
                let picture0 = UIImage(named: "hand.thumbsup")
                self.badButton.setImage(picture0, for: .normal)
            }
        }) { (error) in
            print(error.localizedDescription)
        }

        print(userQAText.text!)
        print(trackAnswer.text!)
    }

    @IBAction func playButton(_ sender: Any) {
        let player = AVPlayer(url: playUrl! as URL
        )

        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player

        // Modally present the player and call the player's play() method when complete.
        present(controller, animated: true) {
            controller.player!.play()
        }
    }
    
    @IBAction func removeQA(_ sender: Any) {
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "削除", message: "この質問を削除してもいいですか？", preferredStyle:  UIAlertController.Style.alert)

        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            Database.database().reference().child("QA").child("\(self.uuidSelectedText!)").child("\(self.text0!)").removeValue()
            self.navigationController?.popViewController(animated: true)
            //            self.dismiss(animated: true, completion: nil)
//            Database.database().reference().child("QA").child(self.currentUid).observeSingleEvent(of: .value, with: {
//                (snapshot) in
//                if let snapdata = snapshot.value as? [String:NSDictionary]{
//                //snapdata!.keys : 階層
//                //key : 階層
//                    for key in snapdata.keys.sorted(){
//                    //snap : 階層下のデータを書くのすいた辞書
//                    //今回なら、snap = ["videoname":"///"]
//                        let snap = snapdata[key]
//                        if let QAName = snap!["QAName"] as? String {
//
//                            if QAName == self.text!{
//
//                            }
//                        }
//                    }
//                }
//            }
//            )
            
            print("OK")
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })

        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)

        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func answerSend(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "確認", message: "回答を送信していいですか？", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            let data = ["trackAnswer":"\(self.answerTextView.text!)","sankouURL":"\(self.sankouURLTextview.text!)","QAStatus": "QAStatus1.png"]
            Database.database().reference().child("QA").child("\(self.uuidSelectedText!)").child("\(self.text0!)").updateChildValues(data)
            let data1 = ["fcmTrigger":"\(self.answerTextView.text!)"]
            Database.database().reference().child("QA").child("\(self.uuidSelectedText!)").child("\(self.text0!)").child("fcmTrigger").updateChildValues(data1)

            Database.database().reference().child("QA").child("\(self.uuidSelectedText!)").observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    if let snapdata = snapshot.value as? [String:NSDictionary]{
                        for key in snapdata.keys.sorted(){
                            let snap = snapdata[key]
                            if let QAStatus = snap!["QAStatus"] as? String {
                                if QAStatus == "QAStatus0.png"{
                                    let data0 = ["uuid":"\(self.uuidSelectedText!)","uuidQAStatus":"QAStatus0.png"]
                                    Database.database().reference().child("QA").child("uuid").child("\(self.uuidSelectedText!)").updateChildValues(data0)
                                    break
                                }else{
                                    let data = ["uuid":"\(self.uuidSelectedText!)","uuidQAStatus":"QAStatus3.png"]
                                    Database.database().reference().child("QA").child("uuid").child("\(self.uuidSelectedText!)").updateChildValues(data)
                                }
//                                self.uuidQAStatusArray.append(uuidQAStatus)
                            }
                        }
                    }
                }
            )

            
            self.navigationController?.popViewController(animated: true)
            
//            let data0 = ["QAStatus": "QAStatus1.png"]
//            Database.database().reference().child("QA").child("\(self.uuidSelectedText!)").child("\(self.text0!)").updateChildValues(data0)
            print("QAStatus変わったよ！")

        }
        )
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
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
