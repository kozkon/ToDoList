//
//  TaskCell.swift
//  CD
//
//  Created by Константин Козлов on 04.11.2021.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
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
    
    func setupCell(image: UIImage, text: String, dateText: Date) {
        flagImageView.image = image
        titleLabel.text = text
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm"
        let dateTextToLabel = df.string(from: dateText)
        dateLabel.text = "Саздано: \(dateTextToLabel)"
    }
}
