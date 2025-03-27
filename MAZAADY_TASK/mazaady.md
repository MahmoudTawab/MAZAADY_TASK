# Mazaady iOS Task

This project implements a dynamic form for the Mazaady platform using Swift and UIKit, as specified in the requirements.

## Features

- Dynamic form with hierarchical searchable dropdown menus
- Main Category and Subcategory selection
- Properties loaded based on the selected subcategory
- Support for "Other" option with custom input fields
- Hierarchical properties (parent-child relationships)
- Form submission and result display
- API integration with Mazaady staging API

## Requirements

- iOS 14.0+
- Xcode 13.0+
- Swift 5.5+

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/mazaady-ios-task.git
cd mazaady-ios-task
```

2. Open the Xcode project:
```bash
open MazaadyTask.xcodeproj
```

3. Build and run the project on a simulator or device.

## Project Structure

The project follows a clean architecture with the following components:

### Models
- `Category`: Represents a category or subcategory
- `Property`: Represents a property associated with a category
- `PropertyOption`: Represents an option for a property
- `SelectedValue`: Represents a user-selected value for a property

### UI Components
- `SearchableDropdown`: Custom dropdown component with search functionality
- `PropertyField`: Custom component for managing property selection
- `DynamicFormViewController`: Main view controller that manages the form

### API
- `APIService`: Singleton service for handling API requests to Mazaady endpoints

## API Integration

The app uses the following Mazaady API endpoints:

1. `GET /all-categories/web`: Retrieves all categories
2. `GET /properties/:category_id`: Retrieves properties for a specific category
3. `GET /option-properties/:option_id`: Retrieves child properties for a specific option

## Testing

The project includes unit tests for:
- Model decoding
- SearchableDropdown functionality
- PropertyField value management
- SelectedValue display logic

To run the tests, use the Xcode test navigator or press `Cmd+U`.

## Implementation Details

### Dynamic Form
- The form starts with two main dropdown menus: Main Category and Subcategory.
- Selecting a main category populates the subcategory dropdown.
- Selecting a subcategory loads and displays relevant properties.
- Each property has a dropdown with options, including an "Other" option.
- Selecting "Other" displays a text field for custom input.
- Some properties can be parents to other properties, creating a hierarchy.

### Form Submission
- When the user clicks "Submit", all selected values are displayed in a table.
- The table shows the category, subcategory, and all properties with their selected values.

