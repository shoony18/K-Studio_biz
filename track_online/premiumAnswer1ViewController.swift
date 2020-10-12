//
//  premiumAnswer1ViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/10/10.
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

class premiumAnswer1ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UITextViewDelegate {

    var pickerview: UIPickerView = UIPickerView()
    var currentPickerviewFlag: String?
    var currentTextView = UITextView()

    var allGoodTagNameArray = [String]()
    var allBadTagNameArray = [String]()
    var allGoodTagIDArray = [String]()
    var allBadTagIDArray = [String]()
    var selectedGoodTagName: String?
    var selectedBadTagName: String?
    var selectedGoodTagNameID: String?
    var selectedBadTagNameID: String?
    var selectedPractice: String?
    var selectedPracticeID: String?

    @IBOutlet var TableView: UITableView!
    @IBOutlet var commentTextView: UITextView!
    
    var selectedPostID: String?
    var selectedUid: String?

    var userName: String?
    var height: String?
    var weight: String?
    var memo: String?
    var date: String?
    var time: String?
    var event: String?
    var PB: String?
    var comment: String?

    var goodTagNameArray = [String]()
    var badTagNameArray = [String]()
    var goodTagIDArray = [String]()
    var badTagIDArray = [String]()
    var practiceArray = [String]()
    var practiceIDArray = [String]()

    var goodTagNameArray_re = [String]()
    var badTagNameArray_re = [String]()
    var goodTagIDArray_re = [String]()
    var badTagIDArray_re = [String]()
    var practiceArray_re = [String]()
    var practiceIDArray_re = [String]()

    let imagePickerController = UIImagePickerController()
    var cache: String?
    var videoURL: URL?
    var playUrl:NSURL?
    var data:Data?

    let Ref = Database.database().reference()

    override func viewDidLoad() {
        TableView.dataSource = self
        TableView.delegate = self
        loadTagData()
        download()
        loadDataPost()
        loadDataAnswer()
        loadDataComment()
        super.viewDidLoad()
    }
    func loadTagData(){
        Ref.child("purchase").child("premium").child("answer").child("parameter").child("goodTag").child("all").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let key = snap!["tagName"] as? String {
                        self.allGoodTagNameArray.append(key)
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let key = snap!["tagID"] as? String {
                        self.allGoodTagIDArray.append(key)
                    }
                }
            }
        })
        Ref.child("purchase").child("premium").child("answer").child("parameter").child("badTag").child("all").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let key = snap!["tagName"] as? String {
                        self.allBadTagNameArray.append(key)
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let key = snap!["tagID"] as? String {
                        self.allBadTagIDArray.append(key)
                    }
                }
            }
        })
    }
    func loadDataPost(){
        let ref1 = Ref.child("purchase").child("premium").child("uuid").child("\(self.selectedUid!)").child("post").child("\(self.selectedPostID!)")
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["userName"] as? String ?? ""
            self.userName = key
            self.TableView.reloadData()
        })
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["height"] as? String ?? ""
            self.height = key
            self.TableView.reloadData()
        })
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["weight"] as? String ?? ""
            self.weight = key
            self.TableView.reloadData()
        })
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["memo"] as? String ?? ""
            self.memo = key
            self.TableView.reloadData()
        })
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["date"] as? String ?? ""
            self.date = key
            self.TableView.reloadData()
        })
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["time"] as? String ?? ""
            self.time = key
            self.TableView.reloadData()
        })
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["event"] as? String ?? ""
            self.event = key
            self.TableView.reloadData()
        })
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["PB"] as? String ?? ""
            self.PB = key
            self.TableView.reloadData()
        })
    }
    func loadDataAnswer(){
        goodTagNameArray.removeAll()
        badTagNameArray.removeAll()
        practiceArray.removeAll()

        goodTagNameArray_re.removeAll()
        badTagNameArray_re.removeAll()
        practiceArray_re.removeAll()

        Ref.child("purchase").child("premium").child("uuid").child("\(self.selectedUid!)").child("post").child("\(self.selectedPostID!)").child("answer").child("goodTag").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let key = snap!["tagName"] as? String {
                        self.goodTagNameArray.append(key)
                        self.goodTagNameArray_re = self.goodTagNameArray.reversed()
                        self.TableView.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let key = snap!["tagID"] as? String {
                        self.goodTagIDArray.append(key)
                        self.goodTagIDArray_re = self.goodTagIDArray.reversed()
                        self.TableView.reloadData()
                    }
                }
            }
        })
        Ref.child("purchase").child("premium").child("uuid").child("\(self.selectedUid!)").child("post").child("\(self.selectedPostID!)").child("answer").child("badTag").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let key = snap!["tagName"] as? String {
                        self.badTagNameArray.append(key)
                        self.badTagNameArray_re = self.badTagNameArray.reversed()
                        self.TableView.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let key = snap!["tagID"] as? String {
                        self.badTagIDArray.append(key)
                        self.badTagIDArray_re = self.badTagIDArray.reversed()
                        self.TableView.reloadData()
                    }
                }
            }
        })
        Ref.child("purchase").child("premium").child("uuid").child("\(self.selectedUid!)").child("post").child("\(self.selectedPostID!)").child("answer").child("practice").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let key = snap!["menu"] as? String {
                        self.practiceArray.append(key)
                        self.practiceArray_re = self.practiceArray.reversed()
                        self.TableView.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let key = snap!["practiceID"] as? String {
                        self.practiceIDArray.append(key)
                        self.practiceIDArray_re = self.practiceIDArray.reversed()
                        self.TableView.reloadData()
                    }
                }
            }
        })
    }
    
    func loadDataComment(){
        Ref.child("purchase").child("premium").child("uuid").child("\(self.selectedUid!)").child("post").child("\(self.selectedPostID!)").child("answer").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let key = value?["comment"] as? String ?? ""
            self.comment = key
        })
        let toolbar0 = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spacelItem0 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem0 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done0))
        toolbar0.setItems([spacelItem0, doneItem0], animated: true)
        self.commentTextView.inputAccessoryView = toolbar0


    }
    func numberOfSections(in myTableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ myTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodTagNameArray_re.count + badTagNameArray_re.count + practiceArray_re.count + 4
    }
                
       
    func tableView(_ myTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(goodTagNameArray_re)
        if indexPath.row == 0{
            let cell = self.TableView.dequeueReusableCell(withIdentifier: "cellPost", for: indexPath as IndexPath) as? premiumSelectedPostTableViewCell
            cell!.userName.text = self.userName
            cell!.height.text = self.height
            cell!.weight.text = self.weight
            cell!.title.text = self.memo
            cell!.date.text = self.date
            cell!.time.text = self.time
            cell!.event.text = self.event
            cell!.PB.text = self.PB
            let textImage:String = self.selectedPostID!+".png"
            let refImage = Storage.storage().reference().child("purchase").child("premium").child("uuid").child("\(self.selectedUid!)").child("post").child("\(self.selectedPostID!)").child("\(textImage)")
            cell!.ImageView.sd_setImage(with: refImage, placeholderImage: nil)
            cell?.playVideo.addTarget(self, action: #selector(playVideo(_:)), for: .touchUpInside)
            return cell!
        }else if indexPath.row == 1{
            let cell = self.TableView.dequeueReusableCell(withIdentifier: "cellLabel1", for: indexPath as IndexPath) as? premiumSelectedPostTableViewCell
            cell!.titleLabel1.text = "良いポイント"
            cell?.addTag.addTarget(self, action: #selector(addGoodTag(_:)), for: .touchUpInside)
            return cell!
        }else if indexPath.row > 1 && indexPath.row <= 1+goodTagNameArray_re.count{
            let cell = self.TableView.dequeueReusableCell(withIdentifier: "cellAnswer1", for: indexPath as IndexPath) as? premiumSelectedPostTableViewCell
            cell!.answerLabel.text = "✔︎"+goodTagNameArray_re[indexPath.row-2]
            return cell!
        }else if indexPath.row == 1+goodTagNameArray_re.count+1{
            let cell = self.TableView.dequeueReusableCell(withIdentifier: "cellLabel1", for: indexPath as IndexPath) as? premiumSelectedPostTableViewCell
            cell!.titleLabel1.text = "改善ポイント"
            cell?.addTag.addTarget(self, action: #selector(addBadTag(_:)), for: .touchUpInside)
            cell!.titleLabel1.backgroundColor = UIColor(red: 83/255, green: 166/255, blue: 165/255, alpha: 1)
            return cell!
        }else if indexPath.row > 1+goodTagNameArray_re.count+1 && indexPath.row <= 1+goodTagNameArray_re.count+1+badTagNameArray_re.count{
            let cell = self.TableView.dequeueReusableCell(withIdentifier: "cellAnswer1", for: indexPath as IndexPath) as? premiumSelectedPostTableViewCell
            cell!.answerLabel.text = "✔︎"+badTagNameArray_re[indexPath.row-(1+goodTagNameArray_re.count+1)-1]
            return cell!
        }else if indexPath.row == 1+goodTagNameArray_re.count+1+badTagNameArray_re.count+1{
            let cell = self.TableView.dequeueReusableCell(withIdentifier: "cellLabel1", for: indexPath as IndexPath) as? premiumSelectedPostTableViewCell
            cell!.titleLabel1.text = "オススメ練習"
            cell?.addTag.isHidden = true
            cell!.titleLabel1.backgroundColor = UIColor(red: 130/255, green: 157/255, blue: 241/255, alpha: 1)
            return cell!
        }else if indexPath.row > 1+goodTagNameArray_re.count+1+badTagNameArray_re.count+1 && indexPath.row <= 1+goodTagNameArray_re.count+1+badTagNameArray_re.count+1+practiceArray_re.count{
            let cell = self.TableView.dequeueReusableCell(withIdentifier: "cellAnswer1", for: indexPath as IndexPath) as? premiumSelectedPostTableViewCell
            cell!.answerLabel.text = "✔︎"+practiceArray_re[indexPath.row-(1+goodTagNameArray_re.count+1+badTagNameArray_re.count+1)-1]
            return cell!

        }else{
            let cell = self.TableView.dequeueReusableCell(withIdentifier: "cellAnswer2", for: indexPath as IndexPath) as? premiumSelectedPostTableViewCell
            return cell!
        }
    }
       
    @objc func done0(){
        self.view.endEditing(true)
        print(self.comment!)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
    }

    func tableView(_ tableView: UITableView,canEditRowAt indexPath: IndexPath) -> Bool{
        if indexPath.row > 1 && indexPath.row <= 1+goodTagNameArray_re.count{
            return true
        }else if indexPath.row > 1+goodTagNameArray_re.count+1 && indexPath.row <= 1+goodTagNameArray_re.count+1+badTagNameArray_re.count{
            return true
        }else{
            return false
        }
    }
    //スワイプしたセルを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            if indexPath.row > 1 && indexPath.row <= 1+goodTagNameArray_re.count{
                goodTagIDArray_re.remove(at: indexPath.row-2)
                goodTagNameArray_re.remove(at: indexPath.row-2)
                TableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            }else if indexPath.row > 1+goodTagNameArray_re.count+1 && indexPath.row <= 1+goodTagNameArray_re.count+1+badTagNameArray_re.count{
                badTagIDArray_re.remove(at: indexPath.row-(1+goodTagNameArray_re.count+1)-1)
                badTagNameArray_re.remove(at: indexPath.row-(1+goodTagNameArray_re.count+1)-1)
                TableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
                practiceIDArray_re.remove(at: indexPath.row-(1+goodTagNameArray_re.count+1)-1)
                practiceArray_re.remove(at: indexPath.row-(1+goodTagNameArray_re.count+1)-1)
                let indexPath_re = IndexPath(row: indexPath.row+badTagNameArray_re.count+1, section: 0)
                TableView.deleteRows(at: [indexPath_re as IndexPath], with: UITableView.RowAnimation.automatic)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "selectedPost", sender: nil)
    }

    @objc func addGoodTag(_ sender: UIButton) {
        currentPickerviewFlag = "good"
        let alert: UIAlertController = UIAlertController(title: "タグを追加",message: "追加したいタグを選択してください",preferredStyle: UIAlertController.Style.alert)
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 350)
        let width:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 350)
        alert.view.addConstraint(height)
        alert.view.addConstraint(width)
        print(alert.view.bounds.height)
        print(alert.view.bounds.width)
        let okAction = UIAlertAction(title: "OK",style: UIAlertAction.Style.default,handler:{(action: UIAlertAction) -> Void in
            self.selectedGoodTagName = "\(self.allGoodTagNameArray[self.pickerview.selectedRow(inComponent: 0)])"
            self.selectedGoodTagNameID = "\(self.allGoodTagIDArray[self.pickerview.selectedRow(inComponent: 0)])"
            self.goodTagNameArray_re.insert(self.selectedGoodTagName!, at: 0)
            self.goodTagIDArray_re.insert(self.selectedGoodTagNameID!, at: 0)
            self.TableView.beginUpdates()
            self.TableView.insertRows(at: [IndexPath(row: 2, section: 0)],with: .automatic)
            self.TableView.endUpdates()
        })
        let cancelAction = UIAlertAction(title: "キャンセル",style: UIAlertAction.Style.cancel,handler: nil)
        
        // PickerView
        pickerview.selectRow(0, inComponent: 0, animated: true) // 初期値
        pickerview.frame = CGRect(x: 0, y: 30, width: alert.view.bounds.width * 0.6, height: 300) // 配置、サイズ
        pickerview.dataSource = self
        pickerview.delegate = self
        pickerview.showsSelectionIndicator = true
        alert.view.addSubview(pickerview)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    @objc func addBadTag(_ sender: UIButton) {
        currentPickerviewFlag = "bad"
        let alert: UIAlertController = UIAlertController(title: "タグを追加",message: "追加したいタグを選択してください",preferredStyle: UIAlertController.Style.alert)
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 350)
        let width:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 350)
        alert.view.addConstraint(height)
        alert.view.addConstraint(width)
        print(alert.view.bounds.height)
        print(alert.view.bounds.width)
        let okAction = UIAlertAction(title: "OK",style: UIAlertAction.Style.default,handler:{(action: UIAlertAction) -> Void in
            self.selectedBadTagName = "\(self.allBadTagNameArray[self.pickerview.selectedRow(inComponent: 0)])"
            self.selectedBadTagNameID = "\(self.allBadTagIDArray[self.pickerview.selectedRow(inComponent: 0)])"
            self.badTagNameArray_re.insert(self.selectedBadTagName!, at: 0)
            self.badTagIDArray_re.insert(self.selectedBadTagNameID!, at: 0)
            self.TableView.beginUpdates()
            self.TableView.insertRows(at: [IndexPath(row: 2+self.goodTagNameArray_re.count+1, section: 0)],with: .automatic)
            self.TableView.endUpdates()

            self.Ref.child("purchase").child("premium").child("answer").child("parameter").child("badTag").child("all").child("\(self.selectedBadTagNameID!)").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let key1 = value?["menu"] as? String ?? ""
                let key2 = value?["practiceID"] as? String ?? ""
                self.selectedPractice = key1
                self.selectedPracticeID = key2
                self.practiceArray_re.insert(self.selectedPractice!, at: 0)
                self.practiceIDArray_re.insert(self.selectedPracticeID!, at: 0)
                self.TableView.beginUpdates()
                self.TableView.insertRows(at: [IndexPath(row: 2+self.goodTagNameArray_re.count+1+self.badTagNameArray_re.count+1, section: 0)],with: .automatic)
                self.TableView.endUpdates()
            })
        })
        let cancelAction = UIAlertAction(title: "キャンセル",style: UIAlertAction.Style.cancel,handler: nil)
        
        // PickerView
        pickerview.selectRow(0, inComponent: 0, animated: true) // 初期値
        pickerview.frame = CGRect(x: 0, y: 30, width: alert.view.bounds.width * 0.6, height: 300) // 配置、サイズ
        pickerview.dataSource = self
        pickerview.delegate = self
        pickerview.showsSelectionIndicator = true
        alert.view.addSubview(pickerview)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentPickerviewFlag == "good"{
            return allGoodTagNameArray.count
        }else if currentPickerviewFlag == "bad"{
            return allBadTagNameArray.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentPickerviewFlag == "good"{
            return allGoodTagNameArray[row]
        }else if currentPickerviewFlag == "bad"{
            return allBadTagNameArray[row]
        }else{
            return ""
        }
    }
//    private func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectedGoodTagName = "\(allGoodTagNameArray[pickerview.selectedRow(inComponent: 0)])"
//    }
    @objc func playVideo(_ sender: UIButton) {
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

    func download(){
        let textVideo:String = selectedPostID!+".mp4"
        let refVideo = Storage.storage().reference().child("purchase").child("premium").child("uuid").child("\(self.selectedUid!)").child("post").child("\(self.selectedPostID!)").child("\(textVideo)")
        refVideo.downloadURL{ url, error in
            if (error != nil) {
            } else {
                self.playUrl = url as NSURL?
                print("download success!! URL:", url!)
            }
        }
//        if self.cache == "1"{
//            SDImageCache.shared.clearMemory()
//            SDImageCache.shared.clearDisk()
//            let ref0 = Database.database().reference().child("QA").child("\(currentUid)").child("private").child("\(text!)")
//            let data = ["cache":"0" as Any] as [String : Any]
//            ref0.updateChildValues(data)
//        }
    }
    @IBAction func sendAnswer(_ sender: Any) {
        print(self.goodTagIDArray_re)
        print(self.badTagIDArray_re)
        print(self.practiceIDArray_re)
        print(self.goodTagNameArray_re)
        print(self.badTagNameArray_re)
        print(self.practiceArray_re)
        print(commentTextView.text!)
        let alert: UIAlertController = UIAlertController(title: "確認", message: "この内容で評価を送信します。よろしいですか？", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "ResultView", sender: true)
            let ref0 = self.Ref.child("purchase").child("premium").child("uuid").child("\(self.selectedUid!)").child("post").child("\(self.selectedPostID!)").child("answer")
            ref0.removeValue()

            for key in 0..<self.goodTagIDArray_re.count{
                let data = ["tagID":"\(self.goodTagIDArray_re[key])","tagName":"\(self.goodTagNameArray_re[key])"]
                let ref = self.Ref.child("purchase").child("premium").child("uuid").child("\(self.selectedUid!)").child("post").child("\(self.selectedPostID!)").child("answer").child("goodTag").child("\(self.goodTagIDArray_re[key])")
                ref.updateChildValues(data)
            }
            for key in 0..<self.badTagIDArray_re.count{
                let data = ["tagID":"\(self.badTagIDArray_re[key])","tagName":"\(self.badTagNameArray_re[key])"]
                let ref = self.Ref.child("purchase").child("premium").child("uuid").child("\(self.selectedUid!)").child("post").child("\(self.selectedPostID!)").child("answer").child("badTag").child("\(self.badTagIDArray_re[key])")
                ref.updateChildValues(data)
            }
            for key in 0..<self.practiceIDArray_re.count{
                let data = ["menu":"\(self.practiceArray_re[key])","practiceID":"\(self.practiceIDArray_re[key])","tagID":"\(self.badTagIDArray_re[key])","tagName":"\(self.badTagNameArray_re[key])"]
                let ref = self.Ref.child("purchase").child("premium").child("uuid").child("\(self.selectedUid!)").child("post").child("\(self.selectedPostID!)").child("answer").child("practice").child("\(self.practiceIDArray_re[key])")
                ref.updateChildValues(data)
            }
            let data1 = ["comment":"\(self.commentTextView.text!)"]
            let ref1 = self.Ref.child("purchase").child("premium").child("uuid").child("\(self.selectedUid!)").child("post").child("\(self.selectedPostID!)").child("answer")
            ref1.updateChildValues(data1)
            let data2 = ["answerFlag":"1"]
            let ref2 = self.Ref.child("purchase").child("premium").child("uuid").child("\(self.selectedUid!)").child("post").child("\(self.selectedPostID!)")
            ref2.updateChildValues(data2)
        })

        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })

        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
}
