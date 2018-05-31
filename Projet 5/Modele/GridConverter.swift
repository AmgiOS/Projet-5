//
//  Share.swift
//  Projet 5
//
//  Created by Amg on 24/05/2018.
//  Copyright © 2018 Amg-Industries. All rights reserved.
//

import UIKit

class GridConverter {
    
    static func convertViewToImage (_ view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size , view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {return nil}
        UIGraphicsEndImageContext()
        return image
    }
}

