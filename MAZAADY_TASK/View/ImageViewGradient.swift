//
//  ImageViewGradient.swift
//  MAZAADY_TASK
//
//  Created by Mahmoud on 26/03/2025.
//

import UIKit

// MARK: - Image View Gradient
class ImageViewGradient: UIImageView {
    
    // MARK: - Properties
    
    /// Gradient layer applied to the bottom half of the image
    private let gradientLayer = CAGradientLayer()
    
    /// Colors for the gradient layer
    var colors: [CGColor] = [] {
        didSet {
            gradientLayer.colors = colors
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayer()
    }
    
    // MARK: - Setup Methods
    
    /// Configures the gradient layer with default settings
    private func setupGradientLayer() {
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)  // Starts from the top-center
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)    // Ends at the bottom-center
        gradientLayer.opacity = 1.0
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Layout Updates
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = CGRect(x: 0, y: self.frame.height / 2, width: self.frame.width, height: self.frame.height / 2)
    }
}
