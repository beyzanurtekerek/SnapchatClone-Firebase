//
//  FeedCell.swift
//  SnapchatClone
//
//  Created by Beyza Nur Tekerek on 27.09.2024.
//

import UIKit

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var feedUsernameLabel: UILabel!
    
    @IBOutlet weak var feedImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
