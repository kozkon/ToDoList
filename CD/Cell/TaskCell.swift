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
    @IBOutlet weak var imageOfCell: UIImageView!

    
    func setupCell(image: UIImage, text: String, dateText: Date, imageOfTask: Data) {
        flagImageView.image = image
        titleLabel.text = text
        imageOfCell.image = UIImage(data: imageOfTask)
        imageOfCell.layer.cornerRadius = imageOfCell.frame.height / 5
        imageOfCell.clipsToBounds = true
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm"
        let dateTextToLabel = df.string(from: dateText)
        dateLabel.text = "Саздано: \(dateTextToLabel)"
    }
}
