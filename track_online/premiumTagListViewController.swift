//
//  premiumTagListViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/10/11.
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

class premiumTagListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var TableView: UITableView!
    
    var tagSectionArray = ["goodTag","badTag"]

    var goodTagIDArray = [String]()
    var goodTagNameArray = [String]()
    var goodTagCommentArray = [String]()

    var badTagIDArray = [String]()
    var badTagNameArray = [String]()
    var badTagCauseArray = [String]()
    var badTagCommentArray = [String]()
    var badTagPracticeArray = [String]()

    var goodTagIDArray_re = [String]()
    var goodTagNameArray_re = [String]()
    var goodTagCommentArray_re = [String]()

    var badTagIDArray_re = [String]()
    var badTagNameArray_re = [String]()
    var badTagCauseArray_re = [String]()
    var badTagCommentArray_re = [String]()
    var badTagPracticeArray_re = [String]()

    let Ref = Database.database().reference()

    override func viewDidLoad() {
        TableView.dataSource = self
        TableView.delegate = self
        loadData()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func refresh(_ sender: Any) {
        loadData()
    }
    
    func loadData() {
        Ref.child("purchase").child("premium").child("answer").child("parameter").child("goodTag").child("all").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["tagID"] as? String {
                        self.goodTagIDArray.append(data)
                        self.goodTagIDArray_re = self.goodTagIDArray
                        print(self.goodTagIDArray_re)
                        self.TableView.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["tagName"] as? String {
                        self.goodTagNameArray.append(data)
                        self.goodTagNameArray_re = self.goodTagNameArray
                        self.TableView.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["comment"] as? String {
                        self.goodTagCommentArray.append(data)
                        self.goodTagCommentArray_re = self.goodTagCommentArray
                        self.TableView.reloadData()
                    }
                }
            }
        })
        
        Ref.child("purchase").child("premium").child("answer").child("parameter").child("badTag").child("all").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["tagID"] as? String {
                        self.badTagIDArray.append(data)
                        self.badTagIDArray_re = self.badTagIDArray
                        self.TableView.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["tagName"] as? String {
                        self.badTagNameArray.append(data)
                        self.badTagNameArray_re = self.badTagNameArray
                        self.TableView.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["cause"] as? String {
                        self.badTagCauseArray.append(data)
                        self.badTagCauseArray_re = self.badTagCauseArray
                        self.TableView.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["comment"] as? String {
                        self.badTagCommentArray.append(data)
                        self.badTagCommentArray_re = self.badTagCommentArray
                        self.TableView.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["practice"] as? String {
                        self.badTagPracticeArray.append(data)
                        self.badTagPracticeArray_re = self.badTagPracticeArray
                        self.TableView.reloadData()
                    }
                }
            }
        })

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        print(tagSectionArray)
        return tagSectionArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return goodTagIDArray_re.count
        }else if section == 1 {
            return badTagIDArray_re.count
        }else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return tagSectionArray[0]
        }else if section == 1 {
            return tagSectionArray[1]
        }else{
            return ""
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = self.TableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath as IndexPath) as? tagTableViewCell
            cell!.tagID.text = self.goodTagIDArray_re[indexPath.row]
            cell!.tagName.text = self.goodTagNameArray_re[indexPath.row]
//            cell!.cause.text = "---"
//            cell!.comment.text = "---"
//            cell!.practice.text = "---"
            return cell!
        }else{
            let cell = self.TableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath as IndexPath) as? tagTableViewCell
            cell!.tagID.text = self.badTagIDArray_re[indexPath.row]
            cell!.tagName.text = self.badTagNameArray_re[indexPath.row]
//            cell!.cause.text = self.badTagCauseArray_re[indexPath.row]
//            cell!.comment.text = self.badTagCommentArray_re[indexPath.row]
//            cell!.practice.text = self.badTagPracticeArray_re[indexPath.row]
            return cell!
        }
    }
}
