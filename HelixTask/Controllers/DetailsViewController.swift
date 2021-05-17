//
//  DetailsViewController.swift
//  HelixTask
//
//  Created by G.M on 13.05.21.
//

import UIKit
import SDWebImage

final class DetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK:- Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var galleryViewHeight: NSLayoutConstraint!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    
    //MARK:- Variables & Constants
    let readmoreFont = UIFont(name: "Helvetica-Oblique", size: 12.0)!
    
    var item: Item?
    private var expandableTextRange: NSRange?
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        configureView()
    }
    
    //MARK:- Configure View
    
    private func configureView() {
        guard let item = item else { return }
        titleLabel.text = item.title
        imgView.sd_setImage(with: URL(string: item.coverPhotoUrl), completed: .none)
        categoryLabel.text = item.category
        dateLabel.text = item.date.getDateStringFromUTC()
        
        bodyLabel.attributedText = item.body.htmlAttributedString()
        
        if bodyLabel.text!.count > 100 {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.showMoreOrLess))
            bodyLabel.isUserInteractionEnabled = true
            bodyLabel.addGestureRecognizer(tap)
            bodyLabel.addTrailing(with: "... ", moreText: "Read More", moreTextFont: readmoreFont, moreTextColor: UIColor.blue)
        }
        
        //configure gallery
        if item.gallery != nil {
            configureGallery()
        } else {
            galleryButton.isHidden = true
        }
        
        //configure Video
        if item.video != nil {
            configureVideo()
        } else {
            videoButton.isHidden = true
        }
    }
    
    // show More & less text
    @objc func showMoreOrLess(sender: UITapGestureRecognizer) {
        if bodyLabel.numberOfLines == 0 {
            bodyLabel.numberOfLines = 3
            if bodyLabel.text!.count > 100 {
                bodyLabel.addTrailing(with: "... ", moreText: "Read More", moreTextFont: readmoreFont, moreTextColor: UIColor.blue)
            }
        } else {
            bodyLabel.numberOfLines = 0
            let attributes: [NSAttributedString.Key: Any] = [
                .font: readmoreFont,
                .foregroundColor: UIColor.blue,
            ]
            let attributedBody = item?.body.htmlAttributedString() ?? NSAttributedString(string: "\(String(describing: item?.body))", attributes: [:])
            let attributedLessText = NSAttributedString(string: " Show Less", attributes: attributes)
            let mutableAttributedString = NSMutableAttributedString()
            mutableAttributedString.append(attributedBody)
            mutableAttributedString.append(attributedLessText)
            bodyLabel.attributedText = mutableAttributedString
        }
    }
    
    
    private func configureGallery() {
        galleryCollectionView.registerCells(names: [GalleryCollectionViewCell.id])
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
    }
    
    
    private func configureVideo() {
        videoCollectionView.registerCells(names: [VideoCollectionViewCell.id])
        videoCollectionView.delegate = self
        videoCollectionView.dataSource = self
    }
    
    
    //MARK:- Actions
    
    @IBAction func galleryTaped(_ sender: Any) {
        if galleryView.isHidden {
            galleryView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.galleryViewHeight.constant = 250
                self.view.layoutIfNeeded()
                self.scrollToBottom()
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.galleryViewHeight.constant = 0
                self.view.layoutIfNeeded()
            } completion: { bool in
                if bool {
                    self.galleryView.isHidden = true
                }
            }
        }
    }
    
    @IBAction func videoTaped(_ sender: UIButton) {
        if videoView.isHidden {
            UIView.animate(withDuration: 0.5) {
                self.videoView.isHidden = false
                self.videoViewHeight.constant = 250
                self.view.layoutIfNeeded()
                self.scrollToBottom()
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.videoViewHeight.constant = 0
                self.view.layoutIfNeeded()
            } completion: { bool in
                if bool {
                    self.videoView.isHidden = true
                }
            }
        }
    }
    
    private func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    //MARK:- CollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case galleryCollectionView:
            return item?.gallery?.count ?? 0
        case videoCollectionView:
            return item?.video?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case galleryCollectionView:
            let cell = galleryCollectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.id, for: indexPath) as! GalleryCollectionViewCell
            cell.updateInfo(itemGallery: (item?.gallery?[indexPath.row])!)
            return cell
        case videoCollectionView:
            let cell = videoCollectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.id, for: indexPath) as! VideoCollectionViewCell
            cell.updateInfo(itemVideo: (item?.video?[indexPath.row])!)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    //MARK:- CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case galleryCollectionView:
            guard let imagePath = item?.gallery?[indexPath.row].contentUrl else { return }
            let fullScreenImageView = FullScreenImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            fullScreenImageView.setImage(imageURL: imagePath, title: (item?.gallery?[indexPath.row].title)!)
            self.view.addSubview(fullScreenImageView)
        case videoCollectionView:
            let youtubeId = "\((item?.video?[indexPath.row].youtubeId)!))"
            var url = URL(string:"youtube://\(youtubeId)")!
            if !UIApplication.shared.canOpenURL(url)  {
                url = URL(string:"http://www.youtube.com/watch?v=\(youtubeId)")!
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        default:
            return
        }
    }
    
}
