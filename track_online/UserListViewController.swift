//
//  UserListViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/03/08.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class UserListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    //スクリーンの横幅、縦幅を定義
    let screenWidth = Int(UIScreen.main.bounds.size.width)
    let screenHeight = Int(UIScreen.main.bounds.size.height)
    
    @IBOutlet var sampleTableView: UITableView!
    @IBOutlet weak var logoutItem: UIBarButtonItem!
    //テーブルに表示するセル配列
    var uuidArray = [String]()
    var uuidList = [String]()
//    var QAStatusArray = [String]()
//    let currentUid:String = Auth.auth().currentUser!.uid
    let ref = Database.database().reference()
    var selectedText: String?
    var segueNumber: Int?
    let refreshControl = UIRefreshControl()
    var uuidQAStatusArray = [String]()
    var uuidQAStatusList = [String]()

    override func viewDidLoad() {
        loadData_Firebase()
        sampleTableView.separatorColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(UserListViewController.refreshControlValueChanged(sender:)), for: .valueChanged)
        sampleTableView.addSubview(refreshControl)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       loadData_Firebase()
       super.viewWillAppear(animated)
    }

    @IBAction func logout(_ sender: Any) {

        let alert: UIAlertController = UIAlertController(title: "確認", message: "ログアウトしていいですか？", preferredStyle:  UIAlertController.Style.alert)

        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in

            do{
                try Auth.auth().signOut()
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }catch let error as NSError{
                print(error)
            }
            print("OK")
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)

    }
    
    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
        if uuidArray.isEmpty {
        }else{
            uuidArray.removeAll()
            uuidQAStatusArray.removeAll()
        }
            //データ取得開始
        ref.child("QA").child("uuid").observeSingleEvent(of: .value, with: {
                (snapshot) in
                if let snapdata = snapshot.value as? [String:NSDictionary]{
                //snapdata!.keys : 階層
                //key : 階層
                    for key in snapdata.keys.sorted(){
                    //snap : 階層下のデータを書くのすいた辞書
                    //今回なら、snap = ["videoname":"///"]
                        let snap = snapdata[key]
                        if let uuid = snap!["uuid"] as? String {
                        self.uuidArray.append(uuid)
                        }
                        if let uuidQAStatus = snap!["uuidQAStatus"] as? String {
                            self.uuidQAStatusArray.append(uuidQAStatus)
                        }
                    self.uuidList = self.uuidArray
                        print("\(self.uuidArray)")
                        print("\(self.uuidQAStatusArray)")
                    }
                self.sampleTableView.reloadData()
                }
            }
        )
        refreshControl.endRefreshing()

    }
       
    @IBAction func refreshValue(_ sender: Any) {
        if uuidArray.isEmpty {
        }else{
            uuidArray.removeAll()
            uuidQAStatusArray.removeAll()
            }
            //データ取得開始
        ref.child("QA").child("uuid").observeSingleEvent(of: .value, with: {
                (snapshot) in
                if let snapdata = snapshot.value as? [String:NSDictionary]{
                //snapdata!.keys : 階層
                //key : 階層
                    for key in snapdata.keys.sorted(){
                    //snap : 階層下のデータを書くのすいた辞書
                    //今回なら、snap = ["videoname":"///"]
                        let snap = snapdata[key]
                        if let uuid = snap!["uuid"] as? String {
                        self.uuidArray.append(uuid)
                        }
                        if let uuidQAStatus = snap!["uuidQAStatus"] as? String {
                            self.uuidQAStatusArray.append(uuidQAStatus)
                        }
                    self.uuidList = self.uuidArray
                        print("\(self.uuidArray)")
                        print("\(self.uuidQAStatusArray)")
                    }
                self.sampleTableView.reloadData()
                }
            }
        )
        refreshControl.endRefreshing()
    }
    func loadData_Firebase() {
        if uuidArray.isEmpty {
        }else{
            uuidArray.removeAll()
            uuidQAStatusArray.removeAll()
            }
            print("\(uuidArray)")
            //データ取得開始
            ref.child("QA").child("uuid").observeSingleEvent(of: .value, with: {
                (snapshot) in
                if let snapdata = snapshot.value as? [String:NSDictionary]{
                    for key in snapdata.keys.sorted(){
                        let snap = snapdata[key]
                        if let uuid = snap!["uuid"] as? String {
                            self.uuidArray.append(uuid)
                        }
                        if let uuidQAStatus = snap!["uuidQAStatus"] as? String {
                            self.uuidQAStatusArray.append(uuidQAStatus)
                        }
                        self.uuidList = self.uuidArray
                        self.uuidQAStatusList = self.uuidQAStatusArray
                    }
                self.sampleTableView.reloadData()
                }
            }
        )
    }
        //セクション数を指定
    func numberOfSections(in sampleTableView: UITableView) -> Int {
        return 1
    }
    //表示するcellの数を指定
    func tableView(_ sampleTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uuidList.count
    }

    //cellのコンテンツ
    func tableView(_ sampleTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
            //cellにはsampleArrayが一つずつ入るようにするよ！
            cell.textLabel?.text = uuidList[indexPath.row]
            cell.accessoryView = UIImageView(image:UIImage(named: uuidQAStatusList[indexPath.row]))
            cell.accessoryView?.frame = CGRect(x:0,y:0,width:60,height:40)
            return cell
        }
        
    //cellが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)番セルが押されたよ！")
        selectedText = uuidList[indexPath.row]
        performSegue(withIdentifier: "uuidQAList", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "uuidQAList") {
            let selectedQAList: QAListViewController = segue.destination as!
            QAListViewController
                // 11. SecondViewControllerのtextに選択した文字列を設定する
            selectedQAList.text = self.selectedText!
        }
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
