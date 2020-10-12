//
//  QATableViewCell.swift
//  track_online
//
//  Created by 刈田修平 on 2020/07/04.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit

class QATableViewCell: UITableViewCell {
    @IBOutlet weak var QAContent1: UILabel!
    @IBOutlet weak var date1: UILabel!
    @IBOutlet weak var time1: UILabel!
    @IBOutlet weak var QASpeciality1: UILabel!
    @IBOutlet weak var TextFieldGenre1: UILabel!
    @IBOutlet weak var userName1: UILabel!
    @IBOutlet weak var countAnswer1: UILabel!

    @IBOutlet weak var userNameAnswer2_2_2: UILabel!
    @IBOutlet weak var answer2_2_2: UILabel!
    @IBOutlet weak var sankouURL2_2_2: UITextView!
    @IBOutlet weak var date2_2_2: UILabel!
    @IBOutlet weak var time2_2_2: UILabel!
    @IBOutlet weak var goodButton2_2_2: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
