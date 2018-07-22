//
//  NextDaysWeatherTableViewCell.swift
//  ProjectForNeyasis
//
//  Created by inan on 20.07.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit

class NextDaysWeatherTableViewCell: UITableViewCell {
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var nextDaysTemLabel: UILabel!
  
  @IBOutlet weak var nextDaysLabel: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
    iconImageView.layer.cornerRadius = iconImageView.frame.height / 2.0
    iconImageView.layer.masksToBounds = true
    
    
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
