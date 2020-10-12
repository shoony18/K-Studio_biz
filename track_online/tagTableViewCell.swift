//
//  tagTableViewCell.swift
//  track_online
//
//  Created by 刈田修平 on 2020/10/11.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit

class tagTableViewCell: UITableViewCell {

    @IBOutlet var tagID: UILabel!
    @IBOutlet var tagName: UILabel!
    @IBOutlet var cause: UILabel!
    @IBOutlet var comment: UILabel!
    @IBOutlet var practice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
