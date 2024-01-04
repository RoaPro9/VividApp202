//
//  DrawingModel.swift
//  Vivid
//
//  Created by Roa  on 24/07/1444 AH.
//  
//

import Foundation
import CloudKit

struct drawingModel{
    
    let id: CKRecord.ID
    let  userId : String
    let dateCreated : Date
    let location : CLLocation
    let compressedDrawingBytes = [Date]()
    
    
    init (record:  CKRecord){
        self.id = record.recordID
        self.userId = record[" userId"] as? String ?? ""
        
        
        self.dateCreated = record["dateCreated"] as! Date
        self.location = record["location"] as! CLLocation
        
    }
}

