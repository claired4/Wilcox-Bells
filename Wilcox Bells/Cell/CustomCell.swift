//
//  CustomCell.swift
//  Wilcox Bells
//
//  Created by Claire Dong on 8/31/18.
//  Copyright © 2018 Wilcox High School. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    } 

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customInit(period: String, time: String) {
        self.periodLabel.text = period
        self.timeLabel.text = time
    }
    
}
