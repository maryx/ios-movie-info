//
//  MovieCell.swift
//  MovieInfo
//
//  Created by Mary Xia on 8/30/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
