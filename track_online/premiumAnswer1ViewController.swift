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
    var selectedPracticeIDArray = [String]()
    var practiceForCountArray = [String]()
    var practiceNumbersArray = [Int]()
    var labelRowArray = [Int]()
    var practiceRowArray = [Int]()

    var goodTagNameArray_re = [String]()
    var badTagNameArray_re = [String]()
    var goodTagIDArray_re = [String]()
    var badTagIDArray_re = [String]()
    var practiceArray_re = [String]()
    var practiceIDArray_re = [String]()
    var selectedPracticeIDArray_re = [String]()
    var practiceForCountArray_re = [String]()
    var practiceNumbersArray_re = [Int]()
    var labelRowArray_re = [Int]()
    var practiceRowArray_re = [Int]()

    var practiceRow: Int = 0
    var labelRow: Int = 0
    var labelRowPlus: Int = 0
    var nextPath: Int!

    let imagePickerController = UIImagePickerController()
    var cache: String?
    var videoURL: URL?
    var playUrl:NSURL?
    var data:Data?

    let Ref = Database.database().reference()

    override func viewDidLoad() {
        loadTagData()
        download()
        loadDataPost()
        loadDataAnswer()
        loadDataComment()
        super.viewDidLoad()
        TableView.dataSource = self
        TableView.delegate = self
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
          self.TableView.reloadData()
        }
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
            
        })
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["height"] as? String ?? ""
            self.height = key
            
        })
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["weight"] as? String ?? ""
            self.weight = key
            
        })
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["memo"] as? String ?? ""
            self.memo = key
            
        })
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["date"] as? String ?? ""
            self.date = key
            
        })
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["time"] as? String ?? ""
            self.time = key
            
        })
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["event"] as? String ?? ""
            self.event = key
            
        })
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["PB"] as? String ?? ""
            self.PB = key
            
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
                        self.goodTagNameArray_re = self.goodTagNameArray
                        
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let key = snap!["tagID"] as? String {
                        self.goodTagIDArray.append(key)
                        self.goodTagIDArray_re = self.goodTagIDArray
                        
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
                        self.badTagNameArray_re = self.badTagNameArray
                        
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let key1 = snap!["tagID"] as? String {

                        self.badTagIDArray.append(key1)
                        self.badTagIDArray_re = self.badTagIDArray
                        
                        self.Ref.child("purchase").child("premium").child("uuid").child("\(self.selectedUid!)").child("post").child("\(self.selectedPostID!)").child("answer").child("badTag").child("\(key1)").child("practice").observeSingleEvent(of: .value, with: {(snapshot) in
                            if let snapdata = snapshot.value as? [String:NSDictionary]{
                                for key in snapdata.keys.sorted(){
                                    let snap = snapdata[key]
                                    if let key2 = snap!["practice"] as? String {
                                        self.practiceArray.append(key2)
                                        self.practiceArray_re = self.practiceArray
                                    }
                                }
                                for key in snapdata.keys.sorted(){
                                    let snap = snapdata[key]
                                    if let key2 = snap!["practiceID"] as? String {
                                        self.practiceForCountArray.append(key2)
                                        self.practiceForCountArray_re = self.practiceForCountArray

                                        self.practiceIDArray.append(key2)
                                        self.practiceIDArray_re = self.practiceIDArray
                                        
                                    }
                                }
                                self.practiceNumbersArray_re.append(self.practiceForCountArray_re.count)
                                self.labelRowArray.removeAll()
                                self.labelRowArray_re.removeAll()
                                for number in 0..<self.practiceNumbersArray_re.count{
                                    if number == 0{
                                        self.labelRowArray.append(1+self.goodTagNameArray_re.count+1+1)
                                    }else{
                                        self.labelRowArray.append(1+self.goodTagNameArray_re.count+1+number+self.practiceNumbersArray_re[number-1]+1)
                                    }
                                    self.labelRowArray_re = self.labelRowArray
                                }
                                print(self.labelRowArray_re)
                                self.practiceRowArray.removeAll()
                                self.practiceRowArray_re.removeAll()
                                for number in self.labelRowArray_re.first!..<self.goodTagNameArray_re.count + self.badTagNameArray_re.count + self.practiceArray_re.count + 3{
                                    if self.labelRowArray_re.contains(number){
                                    }else{
                                        self.practiceRowArray.append(number)
                                    }
                                    self.practiceRowArray_re = self.practiceRowArray
                                }
                            }
                        })
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
        return goodTagNameArray_re.count + badTagNameArray_re.count + practiceArray_re.count + 3
    }
                
       
    func tableView(_ myTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        }else if labelRowArray_re.contains(indexPath.row){
            let cell = self.TableView.dequeueReusableCell(withIdentifier: "cellAnswer1", for: indexPath as IndexPath) as? premiumSelectedPostTableViewCell
            cell!.answerLabel.text = "✔︎"+badTagNameArray_re[labelRowArray_re.firstIndex(of:indexPath.row)!]
            return cell!
        }else{
            let cell = self.TableView.dequeueReusableCell(withIdentifier: "cellPractice", for: indexPath as IndexPath) as? premiumSelectedPostTableViewCell
            if practiceRowArray_re.firstIndex(of:indexPath.row) != nil{
                cell!.answerLabel.text = practiceArray_re[practiceRowArray_re.firstIndex(of:indexPath.row)!]
                cell!.recommendTrainigLabel.text = "おすすめトレーニング\(practiceRowArray_re.firstIndex(of:indexPath.row)!+1)"
            }
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
        }else if labelRowArray_re.contains(indexPath.row){
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
            }else if labelRowArray_re.contains(indexPath.row){
                let Path:Int = indexPath.row  //スワイプしたセルのindex
                var lastFlag:Int  //スワイプしたセルのindexがlabelRowArray_re.lastであるかの確認フラグ
                if indexPath.row == labelRowArray_re.last{
                    nextPath = goodTagNameArray_re.count + badTagNameArray_re.count + practiceArray_re.count + 3
                    lastFlag = 1
                }else{
                    nextPath = labelRowArray_re[labelRowArray_re.firstIndex(of:indexPath.row)!+1]
                    lastFlag = 0
                }
                //スワイプしたセルの次の改善ポイントセルのindex

                //スワイプしたセルのindex情報をTagIDArray_re及びbadTagNameArray_reから削除
                badTagIDArray_re.remove(at: labelRowArray_re.firstIndex(of:indexPath.row)!)
                badTagNameArray_re.remove(at: labelRowArray_re.firstIndex(of:indexPath.row)!)
                TableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
                //スワイプしたセルのindex情報をlabelRowArray_reから削除
                labelRowArray_re.remove(at: labelRowArray_re.firstIndex(of:indexPath.row)!)
                //スワイプしたセル以降のlabelRowArray_reのindex情報をそれぞれ必要分（nextPath - Path）差し引く
                if lastFlag == 0{
                    for key in labelRowArray_re.firstIndex(of:nextPath)!..<labelRowArray_re.count{
                        labelRowArray_re[key] -= nextPath - Path
                    }
                }
                for number in Path+1..<nextPath{
                    print(number)
                    practiceIDArray_re.remove(at: practiceRowArray_re.firstIndex(of:Path+1)!)
                    practiceArray_re.remove(at: practiceRowArray_re.firstIndex(of:Path+1)!)
                    let indexPath_re = IndexPath(row: Path, section: 0)
                    TableView.deleteRows(at: [indexPath_re as IndexPath], with: UITableView.RowAnimation.automatic)
                }
                //スワイプしたセルの次のセルから直近改善ポイントセルまでのindex情報をpracticeRowArray_reから削除
                for key in indexPath.row+1..<nextPath{
                    practiceRowArray_re.remove(at: practiceRowArray_re.firstIndex(of:key)!)
                }
                //スワイプしたセル以降のセルのindexをそれぞれ必要分（nextPath - Path）差し引く
                if lastFlag == 0{
                    for key in practiceRowArray_re.firstIndex(of:nextPath+1)!..<practiceRowArray_re.count{
                        practiceRowArray_re[key] -= nextPath - Path
                    }
                }
                print(labelRowArray_re)
                print(self.practiceRowArray_re)
                print(self.badTagNameArray_re)
                print(self.practiceArray_re)
                self.TableView.reloadData()

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
            for key in 0..<self.labelRowArray_re.count{
                self.labelRowArray_re[key] += 1
            }
            for key in 0..<self.practiceRowArray_re.count{
                self.practiceRowArray_re[key] += 1
            }
//            self.goodTagNameArray_re.append(self.selectedGoodTagName!)
//            self.goodTagIDArray_re.append(self.selectedGoodTagNameID!)
//            self.TableView.reloadData()

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
            
            if self.labelRowArray_re.count != 0{
                for key in 0..<self.labelRowArray_re.count{
                    self.labelRowArray_re[key] += 1
                }
                for key in 0..<self.practiceRowArray_re.count{
                    self.practiceRowArray_re[key] += 1
                }
            }
            self.labelRowArray_re.insert(self.goodTagNameArray_re.count+3, at: 0)

            self.TableView.beginUpdates()
            self.TableView.insertRows(at: [IndexPath(row: self.goodTagNameArray_re.count+3, section: 0)],with: .automatic)
            self.TableView.endUpdates()

            self.Ref.child("purchase").child("premium").child("answer").child("parameter").child("badTag").child("all").child("\(self.selectedBadTagNameID!)").child("practice").observeSingleEvent(of: .value, with: {(snapshot) in
                if let snapdata = snapshot.value as? [String:NSDictionary]{
                    for key in snapdata.keys.sorted(){
                        let snap = snapdata[key]
                        if let key = snap!["practice"] as? String {
                            self.selectedPractice = key
                            self.practiceArray_re.insert(self.selectedPractice!, at: 0)
                            self.practiceRowArray_re.insert(self.goodTagNameArray_re.count+4, at: 0)
                            if self.practiceRowArray_re.count >= 2{
                                for key in 1..<self.practiceRowArray_re.count{
                                    self.practiceRowArray_re[key] += 1
                                }
                            }
                            if self.labelRowArray_re.count >= 2{
                                for key in 1..<self.labelRowArray_re.count{
                                    self.labelRowArray_re[key] += 1
                                }
                            }
                            print(self.labelRowArray_re)
                            print(self.practiceRowArray_re)
                            print(self.badTagNameArray_re)

                            self.TableView.beginUpdates()
                            self.TableView.insertRows(at: [IndexPath(row: self.goodTagNameArray_re.count+4, section: 0)],with: .automatic)
                            self.TableView.endUpdates()
                        }
                    }
                    for key in snapdata.keys.sorted(){
                        let snap = snapdata[key]
                        if let key = snap!["practiceID"] as? String {
                            self.selectedPracticeID = key
                            self.practiceIDArray_re.insert(self.selectedPracticeID!, at: 0)
                        }
                    }
                }
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
            for number in 0..<self.badTagIDArray_re.count{
                self.selectedPracticeIDArray.removeAll()
                self.selectedPracticeIDArray_re.removeAll()
                let data = ["tagID":"\(self.badTagIDArray_re[number])","tagName":"\(self.badTagNameArray_re[number])"]
                let ref = self.Ref.child("purchase").child("premium").child("uuid").child("\(self.selectedUid!)").child("post").child("\(self.selectedPostID!)").child("answer").child("badTag").child("\(self.badTagIDArray_re[number])")
                ref.updateChildValues(data)
                
                self.Ref.child("purchase").child("premium").child("answer").child("parameter").child("badTag").child("all").child("\(self.badTagIDArray_re[number])").child("practice").observeSingleEvent(of: .value, with: {(snapshot) in
                    if let snapdata = snapshot.value as? [String:NSDictionary]{
                        for key in snapdata.keys.sorted(){
                            let snap = snapdata[key]
                            if let key = snap!["practiceID"] as? String {
                                self.selectedPracticeIDArray.append(key)
                                self.selectedPracticeIDArray_re = self.selectedPracticeIDArray
                                let data = ["practiceID":"\(key)"]
                                let ref = self.Ref.child("purchase").child("premium").child("uuid").child("\(self.selectedUid!)").child("post").child("\(self.selectedPostID!)").child("answer").child("badTag").child("\(self.badTagIDArray_re[number])").child("practice").child("\(key)")
                                ref.updateChildValues(data)
                                let ref1 = self.Ref.child("purchase").child("premium").child("answer").child("parameter").child("badTag").child("all").child("\(self.badTagIDArray_re[number])").child("practice").child("\(key)")
                                ref1.observeSingleEvent(of: .value, with: { (snapshot) in
                                  let value = snapshot.value as? NSDictionary
                                    let key1 = value?["practice"] as? String ?? ""
                                    print(key1)
                                    let data = ["practice":"\(key1)","tagID":"\(self.badTagIDArray_re[number])","tagName":"\(self.badTagNameArray_re[number])"]
                                    let ref = self.Ref.child("purchase").child("premium").child("uuid").child("\(self.selectedUid!)").child("post").child("\(self.selectedPostID!)").child("answer").child("badTag").child("\(self.badTagIDArray_re[number])").child("practice").child("\(key)")
                                    ref.updateChildValues(data)
                                })

                            }
                        }
                    }
                })
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
