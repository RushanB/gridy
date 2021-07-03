//
//  Puzzle.swift
//  Gridy
//
//  Created by Cynthia Nikolai on 2/2/21.
//  Copyright © 2021 Cynthia Nikolai. All rights reserved.
//

import UIKit
import Foundation

class Puzzle {
    
    var piecesImages: [UIImage] {
        didSet {
            print(piecesImages.count,"piecesImages count")
        }
    }
    var boardImages: [UIImage] = [] {
        didSet {
            print(boardImages.count,"boardImages count")
        }
    }

    let solvedImages: [UIImage]
    let solvedImage: UIImage
    
    init(Image: UIImage) {
        self.solvedImage = Image
        
        if UserDefaults.standard.valueExists(forKey:"solvedImages"),
           let solvedImages = try? UserDefaults.standard.images(forKey: "solvedImages") {
            self.solvedImages = solvedImages
        } else {
            let solvedImages = solvedImage.slice(into: 2)
            try? UserDefaults.standard.set(images: solvedImages, forKey: "solvedImages")
            self.solvedImages = solvedImages
        }
        
        if UserDefaults.standard.valueExists(forKey:"piecesImages"),
           let piecesImages = try? UserDefaults.standard.images(forKey: "piecesImages") {
            self.piecesImages = piecesImages
        } else {
            self.piecesImages = solvedImages.shuffled()
        }
        
        if UserDefaults.standard.valueExists(forKey:"boardImages"),
           let boardImages = try? UserDefaults.standard.images(forKey: "boardImages") {
            self.boardImages = boardImages
        } else {
            self.boardImages = []
        }
        //try? UserDefaults.standard.set(images: piecesImages, forKey: "piecesImages")
    }
}

extension UIImage {
   
func slice(into howMany: Int) -> [UIImage] {
   let width: CGFloat
   let height: CGFloat

   switch imageOrientation {
   case .left, .leftMirrored, .right, .rightMirrored:
       width = size.height
       height = size.width
   default:
       width = size.width
       height = size.height
   }

   let tileWidth = Int(width / CGFloat(howMany))
   let tileHeight = Int(height / CGFloat(howMany))

   let s = Int(scale)
   var images = [UIImage]()
   let cg = cgImage!

        var adjustedHeight = tileHeight

        var y = 0
        for row in 0 ..< howMany {
            if row == (howMany - 1) {
                adjustedHeight = Int(height) - y
            }
            var adjustedWidth = tileWidth
            var x = 0
            for column in 0 ..< howMany {
                if column == (howMany - 1) {
                    adjustedWidth = Int(width) - x
                }
                let origin = CGPoint(x: x * s, y: y * s)
                let size = CGSize(width: adjustedWidth * s, height: adjustedHeight * s)
                let tileCgImage = cg.cropping(to: CGRect(origin: origin, size: size))!
                images.append(UIImage(cgImage: tileCgImage, scale: scale, orientation: imageOrientation))
                x += tileWidth
            }
            y += tileHeight
        }
        return images
    }
}
