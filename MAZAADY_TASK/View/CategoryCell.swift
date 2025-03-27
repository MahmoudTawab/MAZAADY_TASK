//
//  CategoryCell.swift
//  MAZAADY_TASK
//
//  Created by Mahmoud on 26/03/2025.
//

import UIKit

// MARK: - Category Cell
class CategoryCell: UICollectionViewCell {
    
    // Label to display the category name
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Cell initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Configure content view appearance
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = false
        contentView.layer.shadowRadius = 6
        contentView.layer.shadowColor = UIColor.fromRGB(236, 95, 95, alpha: 1).cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowOpacity = 0.3
        
        // Add title label to the content view
        contentView.addSubview(titleLabel)
        
        // Set constraints for title label
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure cell with text and selection state
    func configure(with text: String, isSelected: Bool) {
        titleLabel.text = text
        
        // Update cell background and shadow based on selection state
        contentView.backgroundColor = isSelected ? UIColor.fromRGB(236, 95, 95, alpha: 1) : UIColor.fromRGB(246, 247, 250, alpha: 1)
        titleLabel.textColor = isSelected ? .white : UIColor.fromRGB(157, 159, 160, alpha: 1)
        contentView.layer.shadowOpacity = isSelected ? 0.3 : 0.0
    }
    
    // Reset cell before reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        contentView.backgroundColor = UIColor.fromRGB(246, 247, 250, alpha: 1)
        titleLabel.textColor = UIColor.fromRGB(157, 159, 160, alpha: 1)
        contentView.layer.shadowOpacity = 0.0
    }
}
