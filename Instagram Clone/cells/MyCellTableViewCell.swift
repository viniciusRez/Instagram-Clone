//
//  MyCellTableViewCell.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 18/01/23.
//

import UIKit

class MyCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet var load: UIActivityIndicatorView!
    @IBOutlet var descricao: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
