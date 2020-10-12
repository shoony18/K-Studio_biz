//
//  chaosMapAdminTableViewCell.swift
//  track_online
//
//  Created by 刈田修平 on 2020/08/10.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit

class chaosMapAdminTableViewCell: UITableViewCell {

    @IBOutlet weak var event: UILabel!
    @IBOutlet weak var ID: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
