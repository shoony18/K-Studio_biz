//
//  QAListViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/02/25.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class QAListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var text: String?
    var uuidText: String?

    //スクリーンの横幅、縦幅を定義
    let screenWidth = Int(UIScreen.main.bounds.size.width)
    let screenHeight = Int(UIScreen.main.bounds.size.height)
    //テーブルビューインスタンス作成
//    var sampleTableView: UITableView  =   UITableView()
    @IBOutlet var sampleTableView: UITableView!
    @IBOutlet weak var QAStatus: UIImageView!
    
    //テーブルに表示するセル配列
    var QAArray = [String]()
    var QAList = [String]()
    var QAStatusArray = [String]()
    let ref = Database.database().reference()
    var selectedText: String?
    var segueNumber: Int?
    let refreshControl = UIRefreshControl()
    var QAStatusRe: String?

    override func viewDidLoad() {
        uuidText = text
//        sampleTableView.frame = CGRect(x:screenWidth * 0/100, y:screenHeight * 10/100,
//                                 width:screenWidth * 100/100, height:screenHeight * 80/100)
        // sampleTableView の dataSource 問い合わせ先を self に
//        sampleTableView.frame = view.bounds
//        sampleTableView.delegate = self
//        // sampleTableView の delegate 問い合わせ先を self に
//        sampleTableView.dataSource = self
//        //cellに名前を付ける
//        sampleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        //実際にviewにsampleTableViewを表示させる
//        self.view.addSubview(sampleTableView)
//        //cellの高さを指定
//        self.sampleTableView.rowHeight = 50
        //セパレーターの色を指定
        sampleTableView.separatorColor = UIColor.gray
        //cellとcellの間にセパレーターをなくす

//        sampleTableView.separatorStyle = UITableViewCell.SeparatorStyle.none


        refreshControl.addTarget(self, action: #selector(QAListViewController.refreshControlValueChanged(sender:)), for: .valueChanged)
        sampleTableView.addSubview(refreshControl)
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
       loadData_Firebase()
       super.viewWillAppear(animated)
    }

    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
        print("テーブルを下に引っ張った時に呼ばれる")
        if QAArray.isEmpty {
        }else{
            QAArray.removeAll()
            QAStatusArray.removeAll()
        }
        print("\(QAArray)")
        ref.child("QA").child("\(uuidText!)").observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
            //snapdata!.keys : 階層
            //key : 階層
                for key in snapdata.keys.sorted(){
                //snap : 階層下のデータを書くのすいた辞書
                //今回なら、snap = ["videoname":"///"]
                    let snap = snapdata[key]
                if let QAName = snap!["QAName"] as? String {
                    self.QAArray.append(QAName)
                }
                self.QAList = self.QAArray
                }
                for key in snapdata.keys.sorted(){
                    //snap : 階層下のデータを書くのすいた辞書
                    //今回なら、snap = ["videoname":"///"]
                    let snap = snapdata[key]
                    if let QAStatus = snap!["QAStatus"] as? String {
                        self.QAStatusArray.append(QAStatus)
                    }
                    print("\(self.QAStatusArray)")
                //                self.QAList = self.QAArray
                }
                self.sampleTableView.reloadData()
            }
        }
        )
        refreshControl.endRefreshing()
        
    }
    @IBAction func refreshValue(_ sender: Any) {
        if QAArray.isEmpty {
        }else{
            QAArray.removeAll()
        }
        print("\(QAArray)")
        ref.child("QA").child("\(uuidText!)").observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
            //snapdata!.keys : 階層
            //key : 階層
                for key in snapdata.keys.sorted(){
                //snap : 階層下のデータを書くのすいた辞書
                //今回なら、snap = ["videoname":"///"]
                    let snap = snapdata[key]
                    if let QAName = snap!["QAName"] as? String {
                    self.QAArray.append(QAName)
                }
                self.QAList = self.QAArray
                }
                for key in snapdata.keys.sorted(){
                    //snap : 階層下のデータを書くのすいた辞書
                    //今回なら、snap = ["videoname":"///"]
                    let snap = snapdata[key]
                    if let QAStatus = snap!["QAStatus"] as? String {
                        self.QAStatusArray.append(QAStatus)
                    }
                    print("\(self.QAStatusArray)")
                //                self.QAList = self.QAArray
                }
                self.sampleTableView.reloadData()
            }
        }
        )
        refreshControl.endRefreshing()

    }

    //Firebaseからルーム一覧を取得する
    func loadData_Firebase() {
        if QAArray.isEmpty {
        }else{
            QAArray.removeAll()
        }
        print("\(QAArray)")
        //データ取得開始
        ref.child("QA").child("\(uuidText!)").observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
            //snapdata!.keys : 階層
            //key : 階層
                for key in snapdata.keys.sorted(){
                //snap : 階層下のデータを書くのすいた辞書
                //今回なら、snap = ["videoname":"///"]
                    let snap = snapdata[key]
                    if let QAName = snap!["QAName"] as? String {
                    self.QAArray.append(QAName)
                }
                self.QAList = self.QAArray
                }
                for key in snapdata.keys.sorted(){
                //snap : 階層下のデータを書くのすいた辞書
                //今回なら、snap = ["videoname":"///"]
                    let snap = snapdata[key]
                    if let QAStatus = snap!["QAStatus"] as? String {
                    self.QAStatusArray.append(QAStatus)
                }
                    print("\(self.QAStatusArray)")
//                self.QAList = self.QAArray
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
        return QAList.count
    }
    //cellのコンテンツ
    func tableView(_ sampleTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        //cellにはsampleArrayが一つずつ入るようにするよ！
        cell.textLabel?.text = QAList[indexPath.row]
        cell.accessoryView = UIImageView(image:UIImage(named: QAStatusArray[indexPath.row]))
        cell.accessoryView?.frame = CGRect(x:0,y:0,width:60,height:40)
        print("\(QAStatusArray)")
        return cell
    }
    
    //cellが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)番セルが押されたよ！")
        selectedText = QAList[indexPath.row]
        performSegue(withIdentifier: "selectedQAList", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selectedQAList") {
            let selectedQAList: SelectedQAListViewController = segue.destination as! SelectedQAListViewController
            // 11. SecondViewControllerのtextに選択した文字列を設定する
            selectedQAList.text0 = self.selectedText!
            selectedQAList.text1 = self.uuidText!

        }
    }
    @IBAction func doUnwind(segue: UIStoryboardSegue) {}
    
}
