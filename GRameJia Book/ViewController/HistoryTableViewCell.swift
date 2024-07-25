//
//  HistoryTableViewCell.swift
//  GRameJia Book
//
//  Created by prk on 7/25/24.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var bookImage: UIImageView!

    @IBOutlet weak var bookTitle: UILabel!
    
    @IBOutlet weak var bookAuthor: UILabel!
    
    @IBOutlet weak var bookPublisher: UILabel!
    
    @IBOutlet weak var bookPrice: UILabel!
    
}
