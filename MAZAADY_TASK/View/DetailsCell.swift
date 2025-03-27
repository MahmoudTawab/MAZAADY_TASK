//
//  DetailsCell.swift
//  MAZAADY_TASK
//
//  Created by Mahmoud on 26/03/2025.
//

import UIKit

// MARK: - Details Cell
class DetailsCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    /// Course Image View with Gradient Effect
    private let courseImageView: ImageViewGradient = {
        let imageView = ImageViewGradient(frame: CGRect.zero)
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.shadowOpacity = 0.4
        imageView.layer.shadowRadius = 4
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.colors = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.024).cgColor,
                            #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor,
                            #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.45).cgColor,
                            #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor]
        return imageView
    }()
    
    /// Button for Free e-book offer
    private let buttonFree: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Free e-book", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.4, alpha: 1.0)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Course title label
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Instructor profile image
    private let instructorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Instructor name label
    private let instructorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Course duration label
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.fromRGB(180, 180, 180)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Stopwatch icon for course duration
    private let durationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "stopwatch")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Instructor position label
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.fromRGB(180, 180, 180)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Number of lessons label
    private let lessonsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.backgroundColor = UIColor.fromRGB(77, 201, 209)
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Container for course category tags
    private let tagContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup Methods
    
    /// Sets up the UI components inside the cell
    private func setupViews() {
        contentView.addSubview(courseImageView)
        courseImageView.addSubview(buttonFree)
        courseImageView.addSubview(titleLabel)
        courseImageView.addSubview(instructorImageView)
        courseImageView.addSubview(instructorNameLabel)
        courseImageView.addSubview(durationLabel)
        courseImageView.addSubview(durationImage)
        courseImageView.addSubview(positionLabel)
        courseImageView.addSubview(tagContainerView)
        
        NSLayoutConstraint.activate([
            // Course Image Constraints
            courseImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            courseImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            courseImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            courseImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Free Button Constraints
            buttonFree.topAnchor.constraint(equalTo: courseImageView.topAnchor, constant: 30),
            buttonFree.leadingAnchor.constraint(equalTo: courseImageView.leadingAnchor, constant: 12),
            buttonFree.heightAnchor.constraint(equalToConstant: 32),
            buttonFree.widthAnchor.constraint(equalToConstant: 120),
            
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: courseImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: courseImageView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: courseImageView.trailingAnchor, constant: -12),
            
            // Duration Image Constraints
            durationImage.widthAnchor.constraint(equalToConstant: 20),
            durationImage.heightAnchor.constraint(equalToConstant: 20),
            durationImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            durationImage.leadingAnchor.constraint(equalTo: courseImageView.leadingAnchor, constant: 12),
            
            // Duration Label Constraints
            durationLabel.centerYAnchor.constraint(equalTo: durationImage.centerYAnchor),
            durationLabel.leadingAnchor.constraint(equalTo: durationImage.trailingAnchor, constant: 10),
            durationLabel.trailingAnchor.constraint(equalTo: courseImageView.trailingAnchor, constant: -12),

            // Tag Container View Constraints
            tagContainerView.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 10),
            tagContainerView.leadingAnchor.constraint(equalTo: courseImageView.leadingAnchor, constant: 12),
            tagContainerView.widthAnchor.constraint(equalTo: courseImageView.widthAnchor, multiplier: 1/1.7),

            // Instructor Image Constraints
            instructorImageView.topAnchor.constraint(equalTo: tagContainerView.bottomAnchor, constant: 10),
            instructorImageView.leadingAnchor.constraint(equalTo: courseImageView.leadingAnchor, constant: 12),
            instructorImageView.widthAnchor.constraint(equalToConstant: 38),
            instructorImageView.heightAnchor.constraint(equalToConstant: 38),
            
            // Instructor Name Constraints
            instructorNameLabel.topAnchor.constraint(equalTo: instructorImageView.topAnchor),
            instructorNameLabel.leadingAnchor.constraint(equalTo: instructorImageView.trailingAnchor, constant: 8),
            
            // Position Label Constraints
            positionLabel.topAnchor.constraint(equalTo: instructorNameLabel.bottomAnchor),
            positionLabel.leadingAnchor.constraint(equalTo: instructorImageView.trailingAnchor, constant: 8),
        ])
    }
    
    // MARK: - Configuration Method
    func configure(
        courseImage: UIImage?,
        title: String,
        position: String,
        instructorImage: UIImage?,
        instructorName: String,
        duration: String,
        lessons: String,
        tags: [String]
    ) {
        courseImageView.image = courseImage
        titleLabel.text = title
        positionLabel.text = position
        instructorImageView.image = instructorImage
        instructorNameLabel.text = instructorName
        durationLabel.text = duration
        lessonsLabel.text = lessons
        
        // Setup tags
        tagContainerView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        tagContainerView.addArrangedSubview(lessonsLabel)
        
        tags.forEach { tagText in
            let tagLabel = UILabel()
            tagLabel.text = tagText
            tagLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            tagLabel.textColor = .white
            tagLabel.textAlignment = .center
            tagLabel.layer.cornerRadius = 4
            tagLabel.clipsToBounds = true
            tagLabel.translatesAutoresizingMaskIntoConstraints = false
            
            switch tagText {
            case "Free" :
                tagLabel.backgroundColor = UIColor.fromRGB(141, 94, 242)
            case "UI/UX" :
                tagLabel.backgroundColor = UIColor.fromRGB(0, 130, 205)
            case "Beginner" :
                tagLabel.backgroundColor = UIColor.fromRGB(252, 204, 117)
            case "Design" :
                tagLabel.backgroundColor = UIColor.fromRGB(236, 95, 95)
            default:
                tagLabel.backgroundColor = UIColor.fromRGB(77, 201, 209)
            }
            
            NSLayoutConstraint.activate([
                tagLabel.heightAnchor.constraint(equalToConstant: 24),
            ])
            
            tagContainerView.addArrangedSubview(tagLabel)
        }
    }
    
    // MARK: - Reuse Method
    override func prepareForReuse() {
        super.prepareForReuse()
        courseImageView.image = nil
        titleLabel.text = nil
        positionLabel.text = nil
        instructorImageView.image = nil
        instructorNameLabel.text = nil
        durationLabel.text = nil
        lessonsLabel.text = nil
        
        tagContainerView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
