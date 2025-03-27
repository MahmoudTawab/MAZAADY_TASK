//
//  SearchableDropdown.swift
//  MAZAADY_TASK
//
//  Created by Mohamed Tawab on 26/03/2025.
//

import UIKit
import Network
 
// MARK: - Searchable Dropdown
class SearchableDropdown: UIView {
    
    private var isDropdownVisible = false
    private var categories: [Category]? {
        didSet {
            // Update items to be used in the dropdown
            if let categories = categories {
                let categoryNames = categories.map { $0.name }
                setItems(categoryNames)
            }
        }
    }
    
    // UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var selectionButton: UIButton = {
        let button = UIButton(type: .system)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.baseBackgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
            config.baseForegroundColor = .darkGray
            config.titleAlignment = .leading
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0)
            button.configuration = config
        } else {
            button.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
            button.layer.cornerRadius = 8
            button.contentHorizontalAlignment = .left
            button.setTitleColor(.darkGray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        }
        button.addTarget(self, action: #selector(selectionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dropdownTableView: UITableView? = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DropdownCell")
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar? = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search..."
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var dropdownContainer: UIView? = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        return view
    }()
    
    private lazy var overlayView: UIView? = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    // Data
    private var items: [String] = []
    private var filteredItems: [String] = []
    private var selectedIndex: Int?
    
    // Callbacks
    var onSelection: ((Int) -> Void)?
    
    // Configuration
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var placeholder: String = "Select an option" {
        didSet {
            updateSelectionButtonTitle()
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup
    private func setupViews() {
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(selectionButton)
        updateSelectionButtonTitle()
        
        // Set constraint-based layout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        selectionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            selectionButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            selectionButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectionButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectionButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            selectionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Public Methods
    func setItems(_ items: [String]) {
        self.items = items
        self.filteredItems = items
        
        // Reset selection if needed
        if let selectedIndex = selectedIndex, selectedIndex >= items.count {
            self.selectedIndex = nil
            updateSelectionButtonTitle()
        }
    }
    
    func selectItem(at index: Int) {
        guard index < items.count else { return }
        selectedIndex = index
        updateSelectionButtonTitle()
    }
    
    func getSelectedIndex() -> Int? {
        return selectedIndex
    }
    
    func getSelectedItem() -> String? {
        guard let selectedIndex = selectedIndex, selectedIndex < items.count else { return nil }
        return items[selectedIndex]
    }
    
    // MARK: - Actions
    @objc private func selectionButtonTapped() {
        guard !isDropdownVisible else { return }
        
        if !Reachability.isConnectedToNetwork() {
        showErrorMessage("No internet connection, please try again later.")
        return
        }
        
        if items.count == 0 {
            showErrorMessage("No data is currently available.")
            return
        }

        showDropdown()
        isDropdownVisible = true
    }
    
    private func showErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let rootViewController = window.rootViewController {
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showDropdown() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        overlayView = UIView(frame: window.bounds)
        overlayView!.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        overlayView!.addGestureRecognizer(tapGesture)
        window.addSubview(overlayView!)

        let rowHeight: CGFloat = 44
        let searchBarHeight: CGFloat = 56
        let maxDropdownHeight: CGFloat = 300
        let calculatedHeight = min(CGFloat(filteredItems.count) * rowHeight + searchBarHeight, maxDropdownHeight)

        dropdownContainer = UIView(frame: CGRect(x: 10, y: (window.bounds.height / 2) - (calculatedHeight / 2), width: window.bounds.width - 20, height: calculatedHeight + 10))
        dropdownContainer!.backgroundColor = .white
        dropdownContainer!.layer.cornerRadius = 8
        dropdownContainer!.clipsToBounds = true
        dropdownContainer!.layer.shadowColor = UIColor.black.cgColor
        dropdownContainer!.layer.shadowOffset = CGSize(width: 0, height: 2)
        dropdownContainer!.layer.shadowRadius = 4
        dropdownContainer!.layer.shadowOpacity = 0.2
        window.addSubview(dropdownContainer!)

        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: dropdownContainer!.frame.width, height: searchBarHeight))
        searchBar!.placeholder = "Search..."
        searchBar!.delegate = self
        dropdownContainer!.addSubview(searchBar!)

        dropdownTableView = UITableView(frame: CGRect(x: 0, y: searchBar!.frame.height, width: dropdownContainer!.frame.width, height: calculatedHeight - searchBarHeight))
        dropdownTableView!.delegate = self
        dropdownTableView!.dataSource = self
        dropdownTableView?.register(SearchableDropdownCell.self, forCellReuseIdentifier: "DropdownCell")
        dropdownContainer!.addSubview(dropdownTableView!)
    }

    
    @objc private func overlayTapped() {
        hideDropdown()
    }
    
    private func hideDropdown() {
        dropdownTableView?.removeFromSuperview()
        dropdownTableView = nil
        
        searchBar?.removeFromSuperview()
        searchBar = nil
        
        dropdownContainer?.removeFromSuperview()
        dropdownContainer = nil
        
        overlayView?.removeFromSuperview()
        overlayView = nil
        
        isDropdownVisible = false
    }
    
    private func updateSelectionButtonTitle() {
        if let selectedIndex = selectedIndex, selectedIndex < items.count {
            selectionButton.setTitle(items[selectedIndex], for: .normal)
        } else {
            selectionButton.setTitle(placeholder, for: .normal)
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension SearchableDropdown: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    // Override the cellForRowAt method to use the custom cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as? SearchableDropdownCell,
              let categories = categories else {
            let fallbackCell = UITableViewCell(style: .default, reuseIdentifier: "DefaultCell")
            fallbackCell.textLabel?.text = filteredItems[indexPath.row]
            return fallbackCell
        }
        
        // Find the matching category
        let filteredCategory = categories.filter { $0.name.lowercased().contains(filteredItems[indexPath.row].lowercased()) }
        
        if let category = filteredCategory.first {
            cell.configure(with: category)
        }
        
        return cell
    }
    
    func setCategories(_ categories: [Category]) {
        self.categories = categories
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Find the original index in the items array
        if let originalIndex = items.firstIndex(of: filteredItems[indexPath.row]) {
            selectedIndex = originalIndex
            updateSelectionButtonTitle()
            onSelection?(originalIndex)
        }
        
        hideDropdown()
    }
}


// MARK: - UISearchBarDelegate
extension SearchableDropdown: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        dropdownTableView?.reloadData()
    }
}
