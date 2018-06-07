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
    
    func animateViewUpOrLeft() {
        if swipeGestureRecognizer?.direction == .up {
            UIView.animate(withDuration: 0.5, animations: {
                self.gridView.transform = CGAffineTransform(translationX: 0, y: -1000)
            }) { _ in
                self.shareAction()
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.gridView.transform = CGAffineTransform(translationX: -1000, y: 0)
            }) { _ in
                self.shareAction()
            }
        }
        
    }
    
    func resetAnimationView() {
        UIView.animate(withDuration: 0.5) {
            self.gridView.transform = .identity
        }
    }
    
    func shareAction() {
        print("shareAction")
        if gridView.isAvailableToShare() {
            let image = GridConverter.convertViewToImage(gridView!)
            var contentToShare = [UIImage]()
            contentToShare.append(image!)
            _ = UIActivityViewController(activityItems: contentToShare, applicationActivities: nil)
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

    
    @IBAction func buttonTapped(_ sender: UIButton) {
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
    
    func unselectButtons() {
        patternButtons.forEach { button in
            button.isSelected = false
        }
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
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
        imagePicker.dismiss(animated: true, completion: checkPhoto)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func libraryMode() {
        self.imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func cameraMode() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("No camera available")
        }
    }
    
    func checkPhoto() {
        guard let tag = tag else {return}
        gridView.addPhotoButton[tag].isHidden = true
        gridView.photoImageViews[tag].isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        gridView.addGestureRecognizer(tap)
    }

    @objc func tapGesture() {
        displayImageSourceMenu()
    }
}


