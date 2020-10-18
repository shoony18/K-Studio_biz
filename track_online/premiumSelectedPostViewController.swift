//
//  premiumSelectedPostViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/10/06.
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

class premiumSelectedMyPostViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var TableView: UITableView!
    @IBOutlet var comment: UILabel!
    
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

    var goodTagNameArray = [String]()
    var badTagNameArray = [String]()
    var practiceArray = [String]()
    var practiceForCountArray = [String]()
    var practiceNumbersArray = [Int]()
    var labelRowArray = [Int]()
    var practiceRowArray = [Int]()

    var goodTagNameArray_re = [String]()
    var badTagNameArray_re = [String]()
    var practiceArray_re = [String]()
    var practiceForCountArray_re = [String]()
    var practiceNumbersArray_re = [Int]()
    var labelRowArray_re = [Int]()
    var practiceRowArray_re = [Int]()

    let imagePickerController = UIImagePickerController()
    var cache: String?
    var videoURL: URL?
    var playUrl:NSURL?
    var data:Data?
    var pickerview: UIPickerView = UIPickerView()

    let currentUid:String = Auth.auth().currentUser!.uid
    let currentUserName:String = Auth.auth().currentUser!.displayName!
    let Ref = Database.database().reference()

    override func viewDidLoad() {
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
            self.comment.text = key
        })
    }
    func numberOfSections(in myTableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ myTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if goodTagNameArray_re.isEmpty == true{
            return 1
        }else{
            return goodTagNameArray_re.count + badTagNameArray_re.count + practiceArray_re.count + 3
        }
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
            return cell!
        }else if indexPath.row > 1 && indexPath.row <= 1+goodTagNameArray_re.count{
            let cell = self.TableView.dequeueReusableCell(withIdentifier: "cellAnswer1", for: indexPath as IndexPath) as? premiumSelectedPostTableViewCell
            cell!.answerLabel.text = "✔︎"+goodTagNameArray_re[indexPath.row-2]
            return cell!
        }else if indexPath.row == 1+goodTagNameArray_re.count+1{
            let cell = self.TableView.dequeueReusableCell(withIdentifier: "cellLabel1", for: indexPath as IndexPath) as? premiumSelectedPostTableViewCell
            cell!.titleLabel1.text = "改善ポイント"
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
            }
            return cell!
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "answerForm1", sender: nil)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "answerForm1") {
            if #available(iOS 13.0, *) {
                let nextData: premiumAnswer1ViewController = segue.destination as! premiumAnswer1ViewController
                          nextData.selectedPostID = self.selectedPostID!
                          nextData.selectedUid = self.selectedUid!
            } else {
            }
        }
    }

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

    
}
