//
//  MainViewController.swift
//  Gridy
//
//  Created by Cynthia Nikolai on 12/8/20.
//  Copyright © 2020 Cynthia Nikolai. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class MainViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate  {

    // MARK:- outlets
    
    @IBOutlet weak var PickGridyPicture: UIImageView! {
        didSet {
            PickGridyPicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(processPicked)))
            PickGridyPicture.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var PhotoLibraryPicture: UIImageView! {
        didSet {
            PhotoLibraryPicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(displayLibrary)))
           PhotoLibraryPicture.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var CameraPicture: UIImageView!{
        didSet {
            CameraPicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(displayCamera)))
           CameraPicture.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - local variables
    
    var localImages = [UIImage].init()
    var creation = Creation.init()
    var initialImageViewOffset = CGPoint()
    let randomImageNames = ["Boats", "Car", "Crocodile", "Park", "TShirts"]
    
    
    // MARK:- Lifecycle
       
    override func viewDidLoad() {
        super.viewDidLoad()
//        let storyBoard = self.storyboard?.value(forKey: "name") //get storyboard id
//        let newViewController = self.restorationIdentifier //get identifier of view controller
//        UserDefaults.standard.set(storyBoard, forKey: "storyBoard") // save to user defaults
//        UserDefaults.standard.set(newViewController, forKey: "newViewController")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.valueExists(forKey:"piecesImages") {
            if let creationImage = UserDefaults.standard.image(forKey: "creation") {
                //print(window,"this is the window")
                let storyboard = UIStoryboard(name: "Playfield", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "PlayfieldViewController") as! PlayfieldViewController
                let creation = Creation(image: creationImage)
                viewController.creation = creation
                viewController.modalPresentationStyle = .fullScreen
                present(viewController, animated: true)
            }
        }
    }
    
    // MARK:- Helper functions
    
    @objc func displayCamera() {
        let sourceType = UIImagePickerController.SourceType.camera

        if UIImagePickerController.isSourceTypeAvailable(sourceType) {

            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)

            let noPermissionMessage = "Looks like FrameIT have access to your camera:( Please use Setting app on your device to permit FrameIT accessing your camera"

            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                    if granted {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionMessage)
            @unknown default:
                break
            }
        }
        else {
            troubleAlert(message: "Looks like we can't access your camera at this time")
        }
    }

    @objc func displayLibrary() {
        let sourceType = UIImagePickerController.SourceType.photoLibrary

        if UIImagePickerController.isSourceTypeAvailable(sourceType) {

            let status = PHPhotoLibrary.authorizationStatus()
            let noPermissionMessage = "Looks like Gridy doesn't have access to your photos:( Please use Setting app on your device to permit Gridy accessing your library"

            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if newStatus == .authorized {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionMessage)
            default:
                break
            }
        }
        else {
            troubleAlert(message: "Looks like we can't access your photo library at this time")
        }
    }

    @objc func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let newImage = info[.originalImage] as? UIImage
        processPickedImage(image: newImage)
    }

    func troubleAlert(message: String?) {
        let alertController = UIAlertController(title: "Oops...", message:message , preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Got it", style: .cancel)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }

    func randomImage() -> UIImage? {
        print("inside randomImage")
        let currentImage = creation.image

        if localImages.count > 0 {
            while true {
                let randomIndex = Int(arc4random_uniform(UInt32(localImages.count)))
                let newImage = localImages[randomIndex]
                if newImage != currentImage {
                    return newImage
                }
            }
        }
        return nil
    }
    
    @objc func processPicked() {
        let imageName = randomImageNames.shuffled().first!
        creation.image = UIImage(named: imageName)!
        PresentImageEditorViewController()
     }
    
    @objc func processPickedImage(image: UIImage?) {
        creation.image = image!
        PresentImageEditorViewController()
    }
    
    func PresentImageEditorViewController() {
        let storyboard = UIStoryboard(name: "ImageEditor", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImageEditorViewController") as! ImageEditorViewController
        viewController.creation = creation
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }
}
