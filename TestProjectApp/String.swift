//
//  String.swift
//  TestProjectApp
//
//  Created by Igor Abovyan on 14.11.2021.
//

import UIKit

extension String {
    func getSymbol(size: CGFloat, bold: UIImage.SymbolWeight) -> UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: size, weight: bold, scale: .default)
        let image = UIImage.init(systemName: self, withConfiguration: config)!
        return image
    }
    
    static let number = "choose number"
}
