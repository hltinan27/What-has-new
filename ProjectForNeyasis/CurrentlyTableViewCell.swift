//
//  CurrentlyTableViewCell.swift
//  ProjectForNeyasis
//
//  Created by inan on 20.07.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit

class CurrentlyTableViewCell: UITableViewCell {
  @IBOutlet weak var temLabel: UILabel!
  
  @IBOutlet weak var IconImageView: UIImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    IconImageView.layer.cornerRadius = IconImageView.frame.height / 2.0
    IconImageView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
