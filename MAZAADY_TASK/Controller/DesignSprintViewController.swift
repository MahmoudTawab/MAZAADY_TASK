//
//  DesignSprintViewController.swift
//  MAZAADY_TASK
//
//  Created by Mahmoud on 26/03/2025.
//


import UIKit
import AVKit
import AVFoundation

/// Main view controller for displaying design sprint content including:
/// - User profile section
/// - Stories collection
/// - Course categories
/// - Featured courses carousel
class DesignSprintViewController: UIViewController {
    
    // MARK: - Data Sources
    var selectedIndex = 0
    private var courses = DesignSprintMockData.generateMockCourses()
    private let categories = ["All", "UI/UX", "Developers", "Illustration", "3D Animation"]
    
    private var stories: [StoryItem] = [
        StoryItem(userImage: UIImage(named: "Avatar"), videoURL: URL(string: "https://static.videezy.com/system/resources/previews/000/037/813/original/WH038.mp4")),
        StoryItem(userImage: UIImage(named: "Avatar 1"), videoURL: URL(string: "https://static.videezy.com/system/resources/previews/000/003/761/original/sleddogs.mp4")),
        StoryItem(userImage: UIImage(named: "Avatar 2"), videoURL: URL(string: "https://static.videezy.com/system/resources/previews/000/003/758/original/reindeer.mp4")),
        StoryItem(userImage: UIImage(named: "Avatar 3"), videoURL: URL(string: "https://static.videezy.com/system/resources/previews/000/003/731/original/walkoffame.mp4")),
        StoryItem(userImage: UIImage(named: "Avatar 4"), videoURL: URL(string: "https://static.videezy.com/system/resources/previews/000/003/757/original/moose.mp4")),
        StoryItem(userImage: UIImage(named: "Avatar 5"), videoURL: URL(string: "https://static.videezy.com/system/resources/previews/000/003/751/original/carabou.mp4"))
    ]
    
    // MARK: - UI Components
    
    // Profile Section
    private let profileView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.fromRGB(246, 247, 250, alpha: 1)
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user")
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let badgeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.fromRGB(78, 212, 66, alpha: 1)
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hallo, Samuel!"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let pointsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "award")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let pointsLabel: UILabel = {
        let label = UILabel()
        let fullText = "+1600 Points"
        let boldFont = UIFont.boldSystemFont(ofSize: 15)
        let regularFont = UIFont.systemFont(ofSize: 15)
        
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [.font: regularFont])
        
        if let range = fullText.range(of: "+1600") {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttributes([.font: boldFont], range: nsRange)
        }
        
        label.attributedText = attributedString
        label.textColor = .systemYellow
        return label
    }()
    
    
    private let bellButton: NotificationBellButton = {
        let BellButton = NotificationBellButton(frame: CGRect.zero)
        BellButton.translatesAutoresizingMaskIntoConstraints = false
        return BellButton
    }()
    
    // Stories Collection
    private let StoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        cv.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: "StoryCell")
        return cv
    }()
    
    // Courses Section
    private let titleLabel: UILabel = {
        let label = UILabel()
        let fullText = "Upcoming course of this week"
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        let regularFont = UIFont.systemFont(ofSize: 19)
        
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [.font: regularFont])
        
        if let range = fullText.range(of: "Upcoming") {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttributes([.font: boldFont], range: nsRange)
        }
        
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()

    
    lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        return collectionView
    }()
    
    let CollectionDetailsId = "CollectionDetails"
    lazy var CollectionDetails: FSPagerView = {
        let View = FSPagerView()
        View.delegate = self
        View.isInfinite = true
        View.dataSource = self
        View.interitemSpacing = 15
        View.isScrollEnabled = true
        View.backgroundColor = .clear
        View.collectionView.ContentInsetLeft = 0
        View.translatesAutoresizingMaskIntoConstraints = false
        View.transformer = FSPagerViewTransformer(type: .linear)
        View.register(DetailsCell.self, forCellWithReuseIdentifier: CollectionDetailsId)
        View.itemSize = CGSize(width: view.frame.width - 60, height: 380)
        return View
    }()
    
    lazy var PageControl : WOPageControl = {
        let Page = WOPageControl()
        Page.numberOfPages = 3
        Page.padding = 10
        Page.radius = 3.5
        Page.delegate = self
        Page.enableTouchEvents = true
        Page.tintColor = UIColor.fromRGB(199, 201, 217, alpha: 1)
        Page.currentPageTintColor = UIColor.fromRGB(236, 95, 95, alpha: 1)
        Page.translatesAutoresizingMaskIntoConstraints = false
        return Page
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    // MARK: - Setup Methods
    
    private func setupViews() {
        view.backgroundColor = .white

        // Add subviews
        view.addSubview(profileView)
        view.addSubview(profileImageView)
        view.addSubview(badgeView)
        view.addSubview(nameLabel)
        view.addSubview(pointsImage)
        view.addSubview(pointsLabel)
        view.addSubview(bellButton)
        view.addSubview(StoryCollectionView)
        view.addSubview(categoriesCollectionView)
        view.addSubview(titleLabel)
        
        view.addSubview(CollectionDetails)
        view.addSubview(PageControl)
        
        StoryCollectionView.delegate = self
        StoryCollectionView.dataSource = self
    }

    private func setupConstraints() {
        // Disable automatic constraints
        [profileView ,profileImageView, badgeView , nameLabel,pointsImage ,pointsLabel, bellButton,StoryCollectionView,titleLabel,categoriesCollectionView,CollectionDetails,PageControl]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileView.widthAnchor.constraint(equalToConstant: 50),
            profileView.heightAnchor.constraint(equalToConstant: 50),
            
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            badgeView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            badgeView.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 2),
            badgeView.widthAnchor.constraint(equalToConstant: 14),
            badgeView.heightAnchor.constraint(equalToConstant: 14),

            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor,constant: 3),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20),

            pointsImage.widthAnchor.constraint(equalToConstant: 20),
            pointsImage.heightAnchor.constraint(equalToConstant: 28),
            pointsImage.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            pointsImage.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            
            pointsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            pointsLabel.heightAnchor.constraint(equalToConstant: 30),
            pointsLabel.leadingAnchor.constraint(equalTo: pointsImage.trailingAnchor, constant: 8),
            pointsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),

            bellButton.widthAnchor.constraint(equalToConstant: 26),
            bellButton.heightAnchor.constraint(equalToConstant: 26),
            bellButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            bellButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            StoryCollectionView.heightAnchor.constraint(equalToConstant: 120),
            StoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            StoryCollectionView.topAnchor.constraint(equalTo: profileView.bottomAnchor,constant: 10),
            StoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 15),
            titleLabel.topAnchor.constraint(equalTo: StoryCollectionView.bottomAnchor,constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15),
            
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 70),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 5),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            CollectionDetails.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -100),
            CollectionDetails.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor,constant: 10),
            CollectionDetails.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -50),
            CollectionDetails.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            PageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -90),
            PageControl.heightAnchor.constraint(equalToConstant: 20),
            PageControl.widthAnchor.constraint(equalToConstant: 200),
            PageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        PageControl.numberOfPages = courses.count
        bellButton.setBadgeVisible(true)
    }
}



// MARK: - CollectionView Delegates
extension DesignSprintViewController: UICollectionViewDelegate ,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == StoryCollectionView ? stories.count : categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == StoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCell", for: indexPath) as! StoryCollectionViewCell
            let story = stories[indexPath.item]
            cell.configure(with: story)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            cell.configure(with: categories[indexPath.item], isSelected: indexPath.item == selectedIndex)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == StoryCollectionView {
            return CGSize(width: 80, height: 80)
        }else{
            let width = categories[indexPath.item].size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]).width + 32
            return CGSize(width: width, height: 45)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == StoryCollectionView {
            let story = stories[indexPath.item]
            presentStoryPlayer(with: story)
        }else{
        selectedIndex = indexPath.item
        collectionView.reloadData()
        }
    }
    
    // MARK: - Helper Methods
    private func presentStoryPlayer(with story: StoryItem) {
        if let videoURL = story.videoURL {
            let playerViewController = AVPlayerViewController()
            let player = AVPlayer(url: videoURL)
            playerViewController.player = player
            
            present(playerViewController, animated: true) {
                player.play()
            }
        }
    }

}

// MARK: - FSPagerView Delegates
extension DesignSprintViewController : FSPagerViewDelegate, FSPagerViewDataSource ,CHIBasePageControlDelegate  {
        
    func numberOfItems(in pagerView: FSPagerView) -> Int {
    return courses.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CollectionDetailsId, at: index) as! DetailsCell
        let course = courses[index]
        cell.configure(
            courseImage: UIImage(named: course.courseImage),
            title: course.title,
            position: course.position,
            instructorImage: UIImage(named: course.instructorImage),
            instructorName: course.instructorName,
            duration: course.duration,
            lessons: "\(course.lessonCount) lessons",
            tags: course.tags.map { $0.rawValue }
        )
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        PageControl.set(progress: index, animated: true)
        CollectionDetails.selectItem(at: index, animated: true)
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        PageControl.set(progress: pagerView.currentIndex, animated: true)
    }
    
    func didTouch(pager: CHIBasePageControl, index: Int) {
        CollectionDetails.selectItem(at: index, animated: true)
    }
}



// MARK: - UIColor Extension
extension UIColor {
    /// Convenience method to create UIColor from RGB values (0-255)
    static func fromRGB(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
}
