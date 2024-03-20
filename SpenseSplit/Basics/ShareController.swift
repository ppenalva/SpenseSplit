//
//  ShareController.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 9/2/24.
//

import CloudKit
//import Foundation
import SwiftUI
//import UIKit

struct CloudSharingView: UIViewControllerRepresentable {
    let share: CKShare
    let container: CKContainer
    let party: Party
    
    func makeCoordinator() -> CloudSharingCoordinator {
        CloudSharingCoordinator.shared
    }

    func makeUIViewController(context: Context) -> UICloudSharingController {
        share[CKShare.SystemFieldKey.title] = party.name
        let controller = UICloudSharingController(share: share, container: container)
       
        controller.modalPresentationStyle = .formSheet
        controller.delegate = context.coordinator
        context.coordinator.party = party
        return controller
    }

    func updateUIViewController(_ uiViewController: UICloudSharingController, context: Context) {

    }
}


class CloudSharingCoordinator:NSObject,UICloudSharingControllerDelegate{
    
    static let shared = CloudSharingCoordinator()
    let stack = CoreDataStack.shared
    var party: Party?
    
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print("failed to save share\(error)")
    }

    func itemTitle(for csc: UICloudSharingController) -> String? {
        party?.name
    }

    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController){
        
    }

    func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController){

//        guard let match = match else {return}
//        if !stack.isOwner(object: match) {
//            stack.context.delete(match)
//            stack.save()
//            print("desconectado march")
//        }
//        else {
//
//        }
    }
}
