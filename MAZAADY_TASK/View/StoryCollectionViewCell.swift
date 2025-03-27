//
//  StoryCollectionViewCell.swift
//  MAZAADY_TASK
//
//  Created by Mahmoud on 26/03/2025.
//

import UIKit

/// Custom UICollectionViewCell for displaying user stories with circular border and live indicator
class StoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    /// Circular border view with shadow effect
    private lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.fromRGB(236, 95, 95, alpha: 1).cgColor
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = false
        
        // Shadow configuration
        view.layer.shadowColor = UIColor.fromRGB(236, 95, 95, alpha: 1).cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6
        
        return view
    }()
    
    /// Main user image view
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    /// Live camera indicator icon
    private lazy var cameraIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Live Circle"))
        imageView.tintColor = .white
        imageView.backgroundColor = UIColor.systemTeal
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    /// Configures and adds subviews
    private func setupViews() {
        contentView.addSubview(borderView)
        borderView.addSubview(userImageView)
        contentView.addSubview(cameraIcon)
        
        // Disable autoresizing masks
        [borderView, userImageView, cameraIcon].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    /// Sets up AutoLayout constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Border view constraints
            borderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            borderView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            borderView.widthAnchor.constraint(equalToConstant: 80),
            borderView.heightAnchor.constraint(equalToConstant: 80),
            
            // User image constraints
            userImageView.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            userImageView.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 65),
            userImageView.heightAnchor.constraint(equalToConstant: 65),
            
            // Camera icon constraints
            cameraIcon.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 3),
            cameraIcon.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: 5),
            cameraIcon.widthAnchor.constraint(equalToConstant: 30),
            cameraIcon.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - Configuration
    
    /// Configures cell with story data
    /// - Parameter story: StoryItem model containing user image
    func configure(with story: StoryItem) {
        userImageView.image = story.userImage
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
    }
}
