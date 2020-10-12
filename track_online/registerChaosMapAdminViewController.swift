//
//  registerChaosMapAdminViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/08/08.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class registerChaosMapAdminViewController: UIViewController {

    @IBOutlet weak var ID: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var belong: UITextField!
    @IBOutlet weak var speciality: UITextField!
    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var PB: UITextField!
    @IBOutlet weak var champion: UITextField!
    @IBOutlet weak var top3: UITextField!
    @IBOutlet weak var prize: UITextField!
    @IBOutlet weak var PBrank: UITextField!
    @IBOutlet weak var anteisei: UITextField!
    @IBOutlet weak var bakuhatsuryoku: UITextField!
    @IBOutlet weak var keiken: UITextField!
    @IBOutlet weak var syoubuzuyosa: UITextField!
    
    var selectedID: String?
    var selectedEvent: String?
    var selectedType: String?
    var selectedName: String?
    var selectedBelong: String?
    var selectedPB: String?
    var selectedPrize: String?
    var selectedChampion: String?


    override func viewDidLoad() {
        loadData()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func loadData(){
        ID.text = selectedID
        speciality.text = selectedEvent
        type.text = selectedType
        name.text = selectedName
        belong.text = selectedBelong
        PB.text = selectedPB
        prize.text = selectedPrize
        champion.text = selectedChampion

        let ref = Database.database().reference()
        ref.child("column").child("chaosMap").child("\(selectedEvent!)").child("\(selectedType!)").child("\(selectedID!)").child("RadarChart").child("PBランク").observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["value"] as? String ?? ""
            self.PBrank.text = key
        })
        ref.child("column").child("chaosMap").child("\(selectedEvent!)").child("\(selectedType!)").child("\(selectedID!)").child("RadarChart").child("安定性").observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["value"] as? String ?? ""
            self.anteisei.text = key
        })
        ref.child("column").child("chaosMap").child("\(selectedEvent!)").child("\(selectedType!)").child("\(selectedID!)").child("RadarChart").child("爆発力").observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["value"] as? String ?? ""
            self.bakuhatsuryoku.text = key
        })
        ref.child("column").child("chaosMap").child("\(selectedEvent!)").child("\(selectedType!)").child("\(selectedID!)").child("RadarChart").child("経験").observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["value"] as? String ?? ""
            self.keiken.text = key
        })
        ref.child("column").child("chaosMap").child("\(selectedEvent!)").child("\(selectedType!)").child("\(selectedID!)").child("RadarChart").child("勝負強さ").observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["value"] as? String ?? ""
            self.syoubuzuyosa.text = key
        })
    }
    @IBAction func register(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "確認", message: "登録していいですか？", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.navigationController?.popViewController(animated: true)
            
            let ref1 = Database.database().reference().child("column").child("chaosMap").child("\(self.speciality.text!)").child("\(self.type.text!)").child("\(self.ID.text!)")
            let ref2 = Database.database().reference().child("column").child("chaosMap").child("\(self.speciality.text!)").child("全て").child("\(self.ID.text!)")
            let ref3 = Database.database().reference().child("column").child("chaosMap").child("\(self.speciality.text!)").child("\(self.type.text!)").child("\(self.ID.text!)").child("RadarChart").child("PBランク")
            let ref4 = Database.database().reference().child("column").child("chaosMap").child("\(self.speciality.text!)").child("\(self.type.text!)").child("\(self.ID.text!)").child("RadarChart").child("安定性")
            let ref5 = Database.database().reference().child("column").child("chaosMap").child("\(self.speciality.text!)").child("\(self.type.text!)").child("\(self.ID.text!)").child("RadarChart").child("爆発力")
            let ref6 = Database.database().reference().child("column").child("chaosMap").child("\(self.speciality.text!)").child("\(self.type.text!)").child("\(self.ID.text!)").child("RadarChart").child("経験")
            let ref7 = Database.database().reference().child("column").child("chaosMap").child("\(self.speciality.text!)").child("\(self.type.text!)").child("\(self.ID.text!)").child("RadarChart").child("勝負強さ")
            let data = ["ID":"\(self.ID.text!)",
                "name":"\(self.name.text!)","belong":"\(self.belong.text!)","speciality":"\(self.speciality.text!)","type":"\(self.type.text!)","PB":"\(self.PB.text!)","champion":"\(self.champion.text!)","top3":"\(self.top3.text!)","prize":"\(self.prize.text!)" as Any
                ] as [String : Any]
            let data3 = ["subject":"PBランク","value":"\(self.PBrank.text!)"] as [String : Any]
            let data4 = ["subject":"安定性","value":"\(self.anteisei.text!)"] as [String : Any]
            let data5 = ["subject":"爆発力","value":"\(self.bakuhatsuryoku.text!)"] as [String : Any]
            let data6 = ["subject":"経験","value":"\(self.keiken.text!)"] as [String : Any]
            let data7 = ["subject":"勝負強さ","value":"\(self.syoubuzuyosa.text!)"] as [String : Any]
            ref1.updateChildValues(data)
            ref2.updateChildValues(data)
            ref3.updateChildValues(data3)
            ref4.updateChildValues(data4)
            ref5.updateChildValues(data5)
            ref6.updateChildValues(data6)
            ref7.updateChildValues(data7)

        }
        )
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
        
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
