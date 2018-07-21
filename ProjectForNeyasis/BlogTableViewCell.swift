//
//  BlogTableViewCell.swift
//  ProjectForNeyasis
//
//  Created by inan on 21.07.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit

class BlogTableViewCell: UITableViewCell {
  @IBOutlet weak var blogTitle: UILabel!
  @IBOutlet weak var blogImageView: UIImageView!
  
  @IBOutlet weak var blogNews: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
    blogImageView.image = nil
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
