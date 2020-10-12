//
//  userListTableViewCell.swift
//  track_online
//
//  Created by 刈田修平 on 2020/10/06.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit

class userListTableViewCell: UITableViewCell {

//    ユーザーリスト
    @IBOutlet var userName: UILabel!
    @IBOutlet var uuid: UILabel!
    @IBOutlet var userStatus: UILabel!
    
//    選択されたユーザーの申請一覧
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var event: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet var ImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
