//
//  Constants.swift
//  SampleApplication
//
//  Created by jabari on 1/30/21.
//

import CoreGraphics
import Foundation

// MARK: - String Constants

extension String {
    static let defaultUserName = "jabaridash"
    static let titleText = "Here you can find any GitHub user you would like!"
    static let buttonText = "Find user"
    static let textFieldPlaceholder = "Enter username"
    static let alertErrorTitle = "Oops"
    static let alertErrorMessagePrefix = "We were unable to find user"
    static let repositoriesTitle = "Repositories:"
    static let clearCacheButtonText = "Clear Cache"
    static let ok = "Ok"
}

// MARK: - CGFloat Constants

extension CGFloat {
    static let buttonCornerRadius: CGFloat = 8
    static let minTextFieldHeight: CGFloat = 60
    static let dividerHeight: CGFloat = 1
    static let dividerPadding: CGFloat = 16
    static let headerVStackSpacing: CGFloat = 16
    static let listItemVStackSpacing: CGFloat = 8
    static let imageShadowRadius: CGFloat = 10
}
