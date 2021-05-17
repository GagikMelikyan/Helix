//
//  GalleryCollectionViewCell.swift
//  HelixTask
//
//  Created by G.M on 16.05.21.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 5
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1).cgColor
    }
    
    func updateInfo(itemGallery: ItemGallery) {
        titleLabel.text = itemGallery.title
        imgView.sd_setImage(with: URL(string: itemGallery.thumbnailUrl), completed: .none)
    }
}
