//
//  StackView.swift
//  Projet 5
//
//  Created by Amg on 06/05/2018.
//  Copyright © 2018 Amg-Industries. All rights reserved.
//

import UIKit

class GridView: UIView {

    @IBOutlet weak var topRightView: UIView!
    @IBOutlet weak var bottomRightView: UIView!
    @IBOutlet var photoImageViews: [UIImageView]!
    @IBOutlet var addPhotoButton: [UIButton]!
    
    @IBOutlet var parentViews: [UIView]!
    
    /// Which shows all Views
    func resetPattern() {
        [topRightView, bottomRightView ].forEach { view in
            view?.isHidden = false
        }
    }
    
    func hideTopRightView() {
        topRightView.isHidden = true
    }
    
    func hideBottomRightView() {
        bottomRightView.isHidden = true
    }
    
    /// Which check tag of UIImageView
    func getImageView(_ tag: Int) -> UIImageView? {
        var imageViewSelected: UIImageView?
        
        photoImageViews.forEach { imageView in
            if imageView.tag == tag {
                imageViewSelected = imageView
            }
        }
        return imageViewSelected
    }
    
    /// Which check tag of buttons
    func getButton(_ tag: Int) -> UIButton? {
        var addButton: UIButton?
        
        addPhotoButton.forEach { button in
            if button.tag == tag {
                addButton = button
            }
        }
        return addButton
    }
    
    /// Check if Views contains Images to Share
    func isAvailableToShare() -> Bool{
        let tags = tagOfHiddenViews()
        var isAvailable = true
        photoImageViews.forEach { imageView in
            if !tags.contains(imageView.tag), imageView.image == nil {
                isAvailable = false
            }
        }
        return isAvailable
    }
    
    
    private func tagOfHiddenViews() -> [Int] {
        var tags = [Int]()
        parentViews.forEach { view in
            if view.isHidden {
                tags.append(view.tag)
            }
        }
        return tags
    }

}


