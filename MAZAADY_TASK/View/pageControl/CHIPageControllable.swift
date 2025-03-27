//
//  CHIPageControllable.swift
//  MAZAADY_TASK
//
//  Created by Mohamed Tawab on 26/03/2025.
//

import Foundation
import CoreGraphics
import UIKit

protocol CHIPageControllable: AnyObject {
    var numberOfPages: Int { get set }
    var currentPage: Int { get }
    var progress: Double { get set }
    var hidesForSinglePage: Bool { get set }
    var borderWidth: CGFloat { get set }

    func set(progress: Int, animated: Bool)
}
