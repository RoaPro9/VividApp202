//
//  ARManager.swift
//  Vivid
//
//  Created by Roa Moha on 15/11/1444 AH.
//  Copyright © 1444 AH Vivid App. All rights reserved.
//

import Foundation
import Foundation
import Combine

class ARManager {
    static let shared = ARManager()
    private init(){}
    
    var actionStream = PassthroughSubject< ARAction, Never> ()
    
}
