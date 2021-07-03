//
//  ViewController.swift
//  Gridy
//
//  Created by Cynthia Nikolai on 12/8/20.
//  Copyright © 2020 Cynthia Nikolai. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class ImageEditorViewController: UIViewController {

    // MARK:- Local Variables
    var creation: Creation!
    private var initialImageViewOffset = CGPoint()
    
    // MARK:- Outlets
    @IBOutlet weak var creationImageView: UIImageView!
    @IBOutlet weak var creationFrame: UIView!
    
       
    // MARK:- Actions
    @IBAction func startPuzzle(_ sender: UIButton) {
        presentPlayfieldViewController()
    }
    
    @objc func moveImageView(_ sender: UIPanGestureRecognizer) {
        print("inside panGestureRecognizer")
        let translation = sender.translation(in: creationFrame.superview)
        
        if sender.state == .began || sender.state == .changed {
            creationImageView.center = CGPoint(x: creationImageView.center.x + translation.x, y: creationImageView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: creationImageView)
        }
    }
    
    @objc func rotateImageView(_ sender: UIRotationGestureRecognizer) {
        creationImageView.transform = creationImageView.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }
    
    @objc func scaleImageView(_ sender: UIPinchGestureRecognizer) {
        creationImageView.transform = creationImageView.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
    }
    
    // MARK:- Helper
    private func configure() {
        
        // apply creation data to the views
        creationImageView.image = creation.image
        creationImageView.isUserInteractionEnabled = true
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveImageView(_:)))
        panGestureRecognizer.delegate = self
        creationImageView.addGestureRecognizer(panGestureRecognizer)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotateImageView(_:)))
        rotationGestureRecognizer.delegate  = self
        creationImageView.addGestureRecognizer(rotationGestureRecognizer)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scaleImageView(_:)))
        pinchGestureRecognizer.delegate = self
        creationImageView.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    private func presentPlayfieldViewController() {
        creationImageView.layer.zPosition = -1

        UIGraphicsBeginImageContextWithOptions(creationFrame.bounds.size, false, 0)
        creationFrame.drawHierarchy(in: creationFrame.bounds, afterScreenUpdates: true)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let storyboard = UIStoryboard(name: "Playfield", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PlayfieldViewController") as! PlayfieldViewController
        viewController.creation = Creation(image:snapshot!)
/*to do**/
        try? UserDefaults.standard.set(image: snapshot!, forKey: "creation")
        //snapshot = UIGraphicsGetImageFromCurrentImageContext()
        //try? UserDefaults.standard.set(image: snapshot!, forKey: "creation")
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    // MARK:- Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
//        let storyBoard = self.storyboard?.value(forKey: "name") //get storyboard id
//        let newViewController = self.restorationIdentifier //get identifier of view controller
//        UserDefaults.standard.set(storyBoard, forKey: "storyBoard") // save to user defaults
//        UserDefaults.standard.set(newViewController, forKey: "newViewController")
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }

}//end of class

// MARK:- Simultaneous GestureRecognizer

extension ImageEditorViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
        -> Bool {

        if gestureRecognizer is UIPanGestureRecognizer || otherGestureRecognizer is UIPanGestureRecognizer {
            return false
        }
        return true
    }
    
}
