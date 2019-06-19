//
//  ChatNameListTVCell.swift
//  TestChatApp
//
//  Created by Creator-$ on 6/19/19.
//  Copyright © 2019 tiwariammit@mail.com. All rights reserved.
//

import UIKit

class ChatNameListTVCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.itemImageView.layer.cornerRadius = self.itemImageView.frame.height/2
        self.itemImageView.layer.masksToBounds = true
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func cellConfigiration(_ data : [String: String], index : Int){
        let keys = Array(data.keys)
        let values = Array(data.values)

        self.lblName.text = keys[index]
        self.lblMessage.text = values[index]

    }
}
