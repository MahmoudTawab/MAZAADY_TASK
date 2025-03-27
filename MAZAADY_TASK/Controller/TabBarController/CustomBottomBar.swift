//
//  CustomBottomBar.swift
//  MAZAADY_TASK
//
//  Created by Mahmoud on 26/03/2025.
//

import UIKit

// MARK: - Custom Bottom Bar
class CustomBottomBar: UIView {
    
    // MARK: - UI Components
    let gridButton = UIButton()
    let exploreButton = UIButton()
    let messageButton = UIButton()
    let profileButton = UIButton()
    
    private var buttons: [UIButton] = []
    private var indicatorLeadingConstraint: NSLayoutConstraint!
    
    /// Indicator View to show the selected tab
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fromRGB(236, 95, 95, alpha: 1)
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    /// Notification Badge for the message button
    private let badgeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fromRGB(236, 95, 95, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup Methods
    
    /// Configures the bottom bar UI elements
    private func setupView() {
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        
        buttons = [gridButton, exploreButton, messageButton, profileButton]
        let icons = ["menu", "explore", "messages", "profile"]
        
        buttons.enumerated().forEach { index, button in
            button.tintColor = .gray
            button.setImage(UIImage(named: icons[index]), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        }
        
        // Set initial selection color
        gridButton.tintColor = UIColor.fromRGB(236, 95, 95, alpha: 1)
        
        // Add Notification Badge
        messageButton.addSubview(badgeView)
        badgeView.addSubview(badgeLabel)
        badgeLabel.text = "2" // Example badge number
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.distribution = .equalSpacing
        
        addSubview(stackView)
        addSubview(indicatorView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: - Constraints
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            badgeView.topAnchor.constraint(equalTo: messageButton.topAnchor, constant: 10),
            badgeView.trailingAnchor.constraint(equalTo: messageButton.trailingAnchor, constant: -20),
            badgeView.widthAnchor.constraint(equalToConstant: 20),
            badgeView.heightAnchor.constraint(equalToConstant: 20),
            
            badgeLabel.centerXAnchor.constraint(equalTo: badgeView.centerXAnchor),
            badgeLabel.centerYAnchor.constraint(equalTo: badgeView.centerYAnchor),
            
            indicatorView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -2),
            indicatorView.heightAnchor.constraint(equalToConstant: 5),
            indicatorView.widthAnchor.constraint(equalToConstant: 13)
        ])
        
        indicatorLeadingConstraint = indicatorView.centerXAnchor.constraint(equalTo: gridButton.centerXAnchor)
        indicatorLeadingConstraint.isActive = true
    }
    
    // MARK: - Public Methods
    
    /// Moves the indicator to the selected button
    func moveIndicator(to index: Int) {
        let selectedButton = buttons[index]

        indicatorLeadingConstraint.isActive = false
        indicatorLeadingConstraint = indicatorView.centerXAnchor.constraint(equalTo: selectedButton.centerXAnchor)
        indicatorLeadingConstraint.isActive = true

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }

        updateButtonColors(selectedIndex: index)
    }

    /// Updates button colors to highlight the selected one
    private func updateButtonColors(selectedIndex: Int) {
        buttons.enumerated().forEach { index, button in
            button.tintColor = (index == selectedIndex) ? UIColor.fromRGB(236, 95, 95, alpha: 1) : UIColor.fromRGB(199, 201, 217, alpha: 1)
        }
    }
}
