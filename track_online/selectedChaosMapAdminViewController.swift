//
//  selectedChaosMapAdminViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/08/10.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class selectedChaosMapAdminViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    var nameArray = [String]()
    var IDArray = [String]()
    var typeArray = [String]()
    var belongArray = [String]()
    var PBArray = [String]()
    var prizeArray = [String]()
    var championArray = [String]()

    var selectedEvent: String?
    var selectedID: String?
    var selectedType: String?
    var selectedName: String?
    var selectedBelong: String?
    var selectedPB: String?
    var selectedPrize: String?
    var selectedChampion: String?


    @IBOutlet weak var selectedChaosMapAdminTableView: UITableView!
    override func viewDidLoad() {
        
        loadData()
        selectedChaosMapAdminTableView.dataSource = self
        selectedChaosMapAdminTableView.delegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
       
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
               

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.selectedChaosMapAdminTableView.dequeueReusableCell(withIdentifier: "selectedChaosMapAdmin", for: indexPath as IndexPath) as? chaosMapAdminTableViewCell
        cell!.name.text = nameArray[indexPath.row]
        cell!.ID.text = IDArray[indexPath.row]
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedID = IDArray[indexPath.row]
        selectedType = typeArray[indexPath.row]
        selectedName = nameArray[indexPath.row]
        selectedBelong = belongArray[indexPath.row]
        selectedPB = PBArray[indexPath.row]
        selectedPrize = prizeArray[indexPath.row]
        selectedChampion = championArray[indexPath.row]
        performSegue(withIdentifier: "registerForm", sender: nil)
    }
               
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "registerForm") {
            if #available(iOS 13.0, *) {
                let selectedView: registerChaosMapAdminViewController = segue.destination as! registerChaosMapAdminViewController
                selectedView.selectedID = self.selectedID!
                selectedView.selectedEvent = self.selectedEvent!
                selectedView.selectedType = self.selectedType!
                selectedView.selectedName = self.selectedName!
                selectedView.selectedBelong = self.selectedBelong!
                selectedView.selectedPB = self.selectedPB!
                selectedView.selectedPrize = self.selectedPrize!
                selectedView.selectedChampion = self.selectedChampion!
            } else {
            }
        }
    }
        
    func loadData(){
            let ref = Database.database().reference()
            ref.child("column").child("chaosMap").child("\(selectedEvent!)").child("全て").observeSingleEvent(of: .value, with: {(snapshot) in
                if let snapdata = snapshot.value as? [String:NSDictionary]{
                    for key in snapdata.keys.sorted(){
                        let snap = snapdata[key]
                        if let data = snap!["ID"] as? String {
                            self.IDArray.append(data)
                        }
                        self.selectedChaosMapAdminTableView.reloadData()
                    }
                    for key in snapdata.keys.sorted(){
                        let snap = snapdata[key]
                        if let data = snap!["name"] as? String {
                            self.nameArray.append(data)
                        }
                        self.selectedChaosMapAdminTableView.reloadData()
                    }
                    for key in snapdata.keys.sorted(){
                        let snap = snapdata[key]
                        if let data = snap!["type"] as? String {
                            self.typeArray.append(data)
                        }
                        self.selectedChaosMapAdminTableView.reloadData()
                    }
                    for key in snapdata.keys.sorted(){
                        let snap = snapdata[key]
                        if let data = snap!["belong"] as? String {
                            self.belongArray.append(data)
                        }
                        self.selectedChaosMapAdminTableView.reloadData()
                    }
                    for key in snapdata.keys.sorted(){
                        let snap = snapdata[key]
                        if let data = snap!["PB"] as? String {
                            self.PBArray.append(data)
                        }
                        self.selectedChaosMapAdminTableView.reloadData()
                    }
                    for key in snapdata.keys.sorted(){
                        let snap = snapdata[key]
                        if let data = snap!["prize"] as? String {
                            self.prizeArray.append(data)
                        }
                        self.selectedChaosMapAdminTableView.reloadData()
                    }
                    for key in snapdata.keys.sorted(){
                        let snap = snapdata[key]
                        if let data = snap!["champion"] as? String {
                            self.championArray.append(data)
                        }
                        self.selectedChaosMapAdminTableView.reloadData()
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
