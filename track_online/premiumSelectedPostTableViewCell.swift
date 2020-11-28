//
//  premiumSelectedPostTableViewCell.swift
//  track_online
//
//  Created by 刈田修平 on 2020/10/06.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit

class premiumSelectedPostTableViewCell: UITableViewCell {

    @IBOutlet var userName: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var height: UILabel!
    @IBOutlet var weight: UILabel!
    @IBOutlet var event: UILabel!
    @IBOutlet var PB: UILabel!
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var playVideo: UIButton!
    @IBOutlet var titleLabel1: UILabel!
    @IBOutlet var titleLabel2: UILabel!
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var comment: UILabel!
    @IBOutlet var addTag: UIButton!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var sendAnswer: UIButton!
    @IBOutlet var addComment: UIButton!
    @IBOutlet var recommendTrainigLabel: UILabel!
    @IBOutlet var adviseText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
