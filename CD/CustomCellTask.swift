//
//  CustomCellTask.swift
//  CD
//
//  Created by Константин Козлов on 29.10.2021.
//

import UIKit

class CustomCellTask: UITableViewCell {


    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var lableCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //flagImageView.image = nil
    }
    
    func setupFlag(image: UIImage) {
        flagImageView.image = image
    }
    
}
