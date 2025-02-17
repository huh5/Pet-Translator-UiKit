//
//  GradientView.swift
//  Pet Translator
//
//  Created by Богдан Ткачивський on 13/02/2025.
//

import Foundation
import UIKit

class GradientView: UIView{
    
    private let gradientLayer = CAGradientLayer() // Gradient layer for background
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds // Update gradient frame on layout changes
    }
    
    private func setupGradient(){
        self.layer.addSublayer(gradientLayer) // Add gradient layer to the view
        gradientLayer.colors = [
            UIColor(named: "firstColor")?.cgColor,
            UIColor(named: "secondColor")?.cgColor
        ]
    }
    
}

