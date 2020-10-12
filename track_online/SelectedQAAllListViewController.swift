//
//  SelectedQAAllListViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/07/04.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import AVKit
import Firebase
import FirebaseStorage
import AVFoundation
import MobileCoreServices
import AssetsLibrary
import SDWebImage

class SelectedQAAllListViewController: UIViewController ,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var selectedText: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var speciality: UILabel!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var userQAText: UILabel!
    @IBOutlet weak var UIimageView: UIImageView!
    @IBOutlet weak var trackAnswer: UILabel!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var sankouURL: UITextView!
    @IBOutlet weak var personIcon: UIImageView!
    @IBOutlet weak var userNameQuestion: UILabel!
    @IBOutlet weak var userAnswerTextView: UITextView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var answerURL: UITextView!
    @IBOutlet weak var sendAnswer: UIButton!
    @IBOutlet weak var makeAnswer: UIButton!
    @IBOutlet weak var sc: UIScrollView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameHidden: UIButton!
    
    @IBOutlet weak var QAmuraUserAnswerTableView: UITableView!
    
    var roomArray = [String]()
    //    var player: AVPlayer?
    let bundleDataType: String = "mp4"
    var text: String?
    var cache: String?
    var selectedDate: String?
    var selectedTime: String?
    var selectedSpeciality: String?
    var selectedUserNameQuestion: String?
    var selectedUid: String?
    var playUrl:NSURL?
    var attachedUrl:NSURL?
    let currentUid:String = Auth.auth().currentUser!.uid
    let currentUserName:String = Auth.auth().currentUser!.displayName!
    var goodButtonValue:String?
    var badButtonValue:String?
    let ref = Database.database().reference()
    var fromUidArray = [String]()
    var answerArray = [String]()
    var userNameAnswerArray = [String]()
    var TimeArray = [String]()
    var DateArray = [String]()
    var sankouURLArray = [String]()
    var goodButtonArray = [String]()
    var fromUidArray_r = [String]()
    var answerArray_r = [String]()
    var userNameAnswerArray_r = [String]()
    var TimeArray_r = [String]()
    var DateArray_r = [String]()
    var sankouURLArray_r = [String]()
    var goodButtonArray_r = [String]()

    var pickerview: UIPickerView = UIPickerView()
    var countAnswer:Int?
    var answerData: String?
    var countPoint = Int()
    var pointEaring:String?
    var Qdate:String?
    var Qtime:String?


    override func viewDidLoad() {
        download()
        let label = UILabel(frame: .zero)
        label.lineBreakMode = .byWordWrapping
        QAmuraUserAnswerTableView.dataSource = self
        QAmuraUserAnswerTableView.delegate = self
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        // インプットビュー設定
        answerTextView.inputAccessoryView = toolbar
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
        
    override func viewWillAppear(_ animated: Bool) {
        userNameAnswerArray.removeAll()
        answerArray.removeAll()
        DateArray.removeAll()
        TimeArray.removeAll()
        sankouURLArray.removeAll()
        userQuestion()
        userAnswer()
        super.viewWillAppear(animated)
    }
    @objc func done() {
        self.view.endEditing(true)
    }

    func textView(_ textView: UITextView,
                      shouldInteractWith URL: URL,
                      in characterRange: NSRange,
                      interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if answerTextView.text == "質問に回答する（1文字〜100字）" {
//            textView.text = ""
//            textView.textColor = UIColor.black
//        }
//    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "質問に回答する（1文字〜100字）"
//            textView.textColor = UIColor.lightGray
//        }
//    }
    func numberOfSections(in myTableView: UITableView) -> Int {
        return 1
    }

        
    func tableView(_ myTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return userNameAnswerArray.count
    }
                
        
    func tableView(_ myTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.QAmuraUserAnswerTableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath as IndexPath) as? QATableViewCell
        cell!.userNameAnswer2_2_2.text = self.userNameAnswerArray[indexPath.row] //①
        cell!.answer2_2_2.text = self.answerArray[indexPath.row]
        cell!.date2_2_2.text = self.DateArray[indexPath.row] //①
        cell!.time2_2_2.text = self.TimeArray[indexPath.row] //①
        cell!.sankouURL2_2_2.text = self.sankouURLArray[indexPath.row] //①

        print("\(self.sankouURLArray[indexPath.row])")
        let key = self.sankouURLArray[indexPath.row]
        if key != ""{
            let attributedString = NSMutableAttributedString(string: key)
            attributedString.addAttribute(.link,value: key,range: NSString(string: key).range(of: key))

        cell!.sankouURL2_2_2.attributedText = attributedString
        cell!.sankouURL2_2_2.isSelectable = true
        cell!.sankouURL2_2_2.isEditable = false
//        self.sankouURL.delegate = self as UITextViewDelegate
        }
        cell!.goodButton2_2_2.setImage(UIImage(named: "goodButton\(goodButtonArray[indexPath.row])"), for: .normal)
        
        return cell!
    }
    
          
    func download(){
                
                let textVideo:String = text!+".mp4"
                let textImage:String = text!+".png"
                let refVideo = Storage.storage().reference().child("QA").child("\(selectedUid!)").child("private").child(text!).child("\(textVideo)")
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
                    self.PlayButton.isHidden = false
                }
                }
                if self.cache == "1"{
                    SDImageCache.shared.clearMemory()
                    SDImageCache.shared.clearDisk()
                    let ref0 = Database.database().reference().child("QA").child("\(selectedUid!)").child("private").child("\(text!)")
                    let data = ["cache":"0" as Any] as [String : Any]
                    ref0.updateChildValues(data)

                }
                let refImage = Storage.storage().reference().child("QA").child("\(selectedUid!)").child("private").child(text!).child("\(textImage)")

                // Load the image using SDWebImage
                if UIimageView != nil {
                    let imageView: UIImageView = self.UIimageView
                // Placeholder image
    //                let placeholderImage = UIImage(named: "placeholder.png")
                    imageView.sd_setImage(with: refImage, placeholderImage: nil)
                }

            }
          
    @IBAction func PlayButton(_ sender: Any) {
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
    
    func userAnswer(){
        let ref0 = Database.database().reference().child("QA").child("private").child("\(selectedSpeciality!)").child("\(text!)").child("trackAnswer")
        ref0.observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let fromUid = snap!["fromUid"] as? String {
                    self.fromUidArray.append(fromUid)
            }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let userNameAnswer = snap!["fromUserName"] as? String {
                    self.userNameAnswerArray.append(userNameAnswer)
            }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let answer = snap!["answer"] as? String {
                    self.answerArray.append(answer)
                    self.answerTextView.text = answer
            }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let date = snap!["date"] as? String {
                    self.DateArray.append(date)
                }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let time = snap!["time"] as? String {
                    self.TimeArray.append(time)
                }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let sankouURL = snap!["sankouURL"] as? String {
                    self.sankouURLArray.append(sankouURL)
                    self.answerURL.text = sankouURL
                }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let goodButton = snap!["goodButton"] as? String {
                    self.goodButtonArray.append(goodButton)
                }
            }
            self.QAmuraUserAnswerTableView.reloadData()
            }
        }
        )

    }
        func userQuestion(){
            date.text = selectedDate
            time.text = selectedTime
            speciality.text = selectedSpeciality
            userNameQuestion.text = selectedUserNameQuestion

//            let good_picture0 = UIImage(named: "hand.thumbsup")
//            self.goodButton.setImage(good_picture0, for: .normal)
//            let bad_picture0 = UIImage(named: "hand.thumbsdown")
//            self.badButton.setImage(bad_picture0, for: .normal)

            let ref0 = Database.database().reference().child("QA").child("private").child("\(selectedSpeciality!)").child("\(text!)")
            ref0.observeSingleEvent(of: .value, with: { (snapshot) in
              // Get user value
              let value = snapshot.value as? NSDictionary
              let key = value?["QAContent"] as? String ?? ""
              self.userQAText.text = key

              // ...
              }) { (error) in
                print(error.localizedDescription)
            }

//            ref0.observeSingleEvent(of: .value, with: { (snapshot) in
//              // Get user value
//                let value = snapshot.value as? NSDictionary
//                let key = value?["sankouURL"] as? String ?? ""
//    //          self.trackAnswer.text = key
//    //            let baseString = "これは設定アプリへのリンクを含む文章です。\n\nこちらのリンクはGoogle検索です"
//                let attributedString = NSMutableAttributedString(string: key)
//                attributedString.addAttribute(.link,
//                                              value: key,
//                                              range: NSString(string: key).range(of: key))
//                self.sankouURL.attributedText = attributedString
//                // isSelectableをtrue、isEditableをfalseにする必要がある
//                // （isSelectableはデフォルトtrueだが説明のため記述）
//                self.sankouURL.isSelectable = true
//                self.sankouURL.isEditable = false
//                self.sankouURL.delegate = self as UITextViewDelegate
//                print("sankouURL")
//
//              // ...
//              }) { (error) in
//                print(error.localizedDescription)
//            }
    }
    
    
    @IBAction func sendAnswer(_ sender: Any) {
                let alert: UIAlertController = UIAlertController(title: "確認", message: "この回答を送信していいですか？", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    (action: UIAlertAction!) -> Void in
                    let ref1 = Database.database().reference().child("QA").child("private")
                    ref1.child("全て").child("\(self.text!)").observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        let key = value?["date"] as? String ?? ""
                        self.Qdate = key
                    })
                    ref1.child("全て").child("\(self.text!)").observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        let key = value?["time"] as? String ?? ""
                        self.Qtime = key
                    })

                    // 回答数の加算
                    ref1.child("全て").child("\(self.text!)").observeSingleEvent(of: .value, with: { (snapshot) in
                      // Get user value
                            let value = snapshot.value as? NSDictionary
                            let key = value?["countAnswer"] as? String ?? ""
                            if key.isEmpty{
                            }else{

                                self.countAnswer = 1
                                
                                let data = ["countAnswer":String(self.countAnswer!)]
                                let data_r = ["fcmTrigger":"\(self.answerTextView.text!)"]
                                ref1.child("\(self.selectedSpeciality!)").child("\(self.text!)").updateChildValues(data)
                                let ref1_1 = Database.database().reference().child("QA").child("\(self.selectedUid!)").child("private").child("\(self.text!)")
                                let ref1_2 = Database.database().reference().child("QA").child("\(self.selectedUid!)").child("private").child("\(self.text!)").child("trackAnswer").child("\(self.currentUid)")
                                let ref1_3 = Database.database().reference().child("QA").child("\(self.selectedUid!)").child("private").child("\(self.text!)").child("fcmTrigger")
                                ref1_1.updateChildValues(data)
                                ref1_2.updateChildValues(data_r)
                                ref1_3.updateChildValues(data_r)

                                ref1.child("全て").child("\(self.text!)").updateChildValues(data)

                                let date1 = Date()
                                let formatter1 = DateFormatter()
                                formatter1.dateStyle = .medium
                                let date = formatter1.string(from: date1)
                                print("\(date)")
                                let date2 = Date()
                                let formatter2 = DateFormatter()
                                formatter2.setLocalizedDateFormatFromTemplate("jm")
                                let time = formatter2.string(from: date2)
                                print("\(time)")
                                let data1 = ["answer":"\(self.answerTextView.text!)","goodButton":"0","badButton":"0","date":"\(date)","time":"\(time)","fromUid":"\(self.currentUid)","fromUserName":"\(self.nameLabel.text!)","registeredUserName":"\(self.nameLabel.text!)","sankouURL":"\(self.answerURL.text!)"]
                                ref1.child("\(self.selectedSpeciality!)").child("\(self.text!)").child("trackAnswer").child("\(self.currentUid)").updateChildValues(data1)
                                ref1.child("全て").child("\(self.text!)").child("trackAnswer").child("\(self.currentUid)").updateChildValues(data1)

                            }
                        }) { (error) in
                            print(error.localizedDescription)
                        }
                    
                    

                    self.navigationController?.popViewController(animated: true)

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
    
}
