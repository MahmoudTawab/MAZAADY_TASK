//
//  SearchableDropdownCell.swift
//  MAZAADY_TASK
//
//  Created by Mahmoud on 26/03/2025.
//

import UIKit

/// Custom cell for a searchable dropdown list.
class SearchableDropdownCell: UITableViewCell {
    
    /// Image view for displaying category icon.
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return imageView
    }()
    
    /// Title label for the category name.
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    /// Subtitle label for the category slug (optional).
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    /// Keeps track of the current image loading task.
    private var currentImageTask: URLSessionDataTask?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Sets up the UI components and layout constraints.
    private func setupViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
    
    /// Configures the cell with category data.
    func configure(with category: Category) {
        // Cancel any previous image loading task
        currentImageTask?.cancel()
        
        // Set category name and slug
        titleLabel.text = category.name
        subtitleLabel.text = category.slug
        subtitleLabel.isHidden = category.slug == nil
        
        // Set default placeholder icon
        iconImageView.image = UIImage(systemName: "square.grid.2x2.fill")
        
        // Load image if a valid URL exists
        guard let iconURL = URL(string: category.image.thumbnail) else { return }
        
        currentImageTask = URLSession.shared.dataTask(with: iconURL) { [weak self] data, _, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else { return }
            
            DispatchQueue.main.async {
                self.iconImageView.image = image
            }
        }
        currentImageTask?.resume()
    }
    
    /// Resets the cell before reuse.
    override func prepareForReuse() {
        super.prepareForReuse()
        currentImageTask?.cancel()
        iconImageView.image = UIImage(systemName: "square.grid.2x2.fill")
    }
}
