//
//  FullScreenImageView.swift
//  HelixTask
//
//  Created by G.M on 16.05.21.
//

import UIKit

class FullScreenImageView: UIView {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let nibName = FullScreenImageView.id
    private var imageUrl: String?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
        
    //MARK: - Set data
    
    func setImage(imageURL: String, title: String)  {
        titleLabel.text = title
        imgView.sd_setImage(with: URL(string: imageURL), completed: .none)
    }
    
    //MARK: - Close View

    @IBAction func closeView(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
}
