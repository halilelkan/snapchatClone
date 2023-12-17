//
//  FeedTableViewCell.swift
//  snapchatClone
//
//  Created by halil ibrahim Elkan on 9.07.2023.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var snapImageView: UIImageView!
    @IBOutlet weak var snapUserNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
