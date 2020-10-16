//
//  premiumTagRegisterViewController.swift
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

class premiumTagRegisterViewController: UIViewController,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate {

    var pickerview: UIPickerView = UIPickerView()
    var currentTextField = UITextField()

    var selectedTagGenreArray = [String]()
    var selectedPracticeIDArray = [String]()
    var selectedPracticeArray = [String]()

    var practiceIDArray = [String]()
    var practiceArray = [String]()
    var practiceIDArray_re = [String]()
    var practiceArray_re = [String]()
    
    var practiceID1: String?
    var practiceID2: String?
    var practiceID3: String?

    var number1: Int?
    var number2: Int?
    var number3: Int?

    let Ref = Database.database().reference()
    @IBOutlet var tagGenre: UITextField!
    @IBOutlet var tagName: UITextField!
    @IBOutlet var motionType: UITextField!
    @IBOutlet var bodyParts: UITextField!
    @IBOutlet var cause: UITextField!
    @IBOutlet var practice1: UITextField!
    @IBOutlet var practice2: UITextField!
    @IBOutlet var practice3: UITextField!
    @IBOutlet var comment: UITextView!
    
    
    override func viewDidLoad() {
        pickerView()
        textView()
        loadData()
        super.viewDidLoad()
    }
    
    @IBAction func inputTagName(_ sender: Any) {
        tagName.text = (sender as AnyObject).text
    }
    
    @IBAction func inputMotionType(_ sender: Any) {
        motionType.text = (sender as AnyObject).text
    }
    @IBAction func inputBodyParts(_ sender: Any) {
        bodyParts.text = (sender as AnyObject).text
    }
    @IBAction func inputCause(_ sender: Any) {
        cause.text = (sender as AnyObject).text
    }
    @IBAction func inputPractice1(_ sender: Any) {
        practice1.text = (sender as AnyObject).text
    }
    @IBAction func inputPractice2(_ sender: Any) {
        practice2.text = (sender as AnyObject).text
    }
    @IBAction func inputPractice3(_ sender: Any) {
        practice3.text = (sender as AnyObject).text
    }
    
    func pickerView(){
        selectedTagGenreArray = ["goodTag","badTag"]
        
        pickerview.delegate = self
        pickerview.dataSource = self
        pickerview.showsSelectionIndicator = true
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        tagGenre.inputView = pickerview
        tagGenre.inputAccessoryView = toolbar
        practice1.inputView = pickerview
        practice1.inputAccessoryView = toolbar
        practice2.inputView = pickerview
        practice2.inputAccessoryView = toolbar
        practice3.inputView = pickerview
        practice3.inputAccessoryView = toolbar
    }
    func textView(){
        let toolbar0 = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spacelItem0 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem0 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done0))
        toolbar0.setItems([spacelItem0, doneItem0], animated: true)

        comment.inputAccessoryView = toolbar0
    }
    
    @objc func done() {
        selectedPracticeArray.removeAll()
        selectedPracticeIDArray.removeAll()
        print(pickerview.selectedRow(inComponent: 0))
        if currentTextField == tagGenre{
            tagGenre.endEditing(true)
            tagGenre.text = "\(selectedTagGenreArray[pickerview.selectedRow(inComponent: 0)])"
            return
        }else if currentTextField == practice1{
            practice1.endEditing(true)
            practice1.text = "\(practiceArray_re[pickerview.selectedRow(inComponent: 0)])"
            self.number1 = pickerview.selectedRow(inComponent: 0)
        }else if currentTextField == practice2{
            practice2.endEditing(true)
            practice2.text = "\(practiceArray_re[pickerview.selectedRow(inComponent: 0)])"
            self.number2 = pickerview.selectedRow(inComponent: 0)
        }else if currentTextField == practice3{
            practice3.endEditing(true)
            practice3.text = "\(practiceArray_re[pickerview.selectedRow(inComponent: 0)])"
            self.number3 = pickerview.selectedRow(inComponent: 0)
        }
        if self.number2 == nil{
            selectedPracticeArray.append(practiceArray_re[self.number1!])
            selectedPracticeIDArray.append(practiceIDArray_re[self.number1!])
        }else if self.number3 == nil{
            selectedPracticeArray.append(practiceArray_re[self.number1!])
            selectedPracticeIDArray.append(practiceIDArray_re[self.number1!])
            selectedPracticeArray.append(practiceArray_re[self.number2!])
            selectedPracticeIDArray.append(practiceIDArray_re[self.number2!])
        }else{
            selectedPracticeArray.append(practiceArray_re[self.number1!])
            selectedPracticeIDArray.append(practiceIDArray_re[self.number1!])
            selectedPracticeArray.append(practiceArray_re[self.number2!])
            selectedPracticeIDArray.append(practiceIDArray_re[self.number2!])
            selectedPracticeArray.append(practiceArray_re[self.number3!])
            selectedPracticeIDArray.append(practiceIDArray_re[self.number3!])
        }
        print(selectedPracticeArray)
    }
    @objc func done0() {
        self.view.endEditing(true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == tagGenre{
            return selectedTagGenreArray.count
        }else if currentTextField == practice1{
            return practiceArray_re.count
        }else if currentTextField == practice2{
            return practiceArray_re.count
        }else if currentTextField == practice3{
            return practiceArray_re.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == tagGenre{
            return selectedTagGenreArray[row]
        }else if currentTextField == practice1{
            return practiceArray_re[row]
        }else if currentTextField == practice2{
            return practiceArray_re[row]
        }else if currentTextField == practice3{
            return practiceArray_re[row]
        } else {
            return ""
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerview.delegate = self
        self.pickerview.dataSource = self
        currentTextField = textField
        if currentTextField == tagGenre{
            currentTextField.inputView = pickerview
        }else if currentTextField == practice1{
            currentTextField.inputView = pickerview
        }else if currentTextField == practice2{
            currentTextField.inputView = pickerview
        }else if currentTextField == practice3{
            currentTextField.inputView = pickerview
        } else {
        }
    }

    func loadData(){
        let ref = self.Ref.child("purchase").child("premium").child("answer").child("parameter").child("practice").child("all")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["practice"] as? String {
                        self.practiceArray.append(data)
                        self.practiceArray_re = self.practiceArray
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["practiceID"] as? String {
                        self.practiceIDArray.append(data)
                        self.practiceIDArray_re = self.practiceIDArray
                    }
                }
            }
            }
        )
    }
    @IBAction func register(_ sender: Any) {
        
        let now = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let timenow = formatter.string(from: now as Date)
        let date1 = Date()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        let date = formatter1.string(from: date1)
        let date2 = Date()
        let formatter2 = DateFormatter()
        formatter2.setLocalizedDateFormatFromTemplate("jm")
        let time = formatter2.string(from: date2)
        let alert: UIAlertController = UIAlertController(title: "確認", message: "この内容で送信します。一度送信すると内容を修正できません。よろしいですか？", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            let ref0 = self.Ref.child("purchase").child("premium").child("answer").child("parameter").child("\(self.tagGenre.text!)").child("all").child("\(self.tagGenre.text!)"+"_"+"\(timenow)")
            let data0 = ["tagID":"\(self.tagGenre.text!)"+"_"+"\(timenow)","tagName":"\(self.tagName.text!)","motionType":"\(self.motionType.text!)","bodyParts":"\(self.bodyParts.text!)","cause":"\(self.cause.text!)","comment":"\(self.comment.text!)","practice":"\(self.practice1.text!)"+"/"+"\(self.practice2.text!)"+"/"+"\(self.practice3.text!)"]
            ref0.setValue(data0)

            if self.tagGenre.text == "badTag"{
                for key in 0...self.selectedPracticeIDArray.count-1{
                    let ref1 = self.Ref.child("purchase").child("premium").child("answer").child("parameter").child("\(self.tagGenre.text!)").child("all").child("\(self.tagGenre.text!)"+"_"+"\(timenow)").child("practice").child("\(self.selectedPracticeIDArray[key])")
                    let data1 = ["practiceID":"\(self.selectedPracticeIDArray[key])","practice":"\(self.selectedPracticeArray[key])"]
                    ref1.setValue(data1)
                }
            }
            self.tagGenre.text = ""
            self.tagName.text = ""
            self.motionType.text = ""
            self.bodyParts.text = ""
            self.cause.text = ""
            self.comment.text = ""
            self.practice1.text = ""
            self.practice2.text = ""
            self.practice3.text = ""

        })

        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })

            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        
    }

}
