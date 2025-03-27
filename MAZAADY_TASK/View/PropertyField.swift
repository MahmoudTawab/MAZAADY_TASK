//
//  PropertyField.swift
//  MAZAADY_TASK
//
//  Created by Mohamed Tawab on 26/03/2025.
//

import UIKit

// MARK: - Property Field (Wrapper for Property UI)
class PropertyField: UIView {
    // UI Components
    private let containerView = UIView()
    private let dropdown = SearchableDropdown()
    private let otherTextField = UITextField()
    private let separatorView = UIView()
    
    // Data
    private var property: Property
    private var options: [PropertyOption] = []
    private var selectedOption: PropertyOption?
    private var otherValue: String?
    
    // Callbacks
    var onValueChanged: ((PropertyOption?, String?) -> Void)?
    var onOptionSelected: ((PropertyOption) -> Void)?
    
    // MARK: - Initialization
    init(property: Property) {
        self.property = property
        super.init(frame: .zero)
        setupViews()
        configureWithProperty()
        setupKeyboardObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    private func setupViews() {
        backgroundColor = .white
        
        // Container View
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Dropdown
        containerView.addSubview(dropdown)
        dropdown.translatesAutoresizingMaskIntoConstraints = false
        
        // Other Text Field
        otherTextField.borderStyle = .roundedRect
        otherTextField.placeholder = "Enter custom value"
        otherTextField.isHidden = true
        otherTextField.delegate = self
        otherTextField.addTarget(self, action: #selector(otherTextFieldDidChange), for: .editingChanged)
        containerView.addSubview(otherTextField)
        otherTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Separator
        separatorView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            dropdown.topAnchor.constraint(equalTo: containerView.topAnchor),
            dropdown.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dropdown.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            otherTextField.topAnchor.constraint(equalTo: dropdown.bottomAnchor, constant: 8),
            otherTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            otherTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            otherTextField.heightAnchor.constraint(equalToConstant: 44),
            
            separatorView.topAnchor.constraint(equalTo: otherTextField.bottomAnchor, constant: 16),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            containerView.bottomAnchor.constraint(equalTo: separatorView.topAnchor)
        ])
        
        // Configure dropdown callback
        dropdown.onSelection = { [weak self] index in
            guard let self = self else { return }
            if index < self.options.count {
                let selectedOption = self.options[index]
                self.selectedOption = selectedOption
                
                // Check if "Other" option was selected
                if selectedOption.name.lowercased() == "other" {
                    self.otherTextField.isHidden = false
                    self.otherTextField.becomeFirstResponder()
                } else {
                    self.otherTextField.isHidden = true
                    self.otherTextField.resignFirstResponder()
                }
                
                self.onValueChanged?(selectedOption, self.otherValue)
                
                // Notify for children properties
                if selectedOption.hasChildren {
                    self.onOptionSelected?(selectedOption)
                }
            }
        }
    }
    
    private func configureWithProperty() {
        dropdown.title = property.name
        dropdown.placeholder = "Select \(property.name)"
        
        // Set options
        if let options = property.options {
            self.options = options
            
            // Add "Other" option if it doesn't exist
            if !options.contains(where: { $0.name.lowercased() == "other" }) {
                let otherOption = PropertyOption(id: -1, name: "Other", hasChildren: false)
                self.options.append(otherOption)
            }
            
            // Set dropdown items
            let optionNames = self.options.map { $0.name }
            dropdown.setItems(optionNames)
        }
    }
    
    // MARK: - Keyboard Handling
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight / 2)
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
    
    // MARK: - Actions
    @objc private func otherTextFieldDidChange() {
        otherValue = otherTextField.text
        onValueChanged?(selectedOption, otherValue)
    }
    
    // MARK: - Public Methods
    func getSelectedValue() -> SelectedValue {
        return SelectedValue(
            property: property,
            option: selectedOption,
            otherValue: otherValue
        )
    }
}

extension PropertyField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() 
        return true
    }
}
