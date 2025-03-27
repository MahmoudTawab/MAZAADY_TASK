//
//  DesignSprintCourse.swift
//  MAZAADY_TASK
//
//  Created by Mahmoud on 27/03/2025.
//

import Foundation

// MARK: - DesignSprintCourse Models
struct DesignSprintCourse {
    let id: UUID
    let courseImage: String
    let title: String
    let position: String
    let instructorImage: String
    let instructorName: String
    let duration: String
    let lessonCount: Int
    let tags: [CourseTag]
    let isFree: Bool
}

// MARK: - CourseTag enum
enum CourseTag: String {
    case uiUx = "UI/UX"
    case free = "Free"
    case beginner = "Beginner"
    case design = "Design"
}

class DesignSprintMockData {
    static func generateMockCourses() -> [DesignSprintCourse] {
        return [
            DesignSprintCourse(
                id: UUID(),
                courseImage: "Avatar 3",
                title: "Laurel Seilha Step design sprint for beginner",
                position: "UI Design",
                instructorImage: "user",
                instructorName: "Laurel Seilha",
                duration: "5h 21m",
                lessonCount: 6,
                tags: [.uiUx, .free],
                isFree: true
            ),
            DesignSprintCourse(
                id: UUID(),
                courseImage: "Avatar 4",
                title: "John Doe UX Design Fundamentals",
                position: "UX Design",
                instructorImage: "user2",
                instructorName: "John Doe",
                duration: "7h 45m",
                lessonCount: 8,
                tags: [.uiUx, .beginner],
                isFree: false
            ),
            DesignSprintCourse(
                id: UUID(),
                courseImage: "Avatar 5",
                title: "Sarah Smith Design Thinking Masterclass",
                position: "Design",
                instructorImage: "user3",
                instructorName: "Sarah Smith",
                duration: "9h 15m",
                lessonCount: 10,
                tags: [.design, .uiUx],
                isFree: false
            )
        ]
    }
}


