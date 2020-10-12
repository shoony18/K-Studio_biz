//
//  premiumUserListViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/10/06.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class premiumUserListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var TableView: UITableView!
    var uuidArray = [String]()
    var userNameArray = [String]()
    var userStatusArray = [String]()
    var uuidArray_re = [String]()
    var userNameArray_re = [String]()
    var userStatusArray_re = [String]()
    let Ref = Database.database().reference()
    var selectedUid: String?

    override func viewDidLoad() {
        TableView.dataSource = self
        TableView.delegate = self
        loadData()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func loadData() {
        uuidArray.removeAll()
        userNameArray.removeAll()
        //データ取得開始
        Ref.child("purchase").child("premium").child("userList").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["uuid"] as? String {
                        self.uuidArray.append(data)
                        self.uuidArray_re = self.uuidArray
                        print(self.uuidArray_re)
                        self.TableView.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["userName"] as? String {
                        self.userNameArray.append(data)
                        self.userNameArray_re = self.userNameArray
                        print(self.userNameArray_re)
                        self.TableView.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["status"] as? String {
                        self.userStatusArray.append(data)
                        self.userStatusArray_re = self.userStatusArray
                        self.TableView.reloadData()
                    }
                }
            }
            }
        )
    }
        //セクション数を指定
    func numberOfSections(in TableView: UITableView) -> Int {
        return 1
    }
    //表示するcellの数を指定
    func tableView(_ TableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uuidArray_re.count
    }

    //cellのコンテンツ
    func tableView(_ TableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.TableView.dequeueReusableCell(withIdentifier: "cellAllUser", for: indexPath as IndexPath) as? userListTableViewCell
            //cellにはsampleArrayが一つずつ入るようにするよ！
        cell?.userName.text = userNameArray_re[indexPath.row]
        cell?.uuid.text = uuidArray_re[indexPath.row]
        if userStatusArray_re[indexPath.row] == "1"{
            cell?.userStatus.text = "●"
        }else{
            cell?.userStatus.text = ""
        }
        
            return cell!
    }
        
    //cellが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUid = uuidArray_re[indexPath.row]
        performSegue(withIdentifier: "selectedUid", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selectedUid") {
            let data: premiumSelectedUserViewController = segue.destination as!
            premiumSelectedUserViewController
                // 11. SecondViewControllerのtextに選択した文字列を設定する
            data.selectedUid = self.selectedUid!
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
