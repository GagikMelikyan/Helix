//
//  ItemTableViewCell.swift
//  HelixTask
//
//  Created by G.M on 13.05.21.
//

import UIKit
import SDWebImage

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 10
        mainView.layer.borderWidth = 2
        mainView.layer.borderColor = #colorLiteral(red: 1, green: 0, blue: 0.2479857206, alpha: 1).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            mainView.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).cgColor
        } else{
            mainView.layer.borderColor = #colorLiteral(red: 1, green: 0, blue: 0.2479857206, alpha: 1).cgColor
        }
    }
    
    func updateInfo(item: Item) {
        titleLabel.text = item.title
        categoryLabel.text = item.category
        dateLabel.text = String(item.date.getDateStringFromUTC())
        imgView.sd_setImage(with: URL(string: item.coverPhotoUrl), placeholderImage: UIImage(named: "logo"), context: [.imageThumbnailPixelSize : imgView.bounds.size])
    }
    
}
