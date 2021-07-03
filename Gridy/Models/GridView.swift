//
//  GridView.swift
//  Gridy
//
//  Created by Cynthia Nikolai on 2/2/21.
//  Copyright © 2021 Cynthia Nikolai. All rights reserved.
//

import Foundation
import UIKit

class GridView: UIView {

    var numberOfColumns: Int = 4
    var numberOfRows: Int = 4
    var lineWidth: CGFloat = 1.5
    var lineColor = UIColor.white.cgColor

    override func draw(_ rect: CGRect) {
        backgroundColor = .clear
        if let context = UIGraphicsGetCurrentContext() {

            context.setLineWidth(lineWidth)
            context.setStrokeColor(lineColor)

            let columnWidth = Int(rect.width) / (numberOfColumns)
            for i in 1...numberOfColumns {
                var startPoint = CGPoint.zero
                var endPoint = CGPoint.zero
                startPoint.x = CGFloat(columnWidth * i)
                startPoint.y = 0.0
                endPoint.x = startPoint.x
                endPoint.y = frame.size.height
                context.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
                context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
                context.strokePath()
            }

            let rowHeight = Int(rect.height) / (numberOfRows)
            for j in 1...numberOfRows {
                var startPoint = CGPoint.zero
                var endPoint = CGPoint.zero
                startPoint.x = 0.0
                startPoint.y = CGFloat(rowHeight * j)
                endPoint.x = frame.size.width
                endPoint.y = startPoint.y
                context.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
                context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
                context.strokePath()
            }
        }
    }
}
