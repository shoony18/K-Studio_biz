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

class premiumTagRegisterViewController: UIViewController {

    let Ref = Database.database().reference()
    @IBOutlet var tagGenre: UILabel!
    @IBOutlet var tagID: UILabel!
    @IBOutlet var tagName: UILabel!
    @IBOutlet var cause: UILabel!
    @IBOutlet var practice: UILabel!
    @IBOutlet var comment: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func register(_ sender: Any) {
        let ref = Ref.child("purchase").child("premium").child("answer").child("parameter").child("\(self.tagGenre.text!)").child("all").child("\(self.tagID.text!)")
        let data = ["tagID":"\(self.tagID.text!)","tagName":"\(self.tagName.text!)","cause":"\(self.cause.text!)","comment":"\(self.comment.text!)","menu":"\(self.practice.text!)"]
        ref.setValue(data)
        tagID.text = ""
        tagName.text = ""
        cause.text = ""
        practice.text = ""
        comment.text = ""
    }
    

}
