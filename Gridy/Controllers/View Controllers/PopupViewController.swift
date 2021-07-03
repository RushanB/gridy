//
//  PopupViewController.swift
//  Gridy
//
//  Created by Cynthia Nikolai on 3/30/21.
//  Copyright © 2021 Cynthia Nikolai. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
   
    // MARK:- IBActions
    
    @IBAction func closePopup(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK:- IBOutlets
    
    @IBOutlet weak var hintPicture: UIImageView! {
        didSet {
            hintPicture.contentMode = .scaleAspectFit
        }
    }
   
    // MARK: - Local Variables
    
    var creation: Creation!
    
    // MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // apply creation data to the views
        hintPicture.image = creation.image
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
}
