//
//  chaosMapAdminTopViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/08/10.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class chaosMapAdminTopViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    var eventNameArray = [String]()
    var selectedText: String?

    @IBOutlet weak var chaosMapAdminTopTableView: UITableView!
    
    override func viewDidLoad() {
        loadData()
        chaosMapAdminTopTableView.dataSource = self
        chaosMapAdminTopTableView.delegate = self

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
               
            //表示するcellの数を指定
           
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventNameArray.count
    }
               
            //cellのコンテンツ
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.chaosMapAdminTopTableView.dequeueReusableCell(withIdentifier: "chaosMapAdminTop", for: indexPath as IndexPath) as? chaosMapAdminTableViewCell
        cell!.event.text = eventNameArray[indexPath.row]
        
        return cell!
    }
    
    //cellが選択された時の処理
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedText = eventNameArray[indexPath.row]
        performSegue(withIdentifier: "selectedChaosMap", sender: nil)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selectedChaosMap") {
            if #available(iOS 13.0, *) {
                let selectedView: selectedChaosMapAdminViewController = segue.destination as! selectedChaosMapAdminViewController
                selectedView.selectedEvent = self.selectedText!
            } else {
                            // Fallback on earlier versions
            }
        }
    }
       
    func loadData(){
        let ref = Database.database().reference()
        ref.child("column").child("chaosMap").child("event").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["name"] as? String {
                        self.eventNameArray.append(data)
                    }
                    self.chaosMapAdminTopTableView.reloadData()
                }
            }
        })
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
