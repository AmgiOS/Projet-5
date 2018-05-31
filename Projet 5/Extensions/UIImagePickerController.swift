//
//  UIImagePickerController.swift
//  Projet 5
//
//  Created by Amg on 28/05/2018.
//  Copyright © 2018 Amg-Industries. All rights reserved.
//

import UIKit

extension UIImagePickerController {
    open override var shouldAutorotate: Bool { return true }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .all}
}
