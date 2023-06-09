//
//  SyncDataManager.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 08/06/2023.
//

import Foundation


//class SyncDataManager {
//    
//    private let reachabilityManager = NetworkReachabilityManager()
//    private let networkManager = NetworkManager()
//
//    
//    func startObserving() {
//        
//        reachabilityManager?.startListening(onUpdatePerforming: { status in
//            if self.reachabilityManager?.isReachable ?? false {
//                
//                switch status {
//                    
//                case .reachable:
//                    
//                    CustomReachability.isInternetAvailable(completionHandler: { (isConnected) in
//                        NotificationCenter.default.post(name: isConnected ? kNotifKeys.ReachabilityStatus.Reachable : kNotifKeys.ReachabilityStatus.NotReachable, object: nil)
//                        isConnected ? self.connected() : self.notConnected()
//                    })
//                    
//                default:
//                    NotificationCenter.default.post(name: kNotifKeys.ReachabilityStatus.NotReachable, object: nil)
//                    self.notConnected()
//                    
//                }
//            } else {
//                NotificationCenter.default.post(name: kNotifKeys.ReachabilityStatus.NotReachable, object: nil)
//                self.notConnected()
//                
//            }
//        })
//    }
//    
//    
//    func connected() {
//        print("Sync Data Manager Observer: Internet Connection")
//        DispatchQueue.main.async {
//            self.syncCompletedContents()
//            self.syncCompletedBundles()
//        }
//    }
//    
//    func notConnected() {
//        print("Sync Data Manager Observer: No Internet Connection")
//    }
//    
//    
//    
//    func syncCompletedContents() {
//        
//        guard let contents = B2BRealmManager.shared.fetchStudioContents(isSynced: false), contents.count > 0,
//            let fitnessStudio = B2BRealmManager.shared.fetchObjects(type: B2BFitnessStudio.self)?.first as? B2BFitnessStudio else { return }
//
//        var itemsToBeSynced = [[ContentCompletionParam: Any]]()
//        
//        for eachContent in contents {
//            
//            var contentParams: [ContentCompletionParam: Any] = [.bundleID: eachContent.bundle_id,
//                                                                .contentID: eachContent.id,
//                                                                .week: fitnessStudio.fitness_bundle_current_week.value!]
//            
//            if eachContent.is_duplicated {
//                contentParams.updateValue(eachContent.dup_index, forKey: ContentCompletionParam.dupIndex)
//            }
//            
//            itemsToBeSynced.append(contentParams)
//        }
//        
//        
//        networkManager.markContentAsCompleted(params: itemsToBeSynced) { (error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            
//            print("All contents completion synced in background")
//        }
//    }
//
//    
//    
//    func syncCompletedBundles() {
//        
//        guard let bundles = B2BRealmManager.shared.fetchStudioBundles(isSynced: false), bundles.count > 0,
//            let fitnessStudio = B2BRealmManager.shared.fetchObjects(type: B2BFitnessStudio.self)?.first as? B2BFitnessStudio else { return }
//        
//        var bundlesToBeSynced = [[BundleCompletionParam: Any]]()
//        
//        for eachBundle in bundles {
//            
//            let bundleParams: [BundleCompletionParam: Any] = [.bundleID: eachBundle.id,
//                                                                .week: fitnessStudio.fitness_bundle_current_week.value!]
//            
//
//            bundlesToBeSynced.append(bundleParams)
//        }
//        
//        
//        networkManager.markBundleAsCompleted(params: bundlesToBeSynced) { (error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            
//            print("All bundles completion synced in background")
//        }
//    }
//    
//    
//    
//}
