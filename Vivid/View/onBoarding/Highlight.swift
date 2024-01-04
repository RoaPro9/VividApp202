//
//  Highlight.swift
//  Vivid
//
//  Created by SAF on 26/11/1444 AH.
//  Copyright © 1444 AH Vivid App. All rights reserved.
//

import SwiftUI

// Highlight View Properties
struct Highlight: Identifiable, Equatable {
    var id: UUID = .init()
    var anchor: Anchor<CGRect>
    var title: String
    var des: String
    var cornerRadius: CGFloat
    var style: RoundedCornerStyle = .continuous
    var scale: CGFloat = 1
    
    // Check if the highlight has been shown before
    static func hasShownHighlight() -> Bool {
        return false
        let hasShown = UserDefaults.standard.bool(forKey: "hasShownHighlight")
        return hasShown
    }
    
    // Set the flag to indicate the highlight has been shown
    static func setShownHighlight() {
        UserDefaults.standard.set(true, forKey: "hasShownHighlight")
    }
}
