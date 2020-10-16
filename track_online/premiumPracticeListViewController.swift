//
//  premiumPracticeListViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/10/14.
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

class premiumPracticeListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var TableView: UITableView!
    var practiceArray = [String]()
    var practiceArray_re = [String]()

    let Ref = Database.database().reference()

    
    override func viewDidLoad() {
        TableView.dataSource = self
        TableView.delegate = self
        loadData()
        super.viewDidLoad()
    }
    func loadData(){
        practiceArray.removeAll()
        practiceArray_re.removeAll()

        let ref = self.Ref.child("purchase").child("premium").child("answer").child("parameter").child("practice").child("all")
        
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["practice"] as? String {
                        self.practiceArray.append(data)
                        self.practiceArray_re = self.practiceArray
                        self.TableView.reloadData()
                    }
                }
            }
        })
    }
        //セクション数を指定
    func numberOfSections(in TableView: UITableView) -> Int {
        return 1
    }
    //表示するcellの数を指定
    func tableView(_ TableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return practiceArray_re.count
    }

    //cellのコンテンツ
    func tableView(_ TableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.TableView.dequeueReusableCell(withIdentifier: "cellAllPractice", for: indexPath as IndexPath) as? tagTableViewCell
            //cellにはsampleArrayが一つずつ入るようにするよ！
        cell?.practice.text = practiceArray_re[indexPath.row]
        return cell!
    }
        
    //cellが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
