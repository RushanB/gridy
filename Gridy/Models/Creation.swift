//
//  Creation.swift
//  Gridy
//
//  Created by Cynthia Nikolai on 11/29/20.
//  Copyright © 2020 Cynthia Nikolai. All rights reserved.
//

import Foundation
import UIKit

class Creation: Codable {
    
    var image: UIImage
    
    static var defaultImage: UIImage {
        return UIImage.init(named: "Gridy-name-small-grey")!
    }
        
    init() {
        // stored property initialization
        image = Creation.defaultImage
    }
    
    init(image: UIImage) {
        // stored property initialization
        self.image = image
    }
    
    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        guard let data = image.pngData() else { return }
        try values.encode(data, forKey: .image)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let data = try values.decode(Data.self, forKey: .image)
        image = UIImage(data: data)!
    }
        public struct SomeImage: Codable {
            
            public let photo: Data
            
            public init(photo: UIImage) {
                self.photo = photo.pngData()!
            }
        }
    
    
    enum CodingKeys: String, CodingKey {
        case image
    }
}
