//
//  MapSearchingViewModel.swift
//  AccuterraSampleApp
//
//  Created by Brian Elliott on 4/27/20.
//  Copyright © 2020 NeoTreks, Inc. All rights reserved.
//

import SwiftUI
import MapKit
import AccuTerraSDK
import Combine

class MapSearchingViewModel: NSObject, ObservableObject {
    
    @Published var isSearching = false
    @Published var searchQuery = ""
    @Published var trails = [TrailItem]()
    @Published var selectedMapItem: MKMapItem?
    @Published var keyboardHeight: CGFloat = 0
    var trailService: ITrailService?
    var cancellable: AnyCancellable?
    
    override init() {
        super.init()

        cancellable = $searchQuery.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] (searchTerm) in
                self?.performSearch(query: searchTerm)
        }
        
        listenForKeyboardNotifications()
    }
    
    func getColoradoBounds() -> MapBounds {
        return try! MapBounds( minLat: 37.99906, minLon: -109.04265, maxLat: 41.00097, maxLon: -102.04607)
    }
    
    private func performSearch(query: String) {
        do {
            isSearching = true
            
            if self.trailService == nil {
                trailService = ServiceFactory.getTrailService()
            }

            print("perform search ... top query: \(query) | isSearching: \(self.isSearching)")
            let searchCriteria = TrailMapBoundsSearchCriteria(
                mapBounds: getColoradoBounds(),
                nameSearchString: query,
                techRating: nil,
                userRating: nil,
                length: nil,
                orderBy: OrderBy(),
                limit: Int(INT32_MAX))
            let basicInfoList = try trailService?.findTrails(byMapBoundsCriteria: searchCriteria)
            print("perform search . \(String(describing: basicInfoList?.count))")
            if let infoList = basicInfoList {
                self.trails = []
                var trailIds:Array<Int64> = []
                for item in infoList {
                    print("perform search name: \(item.name)")
                    self.trails.append(TrailItem(trailId: item.id, title: item.name, description: item.highlights, distance: item.length, rating:item.userRating, difficultyLow:item.techRatingLow, difficultyHigh: item.techRatingHigh))
                    trailIds.append(item.id)
                    // self.testArray.append(item.name)
                    trailIds.append(item.id)
                }
                for i in trailIds {
                    print("trail id: \(i)")
                }
                self.isSearching = false
            }
        }
        catch {
            print("\(error)")
        }
    }
        
    private func listenForKeyboardNotifications() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] (notification) in
            guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            let keyboardFrame = value.cgRectValue
            let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
            
            withAnimation(.easeOut(duration: 0.25)) {
                self?.keyboardHeight = keyboardFrame.height - window!.safeAreaInsets.bottom
            }
            print(keyboardFrame.height)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] (notification) in
            withAnimation(.easeOut(duration: 0.25)) {
                self?.keyboardHeight = 0
            }
            
        }
    }
}

