//
//  NotificationBellButton.swift
//  MAZAADY_TASK
//
//  Created by Mahmoud on 26/03/2025.
//

import UIKit

/// A notification bell icon with a badge indicator.
class NotificationBellButton: UIImageView {

    /// Small red badge to indicate unread notifications.
    private let badgeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 236/255, green: 95/255, blue: 95/255, alpha: 1)
        view.isHidden = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    /// Configures the button and badge.
    private func setupButton() {
        self.image = UIImage(named: "notification")?.withRenderingMode(.alwaysTemplate)
        self.contentMode = .scaleAspectFit
        self.tintColor = UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 1)

        addSubview(badgeView)

        NSLayoutConstraint.activate([
            badgeView.topAnchor.constraint(equalTo: self.topAnchor),
            badgeView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
            badgeView.widthAnchor.constraint(equalToConstant: 10),
            badgeView.heightAnchor.constraint(equalToConstant: 10)
        ])
    }

    /// Toggles the badge visibility.
    func setBadgeVisible(_ isVisible: Bool) {
        badgeView.isHidden = !isVisible
    }
}
