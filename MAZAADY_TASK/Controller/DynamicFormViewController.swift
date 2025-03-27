//
//  DynamicFormViewController.swift
//  MAZAADY_TASK
//
//  Created by Mohamed Tawab on 26/03/2025.
//

import UIKit

// MARK: - Dynamic Form View Controller
class DynamicFormViewController: UIViewController {
        

    // MARK: - UI Components
        private lazy var scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.isUserInteractionEnabled = true
            scrollView.keyboardDismissMode = .interactive
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(EndEditing)))
            return scrollView
        }()
        
        private lazy var contentView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private lazy var stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 30
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        private lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Mazaady Categories"
            label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            label.textAlignment = .center
            label.textColor = .black
            return label
        }()
        

        private lazy var categoryDropdown: SearchableDropdown = {
            let dropdown = SearchableDropdown()
            dropdown.title = "Main Category"
            dropdown.placeholder = "Select Main Category"
            return dropdown
        }()
        
        private lazy var subcategoryDropdown: SearchableDropdown = {
            let dropdown = SearchableDropdown()
            dropdown.title = "Subcategory"
            dropdown.placeholder = "Select Subcategory"
            return dropdown
        }()
        
        private lazy var submitButton: UIButton = {
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 8
            button.setTitle("Submit", for: .normal)
            button.backgroundColor = UIColor.fromRGB(236, 95, 95, alpha: 1)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        private lazy var resultTableView: UITableView = {
            let tableView = UITableView()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
            return tableView
        }()
        
    private lazy var noPropertiesLabel: UILabel = {
        let label = UILabel()
        label.text = "This subcategory has no properties available"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
        // MARK: - Data
        var categories: [Category] = []
        var selectedCategory: Category?
        var subcategories: [Category] = []
        var selectedSubcategory: Category?
        var properties: [Property] = []
        var selectedValues: [SelectedValue] = []
        var propertyFields: [PropertyField] = []
    
        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            fetchCategories()
        }
        
        // MARK: - UI Setup
        private func setupUI() {
            view.backgroundColor = .white
            title = "Dynamic Form"
            
            // Setup scroll view
            view.addSubview(scrollView)
            
            // Setup content view
            scrollView.addSubview(contentView)
            
            // Setup stack view
            contentView.addSubview(stackView)
            
            stackView.addArrangedSubview(titleLabel)
            stackView.addArrangedSubview(categoryDropdown)
            stackView.addArrangedSubview(subcategoryDropdown)
            stackView.addArrangedSubview(submitButton)
            
            // Set constraints
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -50),
                
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                
                stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
                
                submitButton.heightAnchor.constraint(equalToConstant: 50)
            ])
            
            // Setup callbacks
            categoryDropdown.onSelection = { [weak self] index in
                guard let self = self, index < self.categories.count else { return }
                self.selectedCategory = self.categories[index]
                self.updateSubcategories()
            }
            
            subcategoryDropdown.onSelection = { [weak self] index in
                    guard let self = self, index < self.subcategories.count else { return }
                    self.selectedSubcategory = self.subcategories[index]
                    self.fetchProperties()
            }
        }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
    }
    
    @objc func EndEditing() {
        view.endEditing(false)
    }
    
    // MARK: - Data Fetching
    private func fetchCategories() {
        APIService.shared.getAllCategories { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let categories):
                self.categories = categories
                
                // Set categories in the dropdown
                self.categoryDropdown.setCategories(categories)
                
            case .failure(let error):
                self.showError(error.localizedDescription)
            }
        }
    }
    
    private func updateSubcategories() {
        guard let selectedCategory = selectedCategory else {
            subcategories = []
            subcategoryDropdown.setItems([])
            return
        }
        
        subcategories = categories.filter { $0.parentId == selectedCategory.id }
        let subcategoryNames = subcategories.map { $0.name }
        subcategoryDropdown.setItems(subcategoryNames)
        
        removePropertyFields()
    }
    
    private func fetchProperties() {
        guard let selectedSubcategory = selectedSubcategory else { return }
        
        APIService.shared.getProperties(for: selectedSubcategory.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let properties):
                self.properties = properties
                self.updatePropertyFields()
                
            case .failure(let error):
                self.showError(error.localizedDescription)
            }
        }
    }
    
    private func fetchChildProperties(for optionId: Int, completion: @escaping ([Property]) -> Void) {
        APIService.shared.getOptionProperties(for: optionId) { result in
            switch result {
            case .success(let properties):
                completion(properties)
            case .failure:
                completion([])
            }
        }
    }
    
    // MARK: - UI Updates
    private func updatePropertyFields() {
        // Clear existing property fields
        noPropertiesLabel.removeFromSuperview()

        removePropertyFields()
        selectedValues = []
        
        if properties.isEmpty {
            stackView.addArrangedSubview(noPropertiesLabel)
            
            NSLayoutConstraint.activate([
                noPropertiesLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
            ])
        } else {
            // Add new property fields
            for property in properties {
                addPropertyField(for: property)
            }
        }
    }
    
    private func removePropertyFields() {
        for field in propertyFields {
            field.removeFromSuperview()
            if stackView.arrangedSubviews.firstIndex(of: field) != nil {
                stackView.removeArrangedSubview(field)
            }
        }
        propertyFields = []
    }
    
    private func addPropertyField(for property: Property, insertAfter parentField: PropertyField? = nil) {
        let propertyField = PropertyField(property: property)
        
        // Determine where to insert this field
        if let parentField = parentField, let parentIndex = propertyFields.firstIndex(of: parentField) {
            // Insert after parent field
            let insertIndex = parentIndex + 1
            propertyFields.insert(propertyField, at: insertIndex)
            
            // Find index in stack view (need to account for non-property fields like dropdowns)
            let stackViewIndex = stackView.arrangedSubviews.firstIndex(of: parentField)! + 1
            stackView.insertArrangedSubview(propertyField, at: stackViewIndex)
        } else {
            // Add at the end (before submit button)
            propertyFields.append(propertyField)
            stackView.insertArrangedSubview(propertyField, at: stackView.arrangedSubviews.count - 1)
        }
        
        // Set callbacks
        propertyField.onValueChanged = { [weak self] option, otherValue in
            guard let self = self else { return }
            
            // Update selected values
            let selectedValue = SelectedValue(
                property: propertyField.getSelectedValue().property,
                option: option?.id == -1 ? nil : option,
                otherValue: otherValue
            )
            
            // Replace or add to selected values
            if let index = self.selectedValues.firstIndex(where: { $0.property.id == selectedValue.property.id }) {
                self.selectedValues[index] = selectedValue
            } else {
                self.selectedValues.append(selectedValue)
            }
        }
        
        propertyField.onOptionSelected = { [weak self] option in
            guard let self = self else { return }
            
            // Fetch child properties for the selected option
            self.fetchChildProperties(for: option.id) { childProperties in
                if !childProperties.isEmpty {
                    // Add child property fields
                    for childProperty in childProperties {
                        self.addPropertyField(for: childProperty, insertAfter: propertyField)
                    }
                }
            }
        }
    }
    
    // MARK: - Actions    
    @objc func submitButtonTapped() {
        if selectedCategory == nil || selectedSubcategory == nil {
            showAlert(title: "Missing Selection", message: "Please select a category and subcategory")
            return
        }
        
        if properties.isEmpty {
            showAlert(title: "No Properties", message: "This subcategory has no properties available")
            return
        }
        
        if selectedValues.isEmpty {
            showAlert(title: "No Properties Selected", message: "Please select at least one property value")
            return
        }
        
        noPropertiesLabel.removeFromSuperview()
        // Display results in a table
        DispatchQueue.main.async { [weak self] in
            self?.showResultTable()
        }
    }
    
    private func showResultTable() {
        resultTableView.removeFromSuperview()
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 8
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = false
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        headerView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        
        let headerLabel = UILabel(frame: headerView.bounds)
        headerLabel.text = "Selected Values"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        headerView.addSubview(headerLabel)
        
        tableView.tableHeaderView = headerView
        
        contentView.addSubview(tableView)
        self.resultTableView = tableView
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(min(selectedValues.count + 1, 10) * 44))
        ])
        
        contentView.layoutIfNeeded()
        scrollView.contentSize = CGSize(
            width: scrollView.contentSize.width,
            height: tableView.frame.maxY + 16
        )
        
        let rect = CGRect(
            x: 0,
            y: tableView.frame.origin.y,
            width: tableView.frame.width,
            height: tableView.frame.height
        )
        scrollView.scrollRectToVisible(rect, animated: true)
    }

    
    // MARK: - Helper Methods
    private func showError(_ message: String) {
        showAlert(title: "Error", message: message)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension DynamicFormViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedValues.count + 2 // +2 for category and subcategory
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        
        if indexPath.row == 0 {
            // Category
            cell.textLabel?.text = "Category: \(selectedCategory?.name ?? "")"
        } else if indexPath.row == 1 {
            // Subcategory
            cell.textLabel?.text = "Subcategory: \(selectedSubcategory?.name ?? "")"
        } else {
            // Property values
            let valueIndex = indexPath.row - 2
            if valueIndex < selectedValues.count {
                let value = selectedValues[valueIndex]
                cell.textLabel?.text = "\(value.property.name): \(value.displayName)"
            }
        }
        
        return cell
    }
}





