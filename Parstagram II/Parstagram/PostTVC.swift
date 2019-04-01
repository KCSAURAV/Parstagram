//
//  PostTVC.swift
//  Parstagram
//
//  Created by SAURAV on 3/23/19.
//  Copyright © 2019 SAURAV. All rights reserved.
//

import UIKit

class PostTVC: UITableViewCell {

  @IBOutlet weak var photo: UIImageView!
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var caption: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
