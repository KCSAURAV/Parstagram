//
//  CommentTVC.swift
//  Parstagram
//
//  Created by SAURAV on 3/30/19.
//  Copyright © 2019 SAURAV. All rights reserved.
//

import UIKit

class CommentTVC: UITableViewCell {

  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var comment: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
