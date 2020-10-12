//
//  QATopViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/02/24.
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


class QATopViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UIScrollViewDelegate,UITextViewDelegate{
        
    let imagePickerController = UIImagePickerController()
    var videoURL: URL?
    var currentAsset: AVAsset?
    let currentUid:String = Auth.auth().currentUser!.uid
    var data:Data?
    var pickerview: UIPickerView = UIPickerView()
    var currentTextField = UITextField()
    var currentTextView = UITextView()
    var selectedQAGenre:[String] = []
    var segueNumber: Int?
    
    @IBOutlet weak var shadowView1: UIView!
    @IBOutlet weak var shadowView2: UIView!
    @IBOutlet weak var shadowView3: UIView!
    @IBOutlet weak var TextFieldQAGenre: UITextField!
    @IBOutlet weak var TextViewQAcontent: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textValidateQAGenre: UILabel!
    @IBOutlet weak var textValidateQAContent: UILabel!
    @IBOutlet weak var textValidateQAVideo: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
        
    override func viewDidLoad() {
        TextViewQAcontent.delegate = self
        selectedQAGenre = ["","一般","個別"]
        textValidateQAGenre.isHidden = true
        textValidateQAContent.isHidden = true
        textValidateQAVideo.isHidden = true
        pickerview.delegate = self
        pickerview.dataSource = self
        pickerview.showsSelectionIndicator = true
        // 影の方向（width=右方向、height=下方向、CGSize.zero=方向指定なし）
        shadowView1.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        shadowView2.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        shadowView3.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        // 影の色
        shadowView1.layer.shadowColor = UIColor.black.cgColor
        shadowView2.layer.shadowColor = UIColor.black.cgColor
        shadowView3.layer.shadowColor = UIColor.black.cgColor
        // 影の濃さ
        shadowView1.layer.shadowOpacity = 0.3
        shadowView2.layer.shadowOpacity = 0.3
        shadowView3.layer.shadowOpacity = 0.3
        // 影をぼかし
        shadowView1.layer.shadowRadius = 4
        shadowView2.layer.shadowRadius = 4
        shadowView3.layer.shadowRadius = 4
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)

        let toolbar0 = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spacelItem0 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem0 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done0))
        toolbar0.setItems([spacelItem0, doneItem0], animated: true)

        TextFieldQAGenre.inputView = pickerview
        TextFieldQAGenre.inputAccessoryView = toolbar
        TextViewQAcontent.inputAccessoryView = toolbar0

        self.contentView.addSubview(imageView)
        self.contentView.sendSubviewToBack(imageView);
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func textViewDidChange(_ textView: UITextView) {
        let beforeStr: String = TextViewQAcontent.text // 文字列をあらかじめ取得しておく
        if TextViewQAcontent.text.count > 50 { // 10000字を超えた時
            // 以下，範囲指定する
            let zero = beforeStr.startIndex
            let start = beforeStr.index(zero, offsetBy: 0)
            let end = beforeStr.index(zero, offsetBy: 50)
            TextViewQAcontent.text = String(beforeStr[start...end])
            textValidateQAContent.isHidden = false
            textValidateQAContent.text = "質問内容は50文字以内にして下さい"
        }
    }
    @objc func done() {
        if currentTextField == TextFieldQAGenre{
            TextFieldQAGenre.endEditing(true)
            TextFieldQAGenre.text = "\(selectedQAGenre[pickerview.selectedRow(inComponent: 0)])"
        }
    }
    @objc func done0() {
        self.view.endEditing(true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == TextFieldQAGenre {
            return selectedQAGenre.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == TextFieldQAGenre {
            return selectedQAGenre[row]
        } else {
            print("nil")
            return ""
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerview.delegate = self
        self.pickerview.dataSource = self
        currentTextField = textField
        if currentTextField == TextFieldQAGenre{
            currentTextField.inputView = pickerview
        }else{
            print("nil")
        }
    }

    @IBAction func selectedImage(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        //imagePickerController.mediaTypes = ["public.image", "public.movie"]
        imagePickerController.delegate = self
        //動画だけ
        imagePickerController.mediaTypes = ["public.movie"]
        //画像だけ
        //imagePickerController.mediaTypes = ["public.image"]
        present(imagePickerController, animated: true, completion: nil)
        print("選択できた！")
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("yes！")

        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        imageView.image = previewImageFromVideo(videoURL!)!
        imageView.contentMode = .scaleAspectFit
        imagePickerController.dismiss(animated: true, completion: nil)

    }

    func previewImageFromVideo(_ url:URL) -> UIImage? {
        print("動画からサムネイルを生成する")
        let asset = AVAsset(url:url)
        let imageGenerator = AVAssetImageGenerator(asset:asset)
        imageGenerator.appliesPreferredTrackTransform = true
        var time = asset.duration
        time.value = min(time.value,0)
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            let image = UIImage(cgImage: imageRef)

            // PNG形式の画像フォーマットとしてNSDataに変換
            data = image.pngData()
            return UIImage(cgImage: imageRef)
        } catch {
            return nil
        }

    }

    @IBAction func playMovie(_ sender: Any) {
        if let videoURL = videoURL{
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true){
                print("動画再生")
                playerViewController.player!.play()
            }
        }
    }
    override func shouldPerformSegue(
        withIdentifier identifier: String,
        sender: Any?) -> Bool {

        if identifier == "sentQA" {
            if TextFieldQAGenre.text == "" || TextViewQAcontent.text == "" {
                return false
            }else if TextFieldQAGenre.text == "個別" && videoURL == nil{
                return false
            }
        }
        return true
    }
    @IBAction func sendVideo(_ sender: Any) {
        textValidateQAGenre.isHidden = true
        textValidateQAContent.isHidden = true
        textValidateQAVideo.isHidden = true
        if TextFieldQAGenre.text?.count == 0 {
            textValidateQAGenre.isHidden = false
            textValidateQAGenre.text = "質問ジャンルを選択してください"
            return
        }else if TextViewQAcontent.text?.count == 0 {
            textValidateQAContent.isHidden = false
            textValidateQAContent.text = "質問内容を入力してください"
            return
        }else if TextFieldQAGenre.text == "個別" && videoURL == nil{
            textValidateQAVideo.isHidden = false
            textValidateQAVideo.text = "動画を選択してください"
            return
        }

        let now = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let timenow = formatter.string(from: now as Date)

        //ここから動画DB格納定義
        if videoURL != nil{
        self.segueNumber = 1
        let storageReference = Storage.storage().reference().child("QA").child("\(currentUid)").child("\(timenow)").child("\(timenow).mp4")
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                /// create a temporary file for us to copy the video to.
        let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(videoURL!.lastPathComponent )
                /// Attempt the copy.
            
        do {
            try FileManager().copyItem(at: videoURL!.absoluteURL, to: temporaryFileURL)
        } catch {
            print("There was an error copying the video file to the temporary location.")
        }
        print("\(temporaryFileURL)")
        storageReference.putFile(from: temporaryFileURL, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                print("error")
                return
            }
                  // Metadata contains file metadata such as size, content-type.
                    _ = metadata.size
                  // You can also access to download URL after upload.
            storageReference.downloadURL { (url, error) in
                guard url != nil else {
                      // Uh-oh, an error occurred!
                    return
                }
            }
        }
        let storageReferenceImage = Storage.storage().reference().child("QA").child("\(currentUid)").child("\(timenow)").child("\(timenow).png")
                storageReferenceImage.putData(data!, metadata: nil) { metadata, error in
                    guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print("error")
                    return
                    }
                  // Metadata contains file metadata such as size, content-type.
                    _ = metadata.size
                  // You can also access to download URL after upload.
                    storageReference.downloadURL { (url, error) in
                        guard url != nil else {
                      // Uh-oh, an error occurred!
                            return
                        }
                    }
        }
        }else{
            self.segueNumber = 0
        }
        //ここまで動画DB格納定義

//        let QARef = Database.database().reference().child("QA").child("\(currentUid)").childByAutoId()
//        let QAObject = [
//            "QAName":"\(timenow)"]
//
//        QARef.setValue(QAObject, withCompletionBlock:{error,ref in
//            if error == nil{
//                print("Successful  upload")
//        //                self.dismiss(animated: true, completion: nil)
//            }else{
//            }
//        })
        
        let commentRef = Database.database().reference().child("QA").child("\(currentUid)").child("\(timenow)")
        let commentObject = [
            "QAName":"\(timenow)","trackAnswer":"まだコメントはありません","TextViewQAcontent":"\(TextViewQAcontent.text!)","QAStatus":"QAStatus0.png" as Any
            ] as [String : Any]
        
        commentRef.setValue(commentObject, withCompletionBlock:{error,ref in if error == nil{
            print("コメントをアップロードしました")
                //                self.dismiss(animated: true, completion: nil)
        }else{
            }
        })
//        let textViewRef = Database.database().reference().child("QA").child("\(currentUid)").child("\(timenow)").child("textView")
//        let textViewObject = [
//            "TextViewQAcontent":"\(TextViewQAcontent.text!)"
//        ]
//        textViewRef.setValue(textViewObject, withCompletionBlock:{error,ref in if error == nil{
//            print("テキストビューをアップロードしました")
//                //                self.dismiss(animated: true, completion: nil)
//        }else{
//            }
//        })

//        let postRef = Database.database().reference().child("posts").childByAutoId()
//        let postObject = [
//            "age":textField1.text as Any,
//            "sex":textField2.text  as Any,
//            "genre":textField3.text as Any,
//            "timestamp":timenow as Any
//            ]as[String:Any]
//
//        postRef.setValue(postObject, withCompletionBlock:{error,ref in
//            if error == nil{
//                //                self.dismiss(animated: true, completion: nil)
//            }else{
//            }
//        })
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
