//
//  CentralTableViewCell.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 2/15/23.
//

import UIKit

class CentralTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var journalEntry: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

