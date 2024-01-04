//
//  UserViewModel.swift
//  Vivid
//
//  Created by Roa  on 24/07/1444 AH.
//
//

import Foundation
import CloudKit
import SwiftUI


class CloudKitUserBootViewModel: ObservableObject {

@Published var permissionStatus: Bool = false
@Published var isSignedInToiCloud: Bool = false
@Published var error: String = ""
@Published var userName: String = ""
let container = CKContainer(identifier: "iCloud.VividApp")

init() {
    getiCloudStatus()
    requestPermission()
    fetchiCloudUserRecordID()
}

private func getiCloudStatus() {
    container.accountStatus { [weak self] returnedStatus, returnedError in
        DispatchQueue.main.async {
            switch returnedStatus {
            case .available:
                self?.isSignedInToiCloud = true
            case .noAccount:
                self?.error = CloudKitError.iCloudAccountNotFound.rawValue
            case .couldNotDetermine:
                self?.error = CloudKitError.iCloudAccountNotDetermined.rawValue
            case .restricted:
                self?.error = CloudKitError.iCloudAccountRestricted.rawValue
            default:
                self?.error = CloudKitError.iCloudAccountUnknown.rawValue
            }
        }
    }
}

enum CloudKitError: String, LocalizedError {
    case iCloudAccountNotFound
    case iCloudAccountNotDetermined
    case iCloudAccountRestricted
    case iCloudAccountUnknown
}

func requestPermission() {
    container.requestApplicationPermission([.userDiscoverability]) { [weak self] returnedStatus, returnedError in
        DispatchQueue.main.async {
            if returnedStatus == .granted {
                self?.permissionStatus = true
            }
        }
    }
}

func fetchiCloudUserRecordID() {
    container.fetchUserRecordID { [weak self] returnedID, returnedError in
        if let id = returnedID {
            self?.discoveriCloudUser(id: id)
        }
    }
}

func discoveriCloudUser(id: CKRecord.ID) {
    container.discoverUserIdentity(withUserRecordID: id) { [weak self] returnedIdentity, returnedError in
        DispatchQueue.main.async {
            if let name = returnedIdentity?.nameComponents?.givenName {
                self?.userName = name
            }
        }
    }
}
}

struct CloudKitUserBoot: View {

@StateObject private var vm = CloudKitUserBootViewModel ()

var body: some View {
    VStack {
        Text("IS SIGNED IN: \(vm.isSignedInToiCloud.description.uppercased())")
        Text(vm.error)
        Text("Permission: \(vm.permissionStatus.description.uppercased())")
        Text("NAME: \(vm.userName)")
    }
}
}

struct CloudKitUserBoot_Previews: PreviewProvider {
static var previews: some View {
CloudKitUserBoot()
}
}

class userViewModel : ObservableObject {
    
    @Published var user : [String] = []
    @StateObject private var vmCloud = CloudKitUserBootViewModel()
    init (){}
    
    func addUser () {
        
     // let newUser = CKRecord(recordType: "Users")
       
//        vmCloud.container.publicCloudDatabase.save(newUser) { record, error in
//            guard error == nil else {
//                print("userViewModel.addUser", error?.localizedDescription)
//                return
//            }
//
//        }
        
    }
    
    
    
    
    
    
}
