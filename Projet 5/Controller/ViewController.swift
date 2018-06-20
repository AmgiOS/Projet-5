//
//  ViewController.swift
//  Projet 5
//
//  Created by Amg on 16/04/2018.
//  Copyright © 2018 Amg-Industries. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var patternButtons: [UIButton]!
    @IBOutlet weak var gridView: GridView!
    
    let imagePicker = UIImagePickerController()
    var tag: Int?
    var swipeGestureRecognizer: UISwipeGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchViewDidLoad()
    }
    
    func launchViewDidLoad() {
        gridView.hideBottomRightView()
        imagePicker.delegate = self
        swipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action: #selector(handleShareAction))
        guard let swipeGestureRecognizer = swipeGestureRecognizer else {return}
        gridView.addGestureRecognizer(swipeGestureRecognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(setupSwipeDirection), name: .UIDeviceOrientationDidChange, object: nil)
        setupSwipeDirection()
    }
    @objc func handleShareAction() {
        animateViewUpOrLeft()
    }
    
    /// Animate gridView swipe Up to share and Swipe left
    func animateViewUpOrLeft() {
        if swipeGestureRecognizer?.direction == .up {
            UIView.animate(withDuration: 0.5, animations: {
                self.gridView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
            }) { _ in
                self.shareAction()
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.gridView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            }) { _ in
                self.shareAction()
            }
        }
        
    }
    
    /// Reset animation gridView
    func resetAnimationView() {
        UIView.animate(withDuration: 0.5) {
            self.gridView.transform = .identity
        }
    }
    
    /// Check if content is available to share or else animate message error
    func shareAction() {
        print("shareAction")
        if gridView.isAvailableToShare() {
            guard let image = GridConverter.convertViewToImage(gridView) else {return}
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
            activityViewController.completionWithItemsHandler = { activity, completed, items, error in
                self.resetAnimationView()
            }
        } else {
            let error = UIAlertController(title: "Error", message: "No File Has to Share", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            error.addAction(cancel)
            present(error, animated: true, completion: resetAnimationView)
        }
    }
    
    
    @objc func setupSwipeDirection() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
          swipeGestureRecognizer?.direction = .left
        } else {
          swipeGestureRecognizer?.direction = .up
        }
    }

    /// When a tapped button pattern
    @IBAction func PatternButtonTapped(_ sender: UIButton) {
        unselectButtons()
        patternButtons[sender.tag].isSelected = true
        gridView.resetPattern()
        switch sender.tag {
        case 0:
            gridView.hideTopRightView()
        case 1 :
            gridView.hideBottomRightView()
        default:
            break
        }
    }
    
    /// Reset pattern button selected
    func unselectButtons() {
        patternButtons.forEach { button in
            button.isSelected = false
        }
    }
    
    @IBAction func buttonAddPhoto(_ sender: UIButton) {
        tag = sender.tag
        displayImageSourceMenu()
    }
    
    func displayImageSourceMenu() {
        let alerte = UIAlertController(title: "Take Photo?", message: "Choice Média", preferredStyle: .actionSheet)
        let appareil = UIAlertAction(title: "Camera Device", style: .default) { (act) in
            self.cameraMode()
        }
        let library = UIAlertAction(title: "Library Photo", style: .default) { (act) in
            self.libraryMode()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alerte.addAction(appareil)
        alerte.addAction(library)
        alerte.addAction(cancel)
        present(alerte, animated: true, completion: nil)
    }
}

//MARK: - UIImagePickerController
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let tag = tag else { return }
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        guard let imageView = gridView.getImageView(tag) else {return}
        guard let addButton = gridView.getButton(tag) else {return}
        addButton.tag = imageView.tag
        imageView.image = selectedImage
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(gesture:)))
        imageView.addGestureRecognizer(tap)
        imagePicker.dismiss(animated: true, completion: checkPhoto)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    ///Access on library photo mode
    func libraryMode() {
        self.imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    ///Access on Camera Device mode
    func cameraMode() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("No camera available")
            let error = UIAlertController(title: "Error", message: "No camera Device", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            error.addAction(cancel)
            self.present(error, animated: true, completion: nil)
        }
    }
    
    /// When a add image on view hide a button and add gesture to tap on it
    func checkPhoto() {
        guard let tag = tag else {return}
        gridView.addPhotoButton[tag].isHidden = true
        gridView.photoImageViews[tag].isUserInteractionEnabled = true
    }
    
    @objc func tapGesture(gesture: UITapGestureRecognizer) {
        tag = gesture.view?.tag
        displayImageSourceMenu()
    }
}


