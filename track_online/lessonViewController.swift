//
//  lessonViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2019/10/02.
//  Copyright © 2019年 刈田修平. All rights reserved.
//

import UIKit
import FirebaseDatabase

class lessonViewController: UIViewController,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate {

    var currentTextField = UITextField()
    var pickerview = UIPickerView()
    
    var selectedAge:[String] = []
    var selectedSex:[String] = []
    var selectedGenre:[String] = []
    
    @IBOutlet weak var textValidateAge: UILabel!
    @IBOutlet weak var textValidateSex: UILabel!
    @IBOutlet weak var textValidateGenre: UILabel!
    

    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedAge = ["","7","8","9","10","11","12","13","14","15","16","17","18"]
        selectedSex = ["","男","女","非公開"]
        selectedGenre = ["","短距離","中距離","長距離","跳躍","投擲","混成","その他"]
        textValidateAge.isHidden = true
        textValidateSex.isHidden = true
        textValidateGenre.isHidden = true
        
        pickerview.delegate = self
        pickerview.dataSource = self
        pickerview.showsSelectionIndicator = true
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定
        textField1.inputView = pickerview
        textField2.inputView = pickerview
        textField3.inputView = pickerview
        textField1.inputAccessoryView = toolbar
        textField2.inputAccessoryView = toolbar
        textField3.inputAccessoryView = toolbar
        // Do any additional setup after loading the view.
    }
    @objc func done() {
        if currentTextField == textField1 {
            textField1.endEditing(true)
            textField1.text = "\(selectedAge[pickerview.selectedRow(inComponent: 0)])"
        } else if currentTextField == textField2 {
            textField2.endEditing(true)
            textField2.text = "\(selectedSex[pickerview.selectedRow(inComponent: 0)])"
        } else if currentTextField == textField3 {
            textField3.endEditing(true)
            textField3.text = "\(selectedGenre[pickerview.selectedRow(inComponent: 0)])"
        }
    }
    @IBAction func ButtonTouchDown(_ sender: Any) {
        textValidateAge.isHidden = true
        textValidateSex.isHidden = true
        textValidateGenre.isHidden = true
        if textField1.text?.count == 0 {
            textValidateAge.isHidden = false
            textValidateAge.text = "年齢を選択してください"
            return
        }
        if textField2.text?.count == 0 {
            textValidateSex.isHidden = false
            textValidateSex.text = "性別を選択してください"
            return
        }
        if textField3.text?.count == 0 {
            textValidateGenre.isHidden = false
            textValidateGenre.text = "専門を選択してください"
            return
        }

        let postRef = Database.database().reference().child("posts").childByAutoId()
        let postObject = [
            "age":textField1.text as Any,
            "sex":textField2.text  as Any,
            "genre":textField3.text as Any,
            "timestamp":[".sv":"timestamp"]
        ]as[String:Any]
        
        postRef.setValue(postObject, withCompletionBlock:{error,ref in
            if error == nil{
                self.dismiss(animated: true, completion: nil)
            }else{
            }
        })
        
        let now = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy:MM:dd:HH:mm:ss"
        let timenow = formatter.string(from: now as Date)
        
        let sendAge = textField1.text!
        let timenowURL:String = "line://oaMessage/@981dnckd/\(timenow)\(sendAge)"

        let url = URL(string: timenowURL)!
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in
                    print("Open \(success)")
                })
            }else{
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == textField1 {
            return selectedAge.count
        } else if currentTextField == textField2 {
            return selectedSex.count
        } else if currentTextField == textField3 {
            return selectedGenre.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == textField1 {
            return selectedAge[row]
        } else if currentTextField == textField2 {
            return selectedSex[row]
        } else if currentTextField == textField3 {
            return selectedGenre[row]
        } else {
            return ""
        }
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if currentTextField == textField1{
//            textField1.text = selectedAge[row]
//            self.view.endEditing(true)
//        }else if currentTextField == textField2{
//            textField2.text = selectedSex[row]
//            self.view.endEditing(true)
//        }else{
//            textField3.text = selectedGenre[row]
//            self.view.endEditing(true)
//        }
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerview.delegate = self
        self.pickerview.dataSource = self
        currentTextField = textField
        if currentTextField == textField1{
            currentTextField.inputView = pickerview
        }else if currentTextField == textField2{
            currentTextField.inputView = pickerview
        }else{
            currentTextField.inputView = pickerview
        }
    }

//    func createPickerview1(){
//        let pickerview1 = UIPickerView()
//        pickerview1.delegate = self
//        textField1.inputView = pickerview1
//    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
