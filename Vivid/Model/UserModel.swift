//
//  UserModel.swift
//  Vivid
//
//  Created by Roa  on 24/07/1444 AH.
//  


import Foundation
import CloudKit
import SwiftUI

struct userModel {
    let Id : CKRecord.ID
    let name : String
    
    var drawing :[String] = []
    init (record:  CKRecord){
        self.Id = record.recordID
        self.name = record["name"] as? String ?? ""
        self.drawing = record["drawing"] as? [String] ?? ["", "", ""]
        
    }
}
