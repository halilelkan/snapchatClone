//
//  snapViewController.swift
//  snapchatClone
//
//  Created by halil ibrahim Elkan on 6.07.2023.
//

import UIKit
import ImageSlideshow
import ImageSlideshowKingfisher

class snapViewController: UIViewController {

    var selectedSnap : Snap?
    var inputArray = [KingfisherSource]()
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let selectedSnap = selectedSnap{
            
            timeLabel.text = String("Kalan Süre :  \(selectedSnap.timeLeft) saat")
            
            for imageUrl in selectedSnap.imageUrlArray{
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.95))
            
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
            pageIndicator.pageIndicatorTintColor = UIColor.black
            imageSlideShow.pageIndicator = pageIndicator
            
            imageSlideShow.backgroundColor = UIColor.clear
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLabel)
        }
        
        
    }
    

}
