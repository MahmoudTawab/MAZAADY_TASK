//
//  CustomTabBarController.swift
//  MAZAADY_TASK
//
//  Created by Mahmoud on 26/03/2025.
//

import UIKit

/// A custom tab bar controller that replaces the default tab bar with a custom bottom bar.
class CustomTabBarController: UITabBarController {
    
    /// Custom bottom bar instance
    let customBottomBar = CustomBottomBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabBarController()
        setupCustomBottomBar()
    }
    
    /// Sets up the view controllers for the tab bar controller.
    private func setupTabBarController() {
        tabBar.isHidden = true // Hides the default tab bar
        
        let gridVC = DesignSprintViewController()
        gridVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "menu"), tag: 0)
        
        let exploreVC = DynamicFormViewController()
        exploreVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "explore"), tag: 1)
        
        let messagesVC = UIViewController()
        messagesVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "messages"), tag: 2)
        
        let profileVC = UIViewController()
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "profile"), tag: 3)
        
        viewControllers = [gridVC, exploreVC, messagesVC, profileVC]
    }
    
    /// Sets up the custom bottom bar and adds it to the view.
    private func setupCustomBottomBar() {
        view.addSubview(customBottomBar)
        
        // Configure Auto Layout constraints for the custom bottom bar
        customBottomBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customBottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customBottomBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customBottomBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            customBottomBar.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        setupButtonActions()
    }
    
    /// Configures the button actions for the custom bottom bar.
    private func setupButtonActions() {
        let buttons = [
            customBottomBar.gridButton,
            customBottomBar.exploreButton,
            customBottomBar.messageButton,
            customBottomBar.profileButton
        ]
        
        buttons.enumerated().forEach { (index, button) in
            button.addTarget(self, action: #selector(tabBarItemTapped(_:)), for: .touchUpInside)
            button.tag = index
        }
    }
    
    /// Handles tab selection when a custom bottom bar button is tapped.
    /// - Parameter sender: The button that was tapped.
    @objc private func tabBarItemTapped(_ sender: UIButton) {
        selectedIndex = sender.tag // Switch to the selected tab
        customBottomBar.moveIndicator(to: sender.tag) // Move the indicator to the selected tab
        updateButtonColors(selectedIndex: sender.tag) // Update button colors to reflect the active tab
    }
    
    /// Updates the tint color of the buttons based on the selected tab.
    /// - Parameter selectedIndex: The index of the selected tab.
    private func updateButtonColors(selectedIndex: Int) {
        let buttons = [
            customBottomBar.gridButton,
            customBottomBar.exploreButton,
            customBottomBar.messageButton,
            customBottomBar.profileButton
        ]
        
        buttons.enumerated().forEach { (index, button) in
            button.tintColor = index == selectedIndex ? UIColor.fromRGB(236, 95, 95, alpha: 1) : UIColor.fromRGB(199, 201, 217, alpha: 1)
        }
    }
}
