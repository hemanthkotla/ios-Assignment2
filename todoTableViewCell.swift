//
//  todoTableViewCell.swift
//  To-do
//
//  Created by Hemanth Kotla on 2019-12-04.
//  Copyright © 2019 Hemanth Kotla. All rights reserved.
//

import UIKit

class todoTableViewCell: UITableViewCell {
    @IBOutlet weak var todoname: UILabel!
    
    @IBOutlet weak var check: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
